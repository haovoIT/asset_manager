import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/pages/biencotaisan.dart';
import 'package:assets_manager/pages/contract_page.dart';
import 'package:assets_manager/pages/department_page.dart';
import 'package:assets_manager/pages/gioithieu.dart';
import 'package:assets_manager/pages/nhacungcapPage.dart';
import 'package:assets_manager/pages/nhomtaisanPage.dart';
import 'package:assets_manager/pages/thongtinnguoidungEdit.dart';
import 'package:assets_manager/pages/updatePassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LeftDrawerWidget extends StatelessWidget {
  const LeftDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LeftDrawerWidgets extends StatefulWidget {
  const LeftDrawerWidgets({Key? key}) : super(key: key);

  @override
  _LeftDrawerWidgetsState createState() => _LeftDrawerWidgetsState();
}

class _LeftDrawerWidgetsState extends State<LeftDrawerWidgets> {
  AuthenticationBloc? _authenticationBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationBloc =
        AuthenticationBlocProvider.of(context)?.authenticationBloc;
  }

  @override
  Widget build(BuildContext context) {
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    String name = FirebaseAuth.instance.currentUser?.displayName ?? "";
    String picture = FirebaseAuth.instance.currentUser?.photoURL ?? "";
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            currentAccountPicture: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThongTinNguoiDung(),
                  ),
                );
              },
              child: picture == ""
                  ? Image.asset(
                      "assets/images/ic_launcher_round.png",
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(picture),
                    ),
            ),
            accountName: Text(
              "Đại Học Trần Đại Nghĩa",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            accountEmail: Text(
              email,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            ),
            /*decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/leftdrawer.jpg'),
                    fit: BoxFit.cover
                )
            ),*/
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text("Quản Lí Phòng Ban"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DepartmentsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Quản Lí Hợp Đồng"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContractPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Quản Lí Nhóm Tài Sản"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NhomTaiSanPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Quản Lí Nhà Cung Cấp"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NhaCungCapPage(),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                title: Text("Tài Sản Sự Cố"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BienCoTaiSan(),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                title: Text("Thông Tin Người Dùng"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThongTinNguoiDung(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Thiết Lập Mật Khẩu"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePassword(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Đăng Xuất"),
                onTap: () async {
                  final signOut = await _signOut();
                  if (signOut) {
                    _authenticationBloc?.logoutUser.add(true);
                  }
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                title: Text("Giới thiệu"),
                onTap: () async {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GioiThieu(),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> _signOut() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Đăng xuất",
              style: TextStyle(
                  color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            content: Text('Bạn có chắc chắn muốn đăng xuất không?'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('Thoát')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    'Đăng xuất',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
