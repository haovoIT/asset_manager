import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/nhacungcap_bloc.dart';
import 'package:assets_manager/bloc/nhacungcap_bloc_provider.dart';
import 'package:assets_manager/bloc/nhacungcap_edit_bloc.dart';
import 'package:assets_manager/bloc/nhacungcap_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachNhaCungCap.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/nhacungcap.dart';
import 'package:assets_manager/pages/nhacungcapEditPage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_nhacungcap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NhaCungCapPage extends StatelessWidget {
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
            return NhaCungCapBlocProvider(
                nhaCungCapBloc: NhaCungCapBloc(
                    DbNhaCungCapService(), _authenticationServer),
                uid: snapshot.data!,
                child: NhaCungCapPages());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Nhà Cung Cấp.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class NhaCungCapPages extends StatefulWidget {
  const NhaCungCapPages({Key? key}) : super(key: key);

  @override
  _NhaCungCapPagesState createState() => _NhaCungCapPagesState();
}

class _NhaCungCapPagesState extends State<NhaCungCapPages> {
  NhaCungCapBloc? _nhaCungCapBloc;
  List<NhaCungCap> listNhaCungCap = [];
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nhaCungCapBloc = NhaCungCapBlocProvider.of(context)?.nhaCungCapBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  void _addOrEditNhaCungCap(
      {required bool add, required NhaCungCap nhaCungCap}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => NhaCungCapEditBlocProvider(
                nhaCungCapEditBloc:
                    NhaCungCapEditBloc(add, DbNhaCungCapService(), nhaCungCap),
                child: NhaCungCapEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDeleteNhaCungCap(String nameNCC) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Xóa Nhà Cung Cấp",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
                'Bạn có chắc chắn muốn xóa nhà cung cấp ' +
                    nameNCC +
                    ' không ?',
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
        title: Text('Danh Sách Nhà Cung Cấp'),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfDSNhaCungCapApi.generate(
                    listNhaCungCap, email, name);
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _nhaCungCapBloc?.listNhaCungCap,
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
                  child: Text('Thêm Nhà Cung Cấp.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addOrEditNhaCungCap(add: true, nhaCungCap: NhaCungCap());
        },
        icon: Icon(Icons.add),
        label: Text('Nhà Cung Cấp'),
      ),
    );
  }

  Widget _buildListViewSeparated(AsyncSnapshot snapshot) {
    return ListView.separated(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = snapshot.data[index].TenNCC;
        String _subTilte = "Số Điện Thoại: " +
            snapshot.data[index].SDT +
            "\nĐịa Chỉ: " +
            snapshot.data[index].DC +
            "\nEmail:" +
            snapshot.data[index].Email;
        listNhaCungCap.add(snapshot.data[index]);
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
                  fontSize: 20.0,
                  color: Colors.blue),
            ),
            subtitle: Text(_subTilte),
            onTap: () {
              _addOrEditNhaCungCap(
                add: false,
                nhaCungCap: NhaCungCap(
                    documentID: snapshot.data[index].documentID,
                    TenNCC: snapshot.data[index].TenNCC,
                    SDT: snapshot.data[index].SDT,
                    DC: snapshot.data[index].DC,
                    Email: snapshot.data[index].Email),
              );
            },
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await _confirmDeleteNhaCungCap(_title);
            if (confirmDelete) {
              _nhaCungCapBloc?.deleteNhaCungCap.add(snapshot.data[index]);
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
