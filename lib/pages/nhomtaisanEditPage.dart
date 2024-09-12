import 'package:assets_manager/bloc/nhomtaisan_edit_bloc.dart';
import 'package:assets_manager/bloc/nhomtaisan_edit_bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NhomTaiSanEditPage extends StatefulWidget {
  const NhomTaiSanEditPage({Key? key}) : super(key: key);

  @override
  _NhomTaiSanEditPageState createState() => _NhomTaiSanEditPageState();
}

class _NhomTaiSanEditPageState extends State<NhomTaiSanEditPage> {
  NhomTaiSanEditBloc? _nhomTaiSanEditBloc;
  TextEditingController _tenNTSController = new TextEditingController();
  TextEditingController _ddController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenNTSController = TextEditingController();
    _ddController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nhomTaiSanEditBloc =
        NhomTaiSanEditBlocProvider.of(context)?.nhomTaiSanEditBloc;
  }

  void _addOrUpdateNhomTaiSan() {
    _nhomTaiSanEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông Tin Nhóm Tài Sản',
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
                stream: _nhomTaiSanEditBloc?.tenNTSEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _tenNTSController.value =
                      _tenNTSController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _tenNTSController,
                    textCapitalization: TextCapitalization.words,
                    maxLines: null,
                    decoration: InputDecoration(
                        labelText: 'Tên Nhóm Tài Sản',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (nts) =>
                        _nhomTaiSanEditBloc?.tenNTSEditChanged.add(nts),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              StreamBuilder(
                stream: _nhomTaiSanEditBloc?.ddEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _ddController.value =
                      _ddController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    controller: _ddController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Đặc Điểm',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (dc) =>
                        _nhomTaiSanEditBloc?.ddEditChanged.add(dc),
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
                      _addOrUpdateNhomTaiSan();
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
