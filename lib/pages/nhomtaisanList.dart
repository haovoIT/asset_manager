import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/nhomtaisan_bloc.dart';
import 'package:assets_manager/bloc/nhomtaisan_bloc_provider.dart';
import 'package:assets_manager/models/nhomtaisan.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_nhomtaisan.dart';
import 'package:flutter/material.dart';

class NhomTaiSansList extends StatelessWidget {
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
                child: NhomTaiSanList());
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

class NhomTaiSanList extends StatefulWidget {
  const NhomTaiSanList({Key? key}) : super(key: key);

  @override
  _NhomTaiSanListState createState() => _NhomTaiSanListState();
}

class _NhomTaiSanListState extends State<NhomTaiSanList> {
  NhomTaiSanBloc? _nhomTaiSanBloc;
  TextEditingController tenController = new TextEditingController();
  String tenNTS = "";
  bool flag = true;
  List<NhomTaiSan> listNhomTaiSan = [];
  List<NhomTaiSan> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nhomTaiSanBloc = NhomTaiSanBlocProvider.of(context)?.nhomTaiSanBloc;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tenController.addListener(() {
      setState(() {
        tenNTS = tenController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
        appBar: AppBar(
            leading: new Icon(Icons.search),
            actions: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => {
                  tenController.clear(),
                  setState(() {
                    flag = true;
                  }),
                },
              ),
            ],
            title: TextFormField(
              enabled: true,
              style: TextStyle(fontSize: 18.0, color: Colors.black),
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: "Nhập tên Nhóm tài sản....",
              ),
              controller: tenController,
              onChanged: (name) {
                listNhomTaiSan.clear();
                flag = false;
              },
            )),
        body: StreamBuilder(
            stream: _nhomTaiSanBloc?.dsNhomTaiSan,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                list = snapshot.data;
                return _build(snapshot);
              } else {
                return Center(
                  child: Container(
                    child: Text('Thêm Nhóm Tài Sản.'),
                  ),
                );
              }
            }),
      ),
      onWillPop: () async {
        final snackBar = SnackBar(
          content: Text(
            'Vui lòng chọn Nhóm Tài Sản thích hợp !!',
            style: TextStyle(
                fontSize: 20, fontStyle: FontStyle.italic, color: Colors.red),
          ),
          backgroundColor: Colors.blue.shade200,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      },
    );
  }

  Widget _build(AsyncSnapshot snapshot) {
    if (flag) {
      return _buildListViewSeparated(list);
    } else {
      for (int i = 0; i < snapshot.data.length; i++) {
        if (snapshot.data[i].TenNTS
            .toLowerCase()
            .contains(tenNTS.toLowerCase())) {
          listNhomTaiSan.add(snapshot.data[i]);
        }
      }
      return _buildListViewSeparated(listNhomTaiSan);
    }
  }

  Widget _buildListViewSeparated(List<NhomTaiSan> listNhomTaiSan) {
    return ListView.separated(
      itemCount: listNhomTaiSan.length,
      itemBuilder: (BuildContext context, int index) {
        String _title = listNhomTaiSan[index].TenNTS ?? "";
        String _subTilte = "Đặc Điểm: " + listNhomTaiSan[index].DD!;
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
                fontSize: 20.0,
                color: Colors.blue),
          ),
          subtitle: Text(_subTilte),
          onTap: () {
            Navigator.pop(context, listNhomTaiSan[index].TenNTS);
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
