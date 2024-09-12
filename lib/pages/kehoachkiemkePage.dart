import 'dart:async';

import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/kehoachkiemke_bloc.dart';
import 'package:assets_manager/bloc/kehoachkiemke_bloc_provider.dart';
import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc.dart';
import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachKiemKe.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/kehoachkiemke.dart';
import 'package:assets_manager/pages/kehoachkiemkeEditPage.dart';
import 'package:assets_manager/pages/kiemkepage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_kehoachkiemke.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class KeHoachKiemKePage extends StatelessWidget {
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
            return KeHoachKiemKeBlocProvider(
                keHoachKiemKeBloc: KeHoachKiemKeBloc(
                    DbKeHoachKiemKeService(), _authenticationserver),
                uid: snapshot.data!,
                child: KeHoachKiemKes());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Phòng Ban'),
              ),
            );
          }
        },
      ),
    );
  }
}

class KeHoachKiemKes extends StatefulWidget {
  const KeHoachKiemKes({Key? key}) : super(key: key);

  @override
  _KeHoachKiemKesState createState() => _KeHoachKiemKesState();
}

class _KeHoachKiemKesState extends State<KeHoachKiemKes> {
  KeHoachKiemKeBloc? keHoachKiemKeBloc;
  List<KeHoachKiemKe>? listKHKK;
  List<String>? list;

  HDTRefreshController _hdtRefreshController = HDTRefreshController();

  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    keHoachKiemKeBloc =
        KeHoachKiemKeBlocProvider.of(context)?.keHoachKiemKeBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    keHoachKiemKeBloc?.maPBEditChanged.add(maPb);
  }

  void _addorEditKHKK(
      {required bool add, required KeHoachKiemKe keHoachKiemKe}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => KeHoachKiemKeEditBlocProvider(
                keHoachKiemKeEditBloc: KeHoachKiemKeEditBloc(
                    add, DbKeHoachKiemKeService(), keHoachKiemKe),
                child: KeHoachKiemKeEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Kế Hoạch'),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfDanhSachKHKKApi.generate(
                    listKHKK ?? [], email, name);
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: keHoachKiemKeBloc?.dsKeHoachKiemKe,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Kế Hoạch.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addorEditKHKK(add: true, keHoachKiemKe: KeHoachKiemKe());
        },
        icon: Icon(Icons.add),
        label: Text('Tạo Kế Hoạch'),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    listKHKK = snapshot.data;
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = "Ngày Kiểm Kê: " +
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(snapshot.data[index].Ngay_KK));
        String _subTilte = "Người Tạo/Kiểm Kê: " + snapshot.data[index].Name;
        List<String> lists = snapshot.data[index].list;
        return ListTile(
          tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
          leading: Column(
            children: <Widget>[
              Text(
                (index + 1).toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.lightBlue),
              ),
            ],
          ),
          title: Text(
            _title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blue),
          ),
          subtitle: Text(_subTilte),
          onTap: () async {
            KeHoachKiemKe keHoachKiemKe = KeHoachKiemKe(
              documentID: snapshot.data[index].documentID,
              Ma_pb: snapshot.data[index].Ma_pb,
              Ngay_KK: snapshot.data[index].Ngay_KK,
              Name: snapshot.data[index].Name,
              Email: snapshot.data[index].Email,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      KeHoachKiemKeEditBlocProvider(
                        keHoachKiemKeEditBloc: KeHoachKiemKeEditBloc(
                            false, DbKeHoachKiemKeService(), keHoachKiemKe),
                        child: KiemKePage(),
                      ),
                  fullscreenDialog: true),
            );
          },
          onLongPress: () async {
            setState(() {
              list = lists;
            });
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: 600.0,
                child: _buildTable(lists),
              ),
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.green,
        );
      },
    );
  }

  Widget _buildTable(List<String> list) {
    return Container(
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 250,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(list),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: list.length,
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

  List<Widget> _getTitleWidget(List<String> list) {
    return [
      _getTitleItemWidget('Mã QR', 150, Alignment.centerLeft),
      _getTitleItemWidget('Tên Tài Sản', 150, Alignment.centerLeft),
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
      child: BarcodeWidget(
        data: list![index].substring(0, 26),
        barcode: Barcode.qrCode(),
        width: 200,
        height: 200,
        color: Colors.black,
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(10.0),
      ),
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        _container(list![index].substring(29, list![index].length), 150,
            Alignment.centerLeft),
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
      height: 200,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: alignment,
    );
  }
}
