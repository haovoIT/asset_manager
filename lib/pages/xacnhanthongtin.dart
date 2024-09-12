import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/services/db_asset.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class XacNhanThongTin extends StatelessWidget {
  final String ma;
  const XacNhanThongTin({Key? key, required this.ma}) : super(key: key);
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
              child: XacNhanThongTins(
                ma: ma,
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

class XacNhanThongTins extends StatefulWidget {
  final String ma;
  const XacNhanThongTins({Key? key, required this.ma}) : super(key: key);

  @override
  _XacNhanThongTinsState createState() => _XacNhanThongTinsState();
}

class _XacNhanThongTinsState extends State<XacNhanThongTins> {
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
    _homeBloc?.maEditChanged.add(widget.ma + "|" + maPb);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Xác Nhận Thông Tin"),
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
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    final TextStyle textStyle = TextStyle(fontSize: 14.0);
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
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
        String _tg = snapshot.data[index].usedTime + "Tháng";
        String _sl = snapshot.data[index].amount;
        String _hd = snapshot.data[index].contractName;
        String _md = snapshot.data[index].purposeOfUsing;
        return Card(
          color: Colors.grey.shade200,
          child: InkWell(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("Tên tài sản: " + _title, style: textStyle),
                  Text("Phòng Ban: " + _subtilte, style: textStyle),
                  Text("Năm Sản Xuất: " + _namsx, style: textStyle),
                  Text("Nước Sản Xuất: " + _nuocsx, style: textStyle),
                  Text("Nhóm Tài Sản: " + _nts, style: textStyle),
                  Text("Tình Trạng: " + _tt, style: textStyle),
                  Text("Nguyên Giá: " + _ng, style: textStyle),
                  Text("Thời Gian SD: " + _tg, style: textStyle),
                  Text("Số Lượng: " + _sl, style: textStyle),
                  Text("Hợp Đồng: " + _hd, style: textStyle),
                  Text("Mục Đích SD: " + _md,
                      textAlign: TextAlign.start, style: textStyle),
                  SizedBox(height: 10),
                  Text(
                    "Xác Nhận Đúng Thông Tin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            onTap: () {
              final assets = AssetsModel(
                  documentID: snapshot.data[index].documentID,
                  nameAsset: snapshot.data[index].nameAsset,
                  departmentName: snapshot.data[index].departmentName,
                  idDepartment: snapshot.data[index].idDepartment,
                  yearOfManufacture: snapshot.data[index].yearOfManufacture,
                  producingCountry: snapshot.data[index].producingCountry,
                  assetGroupName: snapshot.data[index].assetGroupName,
                  status: snapshot.data[index].status,
                  qrCode: snapshot.data[index].qrCode,
                  usedTime: snapshot.data[index].usedTime,
                  amount: snapshot.data[index].amount,
                  contractName: snapshot.data[index].contractName,
                  purposeOfUsing: snapshot.data[index].purposeOfUsing,
                  originalPrice: snapshot.data[index].originalPrice,
                  userId: snapshot.data[index].userId);
              Navigator.pop(context, assets);
            },
          ),
        );
      },
    );
  }
}
