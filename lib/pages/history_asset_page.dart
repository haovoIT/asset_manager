import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/history_asset_bloc.dart';
import 'package:assets_manager/bloc/history_asset_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/appbar_custom.dart';
import 'package:assets_manager/inPDF/inPDF_LichSuSuDung.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/history_asset_model.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class HistoryAsset extends StatelessWidget {
  final String qrCode;
  const HistoryAsset({Key? key, required this.qrCode}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationserver =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationserver);
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
            return HistoryAssetBlocProvider(
              historyAssetBloc: HistoryAssetBloc(
                  DbHistoryAssetService(), _authenticationserver),
              uid: snapshot.data!,
              child: HistoryAssetPage(
                qrCode: qrCode,
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

class HistoryAssetPage extends StatefulWidget {
  final String qrCode;
  const HistoryAssetPage({Key? key, required this.qrCode}) : super(key: key);

  @override
  _HistoryAssetPageState createState() => _HistoryAssetPageState();
}

class _HistoryAssetPageState extends State<HistoryAssetPage> {
  HistoryAssetBloc? historyAssetBloc;
  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  List<HistoryAssetModel> listHistoryAsset = [];

  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    historyAssetBloc = HistoryAssetBlocProvider.of(context)?.historyAssetBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    historyAssetBloc?.qrCodeEditChanged.add(widget.qrCode);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        appBar: AppBarCustom(
          title: AssetString.HISTORY_TITLE,
          actions: [
            IconButton(
                onPressed: () async {
                  final pdfFile =
                      await PdfLSSDApi.generate(listHistoryAsset, email, name);
                  PdfApi.openFile(pdfFile, context);
                },
                icon: Icon(
                  Icons.print,
                  color: AppColors.lightWhite,
                  size: 24,
                )),
            IconButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.lightBlack,
                ))
          ],
        ),
        body: StreamBuilder(
            stream: historyAssetBloc?.listIDHistoryAsset,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return _buildTable(snapshot);
              } else {
                return Center(
                  child: Container(
                    child: Text('Thêm Tài Sản.'),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget _buildTable(AsyncSnapshot snapshot) {
    listHistoryAsset = snapshot.data;
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 1950,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: snapshot.data.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
        rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
        verticalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.yellow,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        horizontalScrollbarStyle: const ScrollbarStyle(
          thumbColor: Colors.red,
          isAlwaysShown: true,
          thickness: 4.0,
          radius: Radius.circular(5.0),
        ),
        enablePullToRefresh: true,
        refreshIndicator: const WaterDropHeader(),
        refreshIndicatorHeight: 60,
        onRefresh: () async {
          //Do sth
          await Future.delayed(const Duration(milliseconds: 500));
          _hdtRefreshController.refreshCompleted();
        },
        htdRefreshController: _hdtRefreshController,
      ),
      height: MediaQuery.of(context).size.height,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget(
          AssetString.INFO_NAME_ASSETS +
              " (${listHistoryAsset.length.toString()})",
          150,
          Alignment.centerLeft),
      _getTitleItemWidget(
          AssetString.INFO_DEPARTMENT, 150, Alignment.centerLeft),
      _getTitleItemWidget(
          AssetString.INFO_YEAR_OF_MANUFACTURE, 100, Alignment.center),
      _getTitleItemWidget(
          AssetString.INFO_PRODUCING_COUNTRY, 100, Alignment.center),
      _getTitleItemWidget(AssetString.INFO_ASSET_GROUP, 200, Alignment.center),
      _getTitleItemWidget(AssetString.INFO_STATUS, 150, Alignment.center),
      _getTitleItemWidget(
          AssetString.INFO_ORIGINAL_PRICE, 150, Alignment.center),
      _getTitleItemWidget(AssetString.INFO_USER_TIME, 100, Alignment.center),
      _getTitleItemWidget(AssetString.INFO_AMOUNT, 100, Alignment.center),
      _getTitleItemWidget(
          AssetString.INFO_CONTRACT_NAME, 200, Alignment.centerLeft),
      _getTitleItemWidget(
          AssetString.INFO_PURPOSE_OF_USING, 200, Alignment.centerLeft),
      _getTitleItemWidget(
          AssetString.INFO_USER_NAME, 200, Alignment.centerLeft),
      _getTitleItemWidget(
          AssetString.INFO_USER_EMAIL, 200, Alignment.centerLeft),
      _getTitleItemWidget(
          AssetString.INFO_TIME_UPDATE, 100, Alignment.centerRight),
    ];
  }

  Widget _getTitleItemWidget(String label, double width, Alignment alignment) {
    return Container(
      child: Text(label,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 16.0)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: alignment,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(
          '(${(index + 1).toString()}) ' + listHistoryAsset[index].nameAsset!,
          style: TextStyle(fontSize: 14.0)),
      width: 150,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    final itemHistoryAsset = listHistoryAsset[index];
    return Row(
      children: <Widget>[
        _container(
            itemHistoryAsset.departmentName ?? "", 150, Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy').format(
                DateTime.parse(itemHistoryAsset.yearOfManufacture ?? "")),
            100,
            Alignment.centerRight),
        _container(
            itemHistoryAsset.producingCountry ?? "", 100, Alignment.center),
        _container(
            itemHistoryAsset.assetGroupName ?? "", 200, Alignment.center),
        _container(itemHistoryAsset.status ?? "", 150, Alignment.center),
        _container(
            itemHistoryAsset.originalPrice ?? "", 150, Alignment.centerRight),
        _container(itemHistoryAsset.usedTime ?? "", 100, Alignment.center),
        _container(itemHistoryAsset.amount ?? "", 100, Alignment.center),
        _container(
            itemHistoryAsset.contractName ?? "", 200, Alignment.centerLeft),
        _container(
            itemHistoryAsset.purposeOfUsing ?? "", 200, Alignment.centerLeft),
        _container(itemHistoryAsset.userName ?? "", 200, Alignment.centerLeft),
        _container(itemHistoryAsset.userEmail ?? "", 200, Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(itemHistoryAsset.dateUpdate ?? "")) +
                "\n" +
                DateFormat.Hms()
                    .format(DateTime.parse(itemHistoryAsset.dateUpdate ?? "")),
            100,
            Alignment.centerRight),
        //_container(listLSSD[index], ,  Alignment),
      ],
    );
  }

  Widget _container(String? text, double width, Alignment alignment) {
    return Container(
      child: Text(
        text ?? "",
        style: TextStyle(fontSize: 14.0),
      ),
      width: width,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: alignment,
    );
  }
}
