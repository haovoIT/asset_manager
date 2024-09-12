import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc.dart';
import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_PhieuKiemke.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/services/db_asset.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';

class KiemKePage extends StatelessWidget {
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
              child: KiemKePages(),
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

class KiemKePages extends StatefulWidget {
  const KiemKePages({Key? key}) : super(key: key);

  @override
  _KiemKePagesState createState() => _KiemKePagesState();
}

class _KiemKePagesState extends State<KiemKePages> {
  HomeBloc? _homeBloc;
  KeHoachKiemKeEditBloc? keHoachKiemKeEditBloc;
  String? _uid;
  List<String> list = [];
  List<AssetsModel> listAssets = [];
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)?.homeBloc;
    keHoachKiemKeEditBloc =
        KeHoachKiemKeEditBlocProvider.of(context)?.keHoachKiemKeEditBloc;
    _uid = HomeBlocProvider.of(context)?.uid;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Tài Sản'),
        actions: [
          IconButton(
              onPressed: () async {
                keHoachKiemKeEditBloc?.listAssetsEditChanged.add(list);
                keHoachKiemKeEditBloc?.ngayKKEditChanged
                    .add(DateTime.now().toString());
                keHoachKiemKeEditBloc?.saveEditChanged.add('Save');
                final pdfFile =
                    await PdfPhieuKiemKeApi.generate(listAssets, email, name);
                PdfApi.openFile(pdfFile, context);
                Navigator.pop(context);
              },
              icon: Icon(Icons.save))
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
    return ListView.separated(
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext context, int index) {
          String _title = snapshot.data[index].Ten_ts;
          String _subtilte = "NSX: " +
              DateFormat('dd/MM/yyyy')
                  .format(DateTime.parse(snapshot.data[index].Nam_sx)) +
              "\nTình Trạng: " +
              snapshot.data[index].Tinh_trang +
              "\nMa: " +
              snapshot.data[index].Ma_qr;
          return Card(
            child: ListTile(
              tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
              leading: Image.asset(
                "assets/images/img.png",
              )
              /*Column(
                children: <Widget>[
                  Text(
                    snapshot.data[index].Ma_nts,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.lightBlue),
                  ),
                  Text(snapshot.data[index].Ma_pb)
                ],
              )*/
              ,
              title: Text(
                _title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.blue),
              ),
              subtitle: Text(_subtilte),
              onTap: () async {
                final String _ma = await scanQRcode();
                if (snapshot.data[index].Ma_qr
                    .toLowerCase()
                    .contains(_ma.toLowerCase())) {
                  list.add(snapshot.data[index].Ma_qr +
                      " | " +
                      snapshot.data[index].Ten_ts);
                  listAssets.add(snapshot.data[index]);
                }
                //print("${list[index].Ten_ts}");
              },
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
        });
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
