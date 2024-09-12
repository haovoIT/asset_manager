import 'package:assets_manager/bloc/login_bloc.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  _UpdatePasswordState createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  LoginBloc? loginBloc;
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPassController = new TextEditingController();
  bool _showpass = false;
  String _email = FirebaseAuth.instance.currentUser?.email ?? "";
  String _name = FirebaseAuth.instance.currentUser?.displayName ?? "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordController = TextEditingController();
    _confirmPassController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginBloc = LoginBloc(
      context: context,
      authenticationApi: AuthenticationServer(context),
    );
  }

  void _addOrUpdate() {
    loginBloc?.updatePasswordEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đổi Mật Khẩu"),
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                child: Image.asset('assets/images/Logo.png'),
              ),
              Container(
                height: 20.0,
              ),
              Text(
                "Quản Lí Tài Sản",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                child: TextFormField(
                  initialValue:
                      _name != null ? _name : "Cập nhật tên người dùng",
                  readOnly: true,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                  decoration: InputDecoration(
                      labelText: "Tên người dùng ",
                      prefixIcon: Icon(Icons.account_box_rounded),
                      labelStyle:
                          TextStyle(color: Colors.blueAccent, fontSize: 15),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: TextFormField(
                  initialValue: _email,
                  readOnly: true,
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                  decoration: InputDecoration(
                      labelText: "Email ",
                      prefixIcon: Icon(Icons.email),
                      labelStyle:
                          TextStyle(color: Colors.blueAccent, fontSize: 15),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED0D2), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              Container(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            StreamBuilder(
                              stream: loginBloc?.updatePassEdit,
                              builder: (context, snapshot) => TextFormField(
                                controller: _passwordController,
                                style:
                                    TextStyle(fontSize: 18, color: Colors.blue),
                                obscureText: !_showpass,
                                decoration: InputDecoration(
                                    labelText: "Mật Khẩu mới",
                                    hintText: "Mật khẩu trên 6 kí tự",
                                    errorText: snapshot.error.toString(),
                                    prefixIcon: Icon(Icons.lock_outline),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffCED0D2), width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelStyle: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 15)),
                                onChanged: (pass) =>
                                    loginBloc?.updatePassEditChanged.add(pass),
                              ),
                            ),
                            GestureDetector(
                                onTap: onShowPass,
                                child: Icon(
                                  _showpass
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ))
                          ],
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                        child: Stack(
                          alignment: AlignmentDirectional.centerEnd,
                          children: <Widget>[
                            TextFormField(
                              controller: _confirmPassController,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                              obscureText: !_showpass,
                              decoration: InputDecoration(
                                  labelText: "Nhập lại Mật Khẩu Mới",
                                  hintText: "Mật khẩu trên 6 kí tự",
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffCED0D2), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelStyle: TextStyle(
                                      color: Colors.blueAccent, fontSize: 15)),
                            ),
                            GestureDetector(
                                onTap: onShowPass,
                                child: Icon(
                                  _showpass
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ))
                          ],
                        )),
                  ],
                ),
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
                      if (_passwordController.text.toString() ==
                          _confirmPassController.text.toString()) {
                        _addOrUpdate();
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
                      } else {
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
                                content: Text(
                                    'Mật Khẩu Không Khớp. Vui lòng nhập lại.',
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
                      }
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

  @override
  void dispose() {
    loginBloc?.dispose();
    super.dispose();
  }

  void onShowPass() {
    setState(() {
      _showpass = !_showpass;
    });
  }
}
