import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_BaoCaoThucTrang.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/services/db_asset.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';

class ThongKeThucTrang extends StatelessWidget {
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
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), DbHistoryAssetService(),
                  _authenticationserver),
              uid: snapshot.data!,
              child: ThongKeThucTrangs(),
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

class ThongKeThucTrangs extends StatefulWidget {
  const ThongKeThucTrangs({Key? key}) : super(key: key);

  @override
  _ThongKeThucTrangsState createState() => _ThongKeThucTrangsState();
}

class _ThongKeThucTrangsState extends State<ThongKeThucTrangs> {
  HomeBloc? _homeBloc;
  int tongso = 0;
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  HDTRefreshController _hdtRefreshController = HDTRefreshController();
  List<AssetsModel> listAssets = [];
  int dangSD = 0;
  int ngungSD = 0;
  int huHong = 0;
  int matMat = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)?.homeBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    _homeBloc?.maPBEditChanged.add(maPb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Thống Kê Thực Trạng"),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfBCTTApi.generate(
                  listAssets,
                  email,
                  name,
                  dangSD,
                  ngungSD,
                  huHong,
                  matMat,
                );
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.green,
              )),
          Container(
            width: 15.0,
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _homeBloc?.listAssets,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Tài Sản.'),
                ),
              );
            }
          }),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    int index = 0;
    listAssets = snapshot.data;

    for (index = 0; index < snapshot.data.length; index++) {
      switch (snapshot.data[index].Tinh_trang) {
        case "Đang Sử Dụng":
          dangSD += 1;
          break;
        case "Ngừng Sử Dụng":
          ngungSD += 1;
          break;
        case "Hư Hỏng":
          huHong += 1;
          break;
        case "Mất Mát":
          matMat += 1;
          break;
      }
    }
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _containers("Đang Sử Dụng", dangSD, Colors.blue.shade500),
          SizedBox(
            height: 10.0,
          ),
          _containers("Ngừng Sử Dụng", ngungSD, Colors.blue.shade300),
          SizedBox(
            height: 10.0,
          ),
          _containers("Hư Hỏng", huHong, Colors.blue.shade100),
          SizedBox(
            height: 10.0,
          ),
          _containers("Mất Mát", matMat, Colors.blue.shade50),
          SizedBox(
            height: 20.0,
          ),
          TextButton(
              onPressed: () {
                showChiTiet(listAssets);
              },
              child: Text(
                "Nhấn để xem chi tiết >>>",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.green),
              )),
          Expanded(
              child: new charts.PieChart(
                  _createSampleData(dangSD, ngungSD, huHong, matMat),
                  animate: false,
                  defaultRenderer: new charts.ArcRendererConfig(
                      arcRendererDecorators: [
                        new charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.inside)
                      ])))
        ],
      ),
    );
  }

  Widget _containers(String name, int value, Color color) {
    final TextStyle textStyleName =
        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
    final TextStyle textStyleValue = TextStyle(
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      height: 60,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: textStyleName,
          ),
          Text(
            "$value",
            style: textStyleValue,
          )
        ],
      ),
    );
  }

  static List<charts.Series<Label, String>> _createSampleData(
      int dsd, int nsd, int hh, int mm) {
    final data = [
      new Label("Đang Sử Dụng", dsd),
      new Label("Ngừng Sử Dụng", nsd),
      new Label("Hư Hỏng", hh),
      new Label("Mất Mát", mm),
    ];

    return [
      new charts.Series<Label, String>(
        id: 'Sales',
        domainFn: (Label label, _) => label.name,
        measureFn: (Label label, _) => label.value,
        data: data,
// Set a label accessor to control the text of the arc label.
        labelAccessorFn: (Label row, _) => '${row.name}: ${row.value}',
      )
    ];
  }

  void showChiTiet(List<AssetsModel> listAssets) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.all(16.0),
              child: HorizontalDataTable(
                leftHandSideColumnWidth: 150,
                rightHandSideColumnWidth: 1450,
                isFixedHeader: true,
                headerWidgets: _getTitleWidget(),
                leftSideItemBuilder: _generateFirstColumnRow,
                rightSideItemBuilder: _generateRightHandSideColumnRow,
                itemCount: listAssets.length,
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
            ));
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Tên Tài Sản (${listAssets.length.toString()})', 150,
          Alignment.centerLeft),
      _getTitleItemWidget('Tình Trạng', 150, Alignment.center),
      _getTitleItemWidget('Phòng Ban', 150, Alignment.centerLeft),
      _getTitleItemWidget('Năm SX', 100, Alignment.center),
      _getTitleItemWidget('Nước SX', 100, Alignment.center),
      _getTitleItemWidget('Nhóm Tài Sản', 200, Alignment.center),
      _getTitleItemWidget('Nguyên Giá', 150, Alignment.center),
      _getTitleItemWidget('Thời Gian SD (Tháng)', 100, Alignment.center),
      _getTitleItemWidget('Số Lượng', 100, Alignment.center),
      _getTitleItemWidget('Hợp Đồng', 200, Alignment.centerLeft),
      _getTitleItemWidget('Mục Đích SD', 200, Alignment.centerLeft),
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
      child: Text('(${(index + 1).toString()}) ' + listAssets[index].nameAsset!,
          style: TextStyle(fontSize: 14.0)),
      width: 150,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        _container(listAssets[index].status ?? "", 150, Alignment.centerLeft),
        _container(
            listAssets[index].departmentName ?? "", 150, Alignment.centerLeft),
        _container(
            DateFormat('dd/MM/yyyy').format(
                DateTime.parse(listAssets[index].yearOfManufacture ?? "")),
            100,
            Alignment.centerRight),
        _container(
            listAssets[index].producingCountry ?? "", 100, Alignment.center),
        _container(
            listAssets[index].assetGroupName ?? "", 200, Alignment.center),
        _container(
            listAssets[index].originalPrice ?? "", 150, Alignment.centerRight),
        _container(listAssets[index].usedTime ?? "", 100, Alignment.center),
        _container(listAssets[index].amount ?? "", 100, Alignment.center),
        _container(
            listAssets[index].contractName ?? "", 200, Alignment.centerLeft),
        _container(
            listAssets[index].purposeOfUsing ?? "", 200, Alignment.centerLeft),
        //_container(listLSSD[index], ,  Alignment),
      ],
    );
  }

  Widget _container(String text, double width, Alignment alignment) {
    return Container(
      child: Text(
        text != null ? text : '',
        style: TextStyle(fontSize: 14.0),
      ),
      width: width,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: alignment,
    );
  }
}

class Label {
  final String name;
  final int value;

  Label(this.name, this.value);
}
