import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_ThongTinTaiSan.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/pages/depreciation_page.dart';
import 'package:assets_manager/services/db_asset.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class QuetQR extends StatelessWidget {
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
              child: QuetQRs(),
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

class QuetQRs extends StatefulWidget {
  const QuetQRs({Key? key}) : super(key: key);

  @override
  _QuetQRsState createState() => _QuetQRsState();
}

class _QuetQRsState extends State<QuetQRs> {
  HomeBloc? _homeBloc;
  String qrCode = "";
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)?.homeBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quét mã QR"),
      ),
      body: StreamBuilder(
          stream: _homeBloc?.listIDAssets,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: StreamBuilder(
          stream: _homeBloc?.maEdit,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.green,
              ),
              width: 150,
              child: TextButton(
                onPressed: () async {
                  final String _ma = await scanQRcode();
                  setState(() {
                    qrCode = _ma;
                  });
                  _homeBloc?.maEditChanged.add(qrCode + "|" + maPb);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Bắt đầu  ",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 22.0,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    final TextStyle textStyle =
        TextStyle(fontSize: 16.0, color: Colors.blue.shade500);

    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: snapshot.data.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 500, crossAxisSpacing: 1, mainAxisSpacing: 1),
      itemBuilder: (BuildContext context, int index) {
        String _title = snapshot.data[index].nameAsset;
        String _subtilte = snapshot.data[index].departmentName;
        String _namsx = DateFormat.yMd()
            .format(DateTime.parse(snapshot.data[index].yearOfManufacture));
        String _nuocsx = snapshot.data[index].producingCountry;
        String _nts = snapshot.data[index].assetGroupName;
        String _tt = snapshot.data[index].status;
        String _ng = snapshot.data[index].originalPrice;
        String _tg = snapshot.data[index].usedTime;
        String _sl = snapshot.data[index].amount;
        String _hd = snapshot.data[index].contractName;
        String _md = snapshot.data[index].purposeOfUsing;
        String _qr = snapshot.data[index].qrCode;
        return Card(
          color: Colors.lightGreen.shade50,
          margin: EdgeInsets.all(8.0),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BarcodeWidget(
                  data: _qr,
                  barcode: Barcode.qrCode(),
                  width: 200,
                  height: 200,
                  color: Colors.black,
                  backgroundColor: Colors.white,
                ),
                Divider(),
                Text(
                  "Tên Tài sản: " + _title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Text(
                  "Phòng Ban: " + _subtilte,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                Text(
                  "Tình Trạng: " + _tt,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                )
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        'Thẻ Tài Sản Chi Tiết',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      content: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              BarcodeWidget(
                                data: _qr,
                                barcode: Barcode.qrCode(),
                                width: 200,
                                height: 200,
                                color: Colors.black,
                                backgroundColor: Colors.white,
                                padding: EdgeInsets.only(left: 40.0),
                              ),
                              Divider(
                                color: Colors.green,
                              ),
                              Text("Tên tài sản: " + _title, style: textStyle),
                              Text("Phòng Ban: " + _subtilte, style: textStyle),
                              Text("Năm Sản Xuất: " + _namsx, style: textStyle),
                              Text("Nước Sản Xuất: " + _nuocsx,
                                  style: textStyle),
                              Text("Nhóm Tài Sản: " + _nts, style: textStyle),
                              Text("Tình Trạng: " + _tt, style: textStyle),
                              Text("Nguyên Giá: " + _ng, style: textStyle),
                              Text("Thời Gian SD: " + _tg, style: textStyle),
                              Text("Số Lượng: " + _sl, style: textStyle),
                              Text("Hợp Đồng: " + _hd, style: textStyle),
                              Text("Mục Đích SD: " + _md,
                                  textAlign: TextAlign.start, style: textStyle),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          height: 30,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.green,
                          ),
                          child: Center(
                              child: TextButton(
                            onPressed: () async {
                              final assets = AssetsModel(
                                  documentID: snapshot.data[index].documentID,
                                  nameAsset: snapshot.data[index].nameAsset,
                                  departmentName:
                                      snapshot.data[index].departmentName,
                                  idDepartment:
                                      snapshot.data[index].idDepartment,
                                  yearOfManufacture:
                                      snapshot.data[index].yearOfManufacture,
                                  producingCountry:
                                      snapshot.data[index].producingCountry,
                                  assetGroupName:
                                      snapshot.data[index].assetGroupName,
                                  status: snapshot.data[index].status,
                                  qrCode: snapshot.data[index].qrCode,
                                  usedTime: snapshot.data[index].usedTime,
                                  amount: snapshot.data[index].amount,
                                  contractName:
                                      snapshot.data[index].contractName,
                                  purposeOfUsing:
                                      snapshot.data[index].purposeOfUsing,
                                  originalPrice:
                                      snapshot.data[index].originalPrice,
                                  userId: snapshot.data[index].userId);
                              final pdfFile = await PdfThongTinTSApi.generate(
                                  assets, email, name);
                              PdfApi.openFile(pdfFile, context);
                            },
                            child: Text(
                              'IN PDF',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )),
                        ),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.green,
                          ),
                          child: Center(
                              child: TextButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Depreciation(
                                            idAsset:
                                                snapshot.data[index].documentID,
                                            flag: 2,
                                          )));
                            },
                            child: Text(
                              'Khấu Hao',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )),
                        ),
                        TextButton(
                          child: const Text('Huỷ'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
          ),
        );
      },
    );
  }

  Future<String> scanQRcode() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Hủy', true, ScanMode.QR);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    setState(() {
      barcodeScanRes;
    });
    return barcodeScanRes;
  }
}
