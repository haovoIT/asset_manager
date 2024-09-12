import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/nhomtaisan_bloc.dart';
import 'package:assets_manager/bloc/nhomtaisan_bloc_provider.dart';
import 'package:assets_manager/bloc/nhomtaisan_edit_bloc.dart';
import 'package:assets_manager/bloc/nhomtaisan_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachNhomTaiSan.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/nhomtaisan.dart';
import 'package:assets_manager/pages/nhomtaisanEditPage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_nhomtaisan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NhomTaiSanPage extends StatelessWidget {
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
            return NhomTaiSanBlocProvider(
                nhomTaiSanBloc: NhomTaiSanBloc(
                    DbNhomTaiSanService(), _authenticationServer),
                uid: snapshot.data!,
                child: NhomTaiSanPages());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Nhóm Tài Sản.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class NhomTaiSanPages extends StatefulWidget {
  const NhomTaiSanPages({Key? key}) : super(key: key);

  @override
  _NhomTaiSanPagesState createState() => _NhomTaiSanPagesState();
}

class _NhomTaiSanPagesState extends State<NhomTaiSanPages> {
  NhomTaiSanBloc? _nhomTaiSanBloc;
  List<NhomTaiSan> listNhomTaiSan = [];
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nhomTaiSanBloc = NhomTaiSanBlocProvider.of(context)?.nhomTaiSanBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  void _addOrEditNhomTaiSan(
      {required bool add, required NhomTaiSan nhomTaiSan}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => NhomTaiSanEditBlocProvider(
                nhomTaiSanEditBloc:
                    NhomTaiSanEditBloc(add, DbNhomTaiSanService(), nhomTaiSan),
                child: NhomTaiSanEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteNhaCungCap(String name) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Xóa Nhóm Tài Sản",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
                'Bạn có chắc chắn muốn xóa nhóm tài Sản ' + name + ' không ?',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Huỷ')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Nhóm Tài Sản'),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfDSNhomTaiSanApi.generate(
                    listNhomTaiSan, email, name);
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _nhomTaiSanBloc?.dsNhomTaiSan,
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
                  child: Text('Thêm Nhóm Tài Sản.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addOrEditNhomTaiSan(add: true, nhomTaiSan: NhomTaiSan());
        },
        icon: Icon(Icons.add),
        label: Text('Nhóm Tài Sản'),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = snapshot.data[index].TenNTS;
        String _subTilte = "Đặc Điểm: " + snapshot.data[index].DD;
        listNhomTaiSan.add(snapshot.data[index]);
        return Dismissible(
          key: Key(snapshot.data[index].documentID),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
            leading: Text(
              (index + 1).toString(),
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            title: Text(
              _title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.blue),
            ),
            subtitle: Text(_subTilte),
            onTap: () {
              _addOrEditNhomTaiSan(
                add: false,
                nhomTaiSan: NhomTaiSan(
                    documentID: snapshot.data[index].documentID,
                    TenNTS: snapshot.data[index].TenNTS,
                    DD: snapshot.data[index].DD),
              );
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteNhaCungCap(_title);
            if (confirmDelete) {
              _nhomTaiSanBloc?.xoaNTS.add(snapshot.data[index]);
            }
            return null;
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
}
