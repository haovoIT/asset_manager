import 'dart:async';

import 'package:assets_manager/bloc/diary_edit_bloc.dart';
import 'package:assets_manager/bloc/diary_edit_bloc_provider.dart';
import 'package:assets_manager/classes/money_format.dart';
import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../global_widget/asset_widget/index.dart';

class UpdateValueAssetPage extends StatefulWidget {
  final double accumulatedDouble;
  final int numberMonths;
  final bool flag;
  final String idDepartment;
  final String originalPrice;
  final String usedTime;
  const UpdateValueAssetPage({
    Key? key,
    required this.accumulatedDouble,
    required this.numberMonths,
    required this.flag,
    required this.idDepartment,
    required this.originalPrice,
    required this.usedTime,
  }) : super(key: key);

  @override
  _UpdateValueAssetPageState createState() => _UpdateValueAssetPageState();
}

class _UpdateValueAssetPageState extends State<UpdateValueAssetPage> {
  DiaryEditBloc? _diaryEditBloc;
  TextEditingController _nameAssetController = new TextEditingController();
  TextEditingController _originalPriceController = new TextEditingController();
  TextEditingController _usedTimeController = new TextEditingController();
  TextEditingController _depreciationController = new TextEditingController();
  TextEditingController _detailController = new TextEditingController();
  TextEditingController _startDateController = new TextEditingController();
  String errorMessage = "";
  List<String?> validateGroup = [];
  int userTimeInt = 12;
  double depreciationDouble = 0;
  double residualDouble = 0;
  int residualMonthInt = 0;

  @override
  void initState() {
    super.initState();
    userTimeInt = int.parse(widget.usedTime);
    _originalPriceController = MoneyMaskedTextControllers(
      thousandSeparator: '.',
      initialValue: 0,
    );
    _depreciationController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _diaryEditBloc = DiaryEditBlocProvider.of(context)!.diaryEditBloc;
  }

  void _addOrUpdate() {
    _diaryEditBloc?.idDepartmentEditChanged.add(widget.idDepartment);
    _diaryEditBloc?.saveEditChanged.add('Save');
  }

  onChangedFunctionUsedTime(selected) {
    _usedTimeController.text = selected;
    _diaryEditBloc?.usedTimeEditChanged.add(selected);
    setState(() {
      userTimeInt = int.parse(selected);
    });
    final endDate =
        Alert.addMonth(int.parse(selected), _startDateController.text);
    _diaryEditBloc?.endDateEditChanged.add(endDate);
    depreciationDouble = Alert.onChangeDepreciation(
      userTimeInt: userTimeInt,
      numberMonths: widget.numberMonths,
      originalPrice: _originalPriceController.text,
      accumulatedDouble: widget.accumulatedDouble,
    );
    _diaryEditBloc?.depreciationEditChanged
        .add(depreciationDouble.toInt().toVND());
  }

  Timer _debounce = Timer(Duration(seconds: 0), () {});

