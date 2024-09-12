import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc.dart';
import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc_provider.dart';
import 'package:assets_manager/pages/department_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class KeHoachKiemKeEditPage extends StatefulWidget {
  const KeHoachKiemKeEditPage({Key? key}) : super(key: key);

  @override
  _KeHoachKiemKeEditPageState createState() => _KeHoachKiemKeEditPageState();
}

class _KeHoachKiemKeEditPageState extends State<KeHoachKiemKeEditPage> {
  KeHoachKiemKeEditBloc? keHoachKiemKeEditBloc;
  String tenPb = '';
  bool pb = true;
  String ngaySX = '2013-01-01 00:00:00.000000';
  List<String> list = [];

  Future<String> _selectDatetime(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2013, 1, 1),
        maxTime: DateTime(2050, 1, 1),
        theme: DatePickerTheme(
            headerColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        currentTime: _initialDate,
        locale: LocaleType.vi);

    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second,
              DateTime.now().millisecond,
              DateTime.now().microsecond)
          .toString();
    }
    return selectedDate;
  }

  void _addOrUpdateKHKK() {
    keHoachKiemKeEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    keHoachKiemKeEditBloc =
        KeHoachKiemKeEditBlocProvider.of(context)?.keHoachKiemKeEditBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tạo Kế Hoạch Kiểm Kê',
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: pb ? Colors.red : Color(0xffCED0D2)),
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
                                tenPb = _name;
                                pb = false;
                              });
                              keHoachKiemKeEditBloc?.maPbEditChanged
                                  .add(_name.substring(0, 20));
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
                        pb ? '$tenPb' : "${tenPb.substring(20, tenPb.length)}",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: keHoachKiemKeEditBloc?.ngayKKEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        ngaySX = snapshot.data;
                      }

                      return Row(
                        children: <Widget>[
                          Container(
                            width: 10.0,
                          ),
                          Icon(
                            Icons.calendar_today,
                            size: 22.0,
                            color: Colors.black54,
                          ),
                          TextButton(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "Ngày kiểm kê:  " +
                                      DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(snapshot.data)),
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 15),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              String _pickerDate =
                                  await _selectDatetime(snapshot.data);
                              keHoachKiemKeEditBloc?.ngayKKEditChanged
                                  .add(_pickerDate);
                              setState(() {
                                ngaySX = _pickerDate;
                              });
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 24),
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
                      if (!pb) {
                        list.add(
                            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx Chưa thực hiện kiểm kê. Người dùng nên tiến hành thực hiện quá trình kiểm kê để có kết quả kiểm kê.");
                        keHoachKiemKeEditBloc?.listAssetsEditChanged.add(list);
                        _addOrUpdateKHKK();
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
                                content: Text("Lưu thông tin thành công.",
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
                                content: Text("* Bắt buộc nhập hoặc chọn.",
                                    style: TextStyle(
                                        color: Colors.red,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
