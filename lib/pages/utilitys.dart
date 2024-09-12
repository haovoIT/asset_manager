import 'package:assets_manager/pages/biencotaisan.dart';
import 'package:assets_manager/pages/kehoachkiemkePage.dart';
import 'package:assets_manager/pages/maqrtaisan.dart';
import 'package:assets_manager/pages/quetQR.dart';
import 'package:assets_manager/pages/thanhlyPage.dart';
import 'package:assets_manager/pages/thongkethuctrang.dart';
import 'package:flutter/material.dart';

class Utilitys extends StatelessWidget {
  const Utilitys({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: GridView.builder(
        itemCount: choices.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            color: Color(0xD3FCFCFC),
            borderOnForeground: true,
            margin: EdgeInsets.all(8.0),
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(choices[index].icon,
                      size: 75.0, color: Color(0xFF027CFF)),
                  Divider(),
                  Text(
                    choices[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color(0xFF027CFF),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              onTap: () {
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TTTaiSans(),
                      ),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuetQR(),
                      ),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BienCoTaiSan(),
                      ),
                    );
                    break;
                  case 3:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThongKeThucTrang(),
                      ),
                    );
                    break;
                  case 4:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KeHoachKiemKePage(),
                      ),
                    );
                    break;
                  case 5:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThanhLyPage(),
                      ),
                    );
                    break;
                  case 6:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ThanhLyPage(),
                      ),
                    );
                    break;
                  case 7:
                    break;
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(
    title: 'Thông Tin Tài Sản',
    icon: Icons.article_sharp,
  ),
  const Choice(title: 'Quét QR', icon: Icons.qr_code_scanner),
  const Choice(
      title: 'Biến cố Tài Sản', icon: Icons.align_vertical_center_rounded),
  const Choice(title: 'Thực Trạng', icon: Icons.stream),
  const Choice(title: 'Kế Hoạch Kiểm Kê', icon: Icons.alarm_on_rounded),
  const Choice(title: 'Thanh Lý', icon: Icons.outbond_rounded),
  //const Choice(title: 'Giới Thiệu', icon: Icons.mic_external_on_outlined),
  //const Choice(title: 'Đăng Xuất', icon: Icons.login),
];
