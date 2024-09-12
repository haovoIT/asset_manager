import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/thanhly_bloc.dart';
import 'package:assets_manager/bloc/thanhly_bloc_provider.dart';
import 'package:assets_manager/bloc/thanhly_edit_bloc.dart';
import 'package:assets_manager/bloc/thanhly_edit_bloc_provider.dart';
import 'package:assets_manager/inPDF/inPDF_ThongTinThanhLy.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/thanhly.dart';
import 'package:assets_manager/pages/depreciation_page.dart';
import 'package:assets_manager/pages/thanhlyEditPage.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_thanhly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThanhLyPage extends StatelessWidget {
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
            return ThanhLyBlocProvider(
              thanhLyBloc:
                  ThanhLyBloc(DbThanhLyService(), _authenticationServer),
              uid: snapshot.data,
              child: ThanhLyPages(),
            );
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

class ThanhLyPages extends StatefulWidget {
  const ThanhLyPages({Key? key}) : super(key: key);

  @override
  _ThanhLyPagesState createState() => _ThanhLyPagesState();
}

class _ThanhLyPagesState extends State<ThanhLyPages> {
  ThanhLyBloc? thanhLyBloc;
  List<ThanhLy> listThanhLy = [];
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    thanhLyBloc = ThanhLyBlocProvider.of(context)?.thanhLyBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
    thanhLyBloc?.maPbEditChanged.add(maPb);
  }

  void _addorEditThanhLy({required bool add, required ThanhLy thanhLy}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ThanhLyEditBlocProvider(
                thanhLyEditBloc:
                    ThanhLyEditBloc(DbThanhLyService(), add, thanhLy),
                child: ThanhLyEditPage(),
              ),
          fullscreenDialog: true),
    );
  }

  Future<bool> _confirmDelete(String name) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Xóa Thông Tin Thanh Lý",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
                'Bạn có chắc chắn muốn xóa thông tin thanh lý của ' +
                    name +
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
        title: Text('Tài Sản Đã Thanh Lý'),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile =
                    await PdfDSThanhLyApi.generate(listThanhLy, email, name);
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: thanhLyBloc?.dsThanhLy,
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
        String _subTilte = "Ngày Thanh Lý: " +
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(snapshot.data[index].Ngay_TL));
        listThanhLy.add(snapshot.data[index]);
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
              _addorEditThanhLy(
                  add: false,
                  thanhLy: ThanhLy(
                      Ten_ts: _title,
                      Ma_pb: snapshot.data[index].Ma_pb,
                      Don_vi_TL: snapshot.data[index].Don_vi_TL,
                      Nguyen_gia_TL: snapshot.data[index].Nguyen_gia_TL,
                      Ngay_TL: snapshot.data[index].Ngay_TL));
            },
          ),
          confirmDismiss: (direction) async {
            if (direction.toString() == "DismissDirection.endToStart") {
              print("${snapshot.data[index].documentID}");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Depreciation(
                            idAsset: snapshot.data[index].documentID,
                            flag: 2,
                          )));
            } else if (direction.toString() == "DismissDirection.startToEnd") {
              bool confirmDelete = await _confirmDelete(_title);
              if (confirmDelete) {
                thanhLyBloc?.deleteThanhLy.add(snapshot.data[index]);
              }
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
