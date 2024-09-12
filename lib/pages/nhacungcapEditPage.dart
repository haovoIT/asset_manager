import 'package:assets_manager/bloc/nhacungcap_edit_bloc.dart';
import 'package:assets_manager/bloc/nhacungcap_edit_bloc_provider.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NhaCungCapEditPage extends StatefulWidget {
  const NhaCungCapEditPage({Key? key}) : super(key: key);

  @override
  _NhaCungCapEditPageState createState() => _NhaCungCapEditPageState();
}

class _NhaCungCapEditPageState extends State<NhaCungCapEditPage> {
  NhaCungCapEditBloc? _nhaCungCapEditBloc;
  TextEditingController _tenNCCController = new TextEditingController();
  TextEditingController _dcController = new TextEditingController();
  TextEditingController _sdtController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenNCCController = TextEditingController();
    _dcController = TextEditingController();
    _sdtController = TextEditingController();
    _emailController = TextEditingController();
    _sdtController = MaskedTextController(mask: '0000 000 000');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nhaCungCapEditBloc =
        NhaCungCapEditBlocProvider.of(context)?.nhaCungCapEditBloc;
  }

  void _addOrUpdateNhaCungCap() {
    _nhaCungCapEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Tin Nhà Cung Cấp',
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: Icon(
                Icons.close,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _nhaCungCapEditBloc?.tenNCCEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _tenNCCController.value =
                      _tenNCCController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _tenNCCController,
                    textCapitalization: TextCapitalization.words,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: 'Tên Nhà Cung Cấp',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (ncc) =>
                        _nhaCungCapEditBloc?.tenNCCEditChanged.add(ncc),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _nhaCungCapEditBloc?.dcEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _dcController.value =
                      _dcController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _dcController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Địa Chỉ',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (dc) =>
                        _nhaCungCapEditBloc?.dcEditChanged.add(dc),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _nhaCungCapEditBloc?.sdtEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _sdtController.value =
                      _sdtController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _sdtController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Số Điện Thoại',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (sdt) =>
                        _nhaCungCapEditBloc?.sdtEditChanged.add(sdt),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _nhaCungCapEditBloc?.emailEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _emailController.value =
                      _emailController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    maxLines: null,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (email) =>
                        _nhaCungCapEditBloc?.emailEditChanged.add(email),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Huỷ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 20.0),
                  TextButton(
                    child: Text(
                      'Lưu',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      _addOrUpdateNhaCungCap();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "Thông báo",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text('Lưu thông tin thành công.',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic)),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text('Đóng'))
                              ],
                            );
                          });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