  onChangeFunctionOriginalPrice(originalPrice) {
    if (_debounce.isActive) {
      _debounce.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 2000), () {
      _diaryEditBloc?.originalPriceEditChanged
          .add(Alert.getOnlyNumbers(originalPrice).toVND());
      depreciationDouble = Alert.onChangeDepreciation(
        userTimeInt: userTimeInt,
        numberMonths: widget.numberMonths,
        originalPrice: originalPrice,
        accumulatedDouble: widget.accumulatedDouble,
      );
      _diaryEditBloc?.depreciationEditChanged
          .add(depreciationDouble.toInt().toVND());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCustom(
            title: widget.flag ? 'Nâng Cấp Tài sản' : "Xác nhận chuyển đổi"),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: GlobalStyles.paddingPageLeftRight_15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        NameAssets(
                          stream: _diaryEditBloc?.nameAssetEdit,
                          sink: _diaryEditBloc?.nameAssetEditChanged,
                          nameAssetController: _nameAssetController,
                          readOnly: true,
                        ),
                        GlobalStyles.sizedBoxHeight, //Tên TS //Tên TS
                        OriginalPrice(
                          stream: _diaryEditBloc?.originalPriceEdit,
                          originalPriceController: _originalPriceController,
                          readOnly: false,
                          onChangeFunction: onChangeFunctionOriginalPrice,
                        ),
                        GlobalStyles.sizedBoxHeight, //Nguyên Giá
                        UsedTime(
                          usedTimeController: _usedTimeController,
                          stream: _diaryEditBloc?.usedTimeEdit,
                          onChangedFunction: onChangedFunctionUsedTime,
                          userTimes: userTimeInt,
                        ), //TGSD
                        GlobalStyles.sizedBoxHeight, //TGSD
                        StartDate(
                          stream: _diaryEditBloc?.starDateEdit,
                          sinkEndDate: _diaryEditBloc?.endDateEditChanged,
                          sinkStartDate: _diaryEditBloc?.starDateEditChanged,
                          userTime: userTimeInt,
                          flagStartDate: false,
                          startDateController: _startDateController,
                        ),
                        GlobalStyles.sizedBoxHeight, //NgayBD
                        EndDate(
                          stream: _diaryEditBloc?.endDateEdit,
                        ),
                        GlobalStyles.sizedBoxHeight, //NgayKT
                        ChooseDetail(
                          stream: _diaryEditBloc?.detailEdit,
                          sink: _diaryEditBloc?.detailEditChanged,
                          detailController: _detailController,
                        ), //Lydo
                        DepreciationWidget(
                          stream: _diaryEditBloc?.depreciationEdit,
                          sink: _diaryEditBloc?.depreciationEditChanged,
                          depreciationController: _depreciationController,
                          readOnly: true,
                        ), //khauhao//Save
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
                textHint: CommonString.CANCEL,
                onFunction: () => Navigator.pop(context),
                labelColor: AppColors.blacks,
                backgroundColor: AppColors.white,
                padding: GlobalStyles.paddingPageLeftRightHV_36_12,
                fontSize: 24,
              ),
              ButtonCustom(
                textHint: CommonString.SAVE,
                onFunction: () => onSave(),
                labelColor: AppColors.white,
                backgroundColor: AppColors.main,
                padding: GlobalStyles.paddingPageLeftRightHV_36_12,
                fontSize: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  resetError() {
    if (errorMessage.isNotEmpty) {
      setState(() {
        errorMessage = "";
      });
    }
  }

  onSave() {
    resetError();
    validateGroup = widget.flag
        ? [
            Validators().empty(
                _nameAssetController.text, AssetString.REQUIRE_NAME_ASSETS),
            Validators().money(_originalPriceController.text,
                AssetString.REQUIRE_ORIGINAL_PRICE),
            Validators().checkUpdateValueAsset(
                Alert.getOnlyNumbers(widget.originalPrice),
                Alert.getOnlyNumbers(_originalPriceController.text),
                widget.usedTime,
                _usedTimeController.text,
                CommonString.ERROR_MASSAGE_UPDATE_VALUE_ASSET),
            Validators()
                .empty(_detailController.text, AssetString.REQUIRE_DETAIL),
          ]
        : [
            Validators()
                .empty(_detailController.text, AssetString.REQUIRE_DETAIL),
          ];
    this.errorMessage = Validators().validateForm(validateGroup) ?? "";
    if (this.errorMessage == "") {
      _addOrUpdate();
      Alert.showResponse(
              successMessage: widget.flag
                  ? AssetString.UPDATE_VALUE_SUCCESS_MASSAGE
                  : AssetString.CONFIRM_CONVERT_SUCCESS_MASSAGE,
              errorMessage: widget.flag
                  ? AssetString.UPDATE_VALUE_ERROR_MASSAGE
                  : AssetString.CONFIRM_CONVERT_ERROR_MASSAGE,
              context: context,
              streamBuilder: _diaryEditBloc?.responseEdit,
              sink: _diaryEditBloc?.responseEditChanged)
          .then((value) {
        var response = value;
        final massage = response['massage'];
        if (massage == DomainProvider.SUCCESS) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    } else {
      Alert.showError(
          title: CommonString.ERROR,
          message: errorMessage,
          buttonText: CommonString.OK,
          context: context);
    }
  }
}
