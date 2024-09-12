import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/nhacungcap_bloc.dart';
import 'package:assets_manager/bloc/nhacungcap_bloc_provider.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_nhacungcap.dart';
import 'package:flutter/material.dart';

class NhaCungCapList extends StatelessWidget {
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
                child: NhaCungCapLists());
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

class NhaCungCapLists extends StatefulWidget {
  const NhaCungCapLists({Key? key}) : super(key: key);

  @override
  _NhaCungCapListsState createState() => _NhaCungCapListsState();
}

class _NhaCungCapListsState extends State<NhaCungCapLists> {
  NhaCungCapBloc? _nhaCungCapBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nhaCungCapBloc = NhaCungCapBlocProvider.of(context)?.nhaCungCapBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh Sách Nhà Cung Cấp'),
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
            Navigator.pop(context, snapshot.data[index].TenNCC);
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
