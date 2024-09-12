import 'package:assets_manager/bloc/bloc_index.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/pages/page_index.dart';
import 'package:assets_manager/services/service_index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetsPages extends StatelessWidget {
  final bool flag;

  const AssetsPages({Key? key, required this.flag}) : super(key: key);
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
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), DbHistoryAssetService(),
                  _authenticationServer),
              uid: snapshot.data!,
              child: AssetsPage(
                flag: flag,
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

class AssetsPage extends StatefulWidget {
  final bool flag;
  const AssetsPage({Key? key, required this.flag}) : super(key: key);

  @override
  _AssetsPageState createState() => _AssetsPageState();
}

class _AssetsPageState extends State<AssetsPage> {
  late HomeBloc _homeBloc;
  late String _uid;
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)!.homeBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    _homeBloc.maPBEditChanged.add(maPb);
    _uid = HomeBlocProvider.of(context)!.uid;
  }

  void _addOrEditAsset(
      {required bool add, required AssetsModel assets, required child}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => AssetsEditBlocProvider(
                assetsEditBloc: AssetsEditBloc(
                  add: add,
                  dbApi: DbFirestoreService(),
                  dbHistoryAssetApi: DbHistoryAssetService(),
                  dbDiaryApi: DbDiaryService(),
                  selectAsset: assets,
                ),
                child: child,
              ),
          fullscreenDialog: true),
    );
  }

  void updateAsset({required bool add, required AssetsModel assets}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => AssetsEditBlocProvider(
                assetsEditBloc: AssetsEditBloc(
                  add: add,
                  dbApi: DbFirestoreService(),
                  dbHistoryAssetApi: DbHistoryAssetService(),
                  dbDiaryApi: DbDiaryService(),
                  selectAsset: assets,
                ),
                child: LiquidationConfirmationPage(
                  assetModel: assets,
                ),
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _homeBloc.listAssets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return widget.flag
                  ? _buildListViewAsset(snapshot.data?.data)
                  : _buildListViewDepreciation(snapshot.data?.data);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Tài Sản.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final addAsset = new AssetsModel();
          addAsset.yearOfManufacture = DateTime.now().toString();
          addAsset.status = 'Đang Sử Dụng';
          addAsset.starDate = DateTime.now().toString();
          addAsset.originalPrice = '0.0';
          addAsset.usedTime = '12';
          addAsset.qrCode = DateTime.now().toString();
          addAsset.starDate = DateTime.now().toString();
          addAsset.endDate = Alert.addMonth(12, DateTime.now().toString());
          _addOrEditAsset(
              add: true, assets: addAsset, child: AssetEditPage(flag: true));
        },
        icon: Icon(Icons.add),
        label: Text('Tài sản'),
      ),
    );
  }

  Widget _buildListViewAsset(data) {
    return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final AssetsModel itemAssets = data[index];
          return Dismissible(
            key: Key(data[index].documentID),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.blue,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.history_edu_rounded,
                color: Colors.white,
              ),
            ),
            child: Padding(
              padding: GlobalStyles.paddingPageLeftRight,
              child: ListTile(
                contentPadding: GlobalStyles.paddingAll,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.main)),
                tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
                leading: Image.asset(
                  AppImages.imTitle,
                ),
                title: _itemTitle(itemAssets.code ?? ""),
                subtitle: _itemSubTitle(item: itemAssets),
                onTap: () {
                  _addOrEditAsset(
                      add: false,
                      assets: itemAssets,
                      child: AssetEditPage(flag: false));
                },
                onLongPress: () async {
                  final result = await Alert.showConfirm(
                    context,
                    title: AssetString.CONVERT_ASSET,
                    detail: AssetString.CONTENT_CONVERT_ASSET,
                    btTextTrue: AssetString.ALL_CONVERT_ASSET,
                    btTextFalse: AssetString.PART_CONVERT_ASSET,
                    isClose: true,
                  );
                  if (result == true) {
                    convertAsset(true, itemAssets);
                  } else if (result == false) {
                    convertAsset(false, itemAssets);
                  }
                },
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction.toString() == "DismissDirection.endToStart") {
                bool confirmHistory = await Alert.showConfirm(context,
                    title: AssetString.TITLE_HISTORY,
                    detail: AssetString.CONTENT_CONFIRM_TITLE_HISTORY,
                    btTextTrue: CommonString.CONTINUE,
                    btTextFalse: CommonString.CANCEL);
                if (confirmHistory) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HistoryAsset(
                                qrCode: itemAssets.qrCode ?? "",
                              )));
                }
              } else if (direction.toString() ==
                  "DismissDirection.startToEnd") {
                bool confirmDelete = await await Alert.showConfirm(context,
                    title: AssetString.TITLE_CONFIRM_DELETE,
                    detail: AssetString.DETAIL_CONFIRM_DELETE,
                    btTextTrue: CommonString.CONTINUE,
                    btTextFalse: CommonString.CANCEL);
                if (confirmDelete) {
                  _homeBloc.deleteAssets.add(data[index]);
                }
              }
              return null;
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return GlobalStyles.sizedBoxHeight;
        });
  }

  Widget _itemSubTitle({
    required AssetsModel item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSubTitle(AssetString.INFO_NAME_ASSETS, item.nameAsset),
        GlobalStyles.divider,
        _textSubTitle(AssetString.DEPARTMENTS, item.departmentName),
        GlobalStyles.divider,
        _textSubTitle(AssetString.STATUS, item.status ?? ""),
        GlobalStyles.divider,
        _textSubTitle(
            AssetString.START_DATE,
            item.starDate != "" && item.starDate?.isNotEmpty == true
                ? DateFormat("dd/ MM/ yyyy")
                    .format(DateTime.parse(item.starDate!))
                : ""),
        GlobalStyles.divider,
        _textSubTitle(
            AssetString.END_DATE,
            item.endDate != "" && item.endDate?.isNotEmpty == true
                ? DateFormat("dd/ MM/ yyyy")
                    .format(DateTime.parse(item.endDate!))
                : ""),
      ],
    );
  }

  Widget _itemTitle(String _title) {
    return Text(
      _title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        color: AppColors.main,
      ),
    );
  }

  Widget _textSubTitle(_titleDetail, _subtitleDetail) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _titleDetail,
            style: TextStyle(fontSize: 16, color: AppColors.black),
          ),
        ),
        Expanded(
          child: Text(
            _subtitleDetail ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildListViewDepreciation(data) {
    return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final AssetsModel item = data[index];
          String? _title = item.code;
          return Dismissible(
            key: Key(data[index].documentID),
            background: Container(
              color: AppColors.greenLight,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.track_changes_outlined,
                    color: Colors.white,
                  ),
                  Text(AssetString.DEPRECIATION_TRACKING_TITLE),
                ],
              ),
            ),
            secondaryBackground: Container(
                color: Colors.blue,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(AssetString.LIQUIDATION_TITLE),
                    Icon(
                      Icons.outbond_rounded,
                      color: Colors.white,
                    ),
                  ],
                )),
            child: Padding(
              padding: GlobalStyles.paddingPageLeftRight,
              child: ListTile(
                contentPadding: GlobalStyles.paddingAll,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.main)),
                tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
                leading: Image.asset(
                  AppImages.imTitle,
                ),
                title: _itemTitle(_title ?? ""),
                subtitle: _itemSubTitleDepreciation(item: item),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Depreciation(
                                idAsset: item.documentID ?? "",
                                flag: 2,
                              )));
                },
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction.toString() == "DismissDirection.endToStart") {
                updateAsset(
                  add: false,
                  assets: item,
                );
              } else if (direction.toString() ==
                  "DismissDirection.startToEnd") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DepreciationTracking(
                              idAsset: item.documentID ?? "",
                            )));
              }

              return null;
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
        });
  }

  convertAsset(bool isFull, AssetsModel assets) async {
    if (isFull) {
      _addOrEditAsset(
        add: true,
        assets: assets,
        child: AssetConvertPage(
          flag: true,
          assetsModel: assets,
        ),
      );
      // _homeBloc.deleteAssets.add(assets);
    } else {
      _addOrEditAsset(
        add: false,
        assets: assets,
        child: AssetConvertPage(
          flag: false,
          assetsModel: assets,
        ),
      );
    }
  }

  _itemSubTitleDepreciation({required AssetsModel item}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSubTitle(AssetString.INFO_NAME_ASSETS, item.nameAsset),
        GlobalStyles.divider,
        _textSubTitle(AssetString.ORIGINAL_PRICES, item.originalPrice),
        GlobalStyles.divider,
        _textSubTitle(AssetString.USER_TIME, item.usedTime ?? "" + "Tháng"),
      ],
    );
  }
}
