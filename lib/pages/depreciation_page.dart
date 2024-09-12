import 'package:assets_manager/bloc/bloc_index.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:assets_manager/inPDF/inPDF_ThongTinKhauHao.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/model_index.dart';
import 'package:assets_manager/pages/page_index.dart';
import 'package:assets_manager/services/service_index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:intl/intl.dart';

class Depreciation extends StatelessWidget {
  final String idAsset;
  final String? newIdAsset;
  final int flag;
  final String? idDepartment;

  const Depreciation(
      {Key? key,
      required this.idAsset,
      required this.flag,
      this.idDepartment,
      this.newIdAsset})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationServer =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationServer);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return DiaryBlocProvider(
              diaryBloc: DiaryBloc(DbDiaryService(), _authenticationServer,
                  DbFirestoreService()),
              uid: snapshot.data!,
              child: DepreciationPage(
                idAsset: idAsset,
                flag: flag,
                idDepartment: idDepartment ?? "",
                newIdAsset: newIdAsset,
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Tài Sản.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class DepreciationPage extends StatefulWidget {
  final String idAsset;
  final int flag;
  final String idDepartment;
  final String? newIdAsset;
  const DepreciationPage(
      {Key? key,
      required this.idAsset,
      required this.flag,
      this.newIdAsset,
      required this.idDepartment})
      : super(key: key);

  @override
  _DepreciationPageState createState() => _DepreciationPageState();
}

class _DepreciationPageState extends State<DepreciationPage> {
  DiaryBloc? diaryBloc;
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  List<DiaryModel> list = [];
  DiaryModel diaryModel = new DiaryModel();
  AssetsModel assetsModel = new AssetsModel();
  String buttonText = "";

  double depreciationDouble = 0;
  double accumulatedDouble = 0;
  double residualDouble = 0;
  int originalPrice = 0;
  int usedTime = 0;
  int numberMonths = 0;

  @override
  void initState() {
    switch (widget.flag) {
      case 1:
        buttonText = AssetString.BUTTON_TEXT_LIQUIDATION;
        break;
      case 2:
        buttonText = AssetString.BUTTON_TEXT_UPDATE_ASSET;
        break;
      case 3:
        buttonText = AssetString.BUTTON_TEXT_CONTINUE;
        break;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    diaryBloc = DiaryBlocProvider.of(context)?.diaryBloc;

    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    diaryBloc?.idAssetEditChanged.add(widget.idAsset);
  }

  void _addOrEdit({
    required bool add,
    required DiaryModel diaryModel,
    required int numberMonths,
    required bool flag,
    required String idDepartment,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => DiaryEditBlocProvider(
                diaryEditBloc: DiaryEditBloc(
                    dbDiaryApi: DbDiaryService(),
                    dbApi: DbFirestoreService(),
                    add: add,
                    selectDiaryModel: diaryModel),
                child: UpdateValueAssetPage(
                  accumulatedDouble: accumulatedDouble,
                  numberMonths: numberMonths,
                  flag: flag,
                  idDepartment: idDepartment,
                  originalPrice: diaryModel.originalPrice ?? "",
                  usedTime: diaryModel.usedTime ?? "",
                ),
              ),
          fullscreenDialog: true),
    );
  }

  void _addOrEditThanhLy({required bool add, required ThanhLy thanhLy}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ThanhLyEditBlocProvider(
                thanhLyEditBloc:
                    ThanhLyEditBloc(DbThanhLyService(), add, thanhLy),
                child: ThanhLyEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  createPDF() async {
    if (assetsModel.nameAsset != null &&
        assetsModel.nameAsset?.isNotEmpty == true) {
      final pdfFile = await PdfThongTinKHApi.generate(
          assetsModel,
          list,
          depreciationDouble.toInt().toVND(),
          accumulatedDouble.toInt().toVND(),
          residualDouble.toInt().toVND(),
          email,
          name);

      PdfApi.openFile(pdfFile, context);
    }
  }

  onHandle() {
    if (widget.flag == 1) {
      _addOrEditThanhLy(
          add: true,
          thanhLy: ThanhLy(
              documentID: diaryModel.qrCode,
              Ten_ts: diaryModel.nameAsset,
              Ma_pb: diaryModel.idDepartment,
              Don_vi_TL: '',
              Nguyen_gia_TL: residualDouble.toInt().toVND(),
              Ngay_TL: ''));
    } else if (widget.flag == 2) {
      _addOrEdit(
          add: true,
          diaryModel: diaryModel,
          numberMonths: numberMonths,
          flag: true,
          idDepartment: widget.idDepartment);
    } else if (widget.flag == 3) {
      var addDiaryModel = diaryModel;
      addDiaryModel.idAsset = widget.newIdAsset;
      _addOrEdit(
          add: true,
          diaryModel: addDiaryModel,
          numberMonths: numberMonths,
          flag: false,
          idDepartment: widget.idDepartment);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: true,
          appBar: AppBarCustom(
            title: AssetString.DEPRECIATION_ASSETS,
            actions: [
              IconButton(
                  onPressed: createPDF,
                  icon: Icon(
                    Icons.print,
                    color: AppColors.white,
                  )),
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.mainSub,
                  )),
              Container(
                width: 15.0,
              ),
            ],
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: GlobalStyles.paddingPageLeftRight_15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          StreamBuilder(
                              stream: diaryBloc?.listDiaryModel,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  return _buildListViewSeparated(
                                      snapshot.data?.data);
                                } else {
                                  return Center(
                                    child: Container(
                                      child: Text('Thêm Tài Sản.'),
                                    ),
                                  );
                                }
                              }),
                          StreamBuilder(
                              stream: diaryBloc?.assets,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  assetsModel = snapshot.data!;
                                  return SizedBox();
                                }
                                return SizedBox();
                              }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            width: double.infinity,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ButtonCustom(
                  textHint: buttonText,
                  onFunction: () => onHandle(),
                  labelColor: AppColors.white,
                  backgroundColor: AppColors.main,
                  padding: GlobalStyles.paddingPageLeftRightHV_36_12,
                  fontSize: 20,
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildListViewSeparated(data) {
    list = data;
    if (list.isNotEmpty) {
      int length = list.length;
      if (length > 1) {
        diaryModel = list[length - 1];
      } else if (length > 0 && length < 2) {
        diaryModel = list.first;
      }
      int index = 0;
      DateTime now = DateTime.now();
      DateTime start = DateTime.parse(list[0].starDate!);

      if (length == 1) {
        numberMonths = month(start, now);
        depreciationDouble =
            double.parse(Alert.getOnlyNumbers(diaryModel.depreciation ?? ""));
        accumulatedDouble = depreciationDouble * numberMonths;
        residualDouble =
            double.parse(Alert.getOnlyNumbers(diaryModel.originalPrice ?? "")) -
                accumulatedDouble;
      } else if (length > 1) {
        start = DateTime.parse(list[0].starDate ?? "");
        for (index = 0; index < length; index++) {
          double _depreciation = double.parse(
              Alert.getOnlyNumbers(list[index].depreciation ?? ""));
          if (index == 0) {
            accumulatedDouble += _depreciation *
                month(DateTime.parse(list[index].starDate ?? ""),
                    DateTime.parse(list[index + 1].dateUpdate ?? ""));
          } else if (index > 0 && index != length - 1) {
            accumulatedDouble += _depreciation *
                month(DateTime.parse(list[index].dateUpdate ?? ""),
                    DateTime.parse(list[index + 1].dateUpdate ?? ""));
          } else if (index > 0 && index == length - 1) {
            accumulatedDouble += _depreciation *
                month(DateTime.parse(list[index].dateUpdate ?? ""), now);
          }
        }
        originalPrice = int.parse(
            Alert.getOnlyNumbers(list[length - 1].originalPrice ?? ""));
        usedTime =
            int.parse(list[length - 1].usedTime ?? "") - month(now, start);
        numberMonths = month(now, start);
        depreciationDouble = double.parse(
            Alert.getOnlyNumbers(list[length - 1].depreciation ?? ""));
        residualDouble = originalPrice - accumulatedDouble;
      }

      return Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  AssetString.INFO_ASSET_PART,
                  style: TextStyle(
                      color: AppColors.main,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              _titleDetailLeftRight(
                  AssetString.INFO_NAME_ASSETS, diaryModel.nameAsset),
              _titleDetailLeftRight(
                  AssetString.INFO_ORIGINAL_PRICE, diaryModel.originalPrice),
              _titleDetailLeftRight(
                  AssetString.INFO_USER_TIME, diaryModel.usedTime),
              _titleDetailLeftRight(
                  AssetString.INFO_START_DATE,
                  diaryModel.starDate != null &&
                          diaryModel.starDate?.isNotEmpty == true
                      ? DateFormat("dd/ MM/ yyyy")
                          .format(DateTime.parse(diaryModel.starDate!))
                          .toString()
                      : ""),
              _titleDetailLeftRight(
                  AssetString.INFO_END_DATE,
                  diaryModel.endDate != null &&
                          diaryModel.endDate?.isNotEmpty == true
                      ? DateFormat("dd/ MM/ yyyy")
                          .format(DateTime.parse(diaryModel.endDate!))
                          .toString()
                      : ""),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(AssetString.INFO_DEPRECIATION_PART,
                    style: TextStyle(
                        color: AppColors.main,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              _titleDetailLeftRight(AssetString.INFO_DEPRECIATION_MOUNT,
                  depreciationDouble.toInt().toVND()),
              _titleDetailLeftRight(AssetString.INFO_ACCUMULATED_DEPRECIATION,
                  depreciationDouble.toInt().toVND()),
              _titleDetailLeftRight(AssetString.INFO_RESIDUAL_VALUE,
                  residualDouble.toInt().toVND()),
            ],
          ),
        ),
      );
    }
    return SizedBox();
  }

  int month(DateTime start, DateTime now) {
    int sum = now.month - start.month + (now.year - start.year) * 12;
    if (now.day < start.day) {
      sum -= 1;
    }
    return sum;
  }

  Widget _titleDetailLeftRight(_title, _value) {
    final TextEditingController controller = new TextEditingController();
    controller.value = controller.value.copyWith(text: _value);
    return Padding(
        padding: GlobalStyles.paddingPageTopBottom,
        child: CustomTextFromField(
          inputType: TextInputType.text,
          inputAction: TextInputAction.done,
          controller: controller,
          labelText: _title,
          prefixIcon: Icons.assignment_outlined,
          readOnly: true,
        ));
  }
}
