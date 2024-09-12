import 'dart:io';

import 'package:assets_manager/classes/controlled_countdown.dart';
import 'package:assets_manager/pages/department_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ThongTinNguoiDung extends StatefulWidget {
  const ThongTinNguoiDung({Key? key}) : super(key: key);

  @override
  _ThongTinNguoiDungState createState() => _ThongTinNguoiDungState();
}

class _ThongTinNguoiDungState extends State<ThongTinNguoiDung> {
  XFile? _imageFile;
  bool flag = true;
  bool flags = false;
  String downloadURL = "";
  final ImagePicker _picker = ImagePicker();
  String picture = FirebaseAuth.instance.currentUser?.photoURL ?? "";
  String tenPb = '';
  String maPb = '';
  String email = '';
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String name = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = FirebaseAuth.instance.currentUser?.email ?? "";
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cập Nhật Thông Tin",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        elevation: 0.0,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              TextFormField(
                initialValue: name,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    labelText: 'Họ và Tên',
                    prefixIcon: Icon(Icons.assignment_outlined),
                    labelStyle:
                        TextStyle(color: Colors.blueAccent, fontSize: 15),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                onChanged: (names) => {name = names, print(name)},
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                initialValue: email,
                readOnly: true,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.assignment_outlined),
                    labelStyle:
                        TextStyle(color: Colors.blueAccent, fontSize: 15),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.4,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.assignment_outlined,
                            color: Colors.black54,
                          ),
                          TextButton(
                            onPressed: () async {
                              final String _name = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DepartmentsList(flag: true),
                                ),
                              );
                              setState(() {
                                tenPb = _name.substring(20, _name.length);
                                maPb = _name.substring(0, 20);
                              });
                            },
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Chọn Phòng Ban ",
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 15),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$tenPb',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    showMaterialModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: 90.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                                onPressed: () {
                                  getImage(false);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  child: Text("Bộ Sưu Tập"),
                                  color: Colors.blue.shade100,
                                  padding: EdgeInsets.all(10.0),
                                )),
                            TextButton(
                                onPressed: () {
                                  getImage(true);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    child: Text("Máy Ảnh"),
                                    color: Colors.blue.shade100,
                                    padding: EdgeInsets.all(10.0))),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Chọn Ảnh Đại Diện  "),
                      Icon(Icons.arrow_circle_down_rounded)
                    ],
                  )),
              flag
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.file(File(_imageFile!.path)),
                          color: Colors.blue,
                          padding: EdgeInsets.all(3.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Wrap(
                          spacing: 5.0,
                          runSpacing: 5.0,
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Text(
                              _imageFile!.name,
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.green),
                              maxLines: null,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextButton(
                                onPressed: () {
                                  downloadImage(_imageFile!);
                                  setState(() {
                                    flags = true;
                                  });
                                },
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ],
                    ),
              Divider(
                color: Colors.green,
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
                      if (flags || flag) {
                        FirebaseAuth.instance.currentUser
                            ?.updatePhotoURL(downloadURL);
                        FirebaseAuth.instance.currentUser
                            ?.updateDisplayName(maPb + "|" + name);
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
                        Navigator.pop(context);
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
                                content: Text('Nhấn OK để upload hình ảnh.',
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

  Future getImage(bool isCamera) async {
    XFile? image;
    setState(() {
      flag = true;
    });
    try {
      if (isCamera) {
        image = await _picker.pickImage(source: ImageSource.camera);
      } else {
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
      if (image != null) {
        setState(() {
          _imageFile = image;
          uploadImage(_imageFile!);
          flag = false;
          Navigator.of(context).push(
            MaterialPageRoute<ControlledCountdownPage>(
              builder: (context) => const ControlledCountdownPage(
                title: "Đã tải ảnh lên thành công.",
              ),
            ),
          );
        });
      } else {
        print("Chưa chọn ảnh");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadImage(XFile image) async {
    try {
      File file = File(image.path);
      FirebaseStorage.instance
          .ref('AnhDaiDien/')
          .child("${image.name}")
          .putFile(file);
    } catch (e) {
      print("Lỗi upload ảnh: " + e.toString());
    }
  }

  Future<String> downloadImage(XFile image) async {
    String download = await FirebaseStorage.instance
        .ref('AnhDaiDien/')
        .child("${image.name}")
        .getDownloadURL();
    setState(() {
      downloadURL = download;
    });
    return download;
  }

  Future<void> deleteImage(String url) async {
    FirebaseStorage.instance.refFromURL("$url").delete();
  }
}
