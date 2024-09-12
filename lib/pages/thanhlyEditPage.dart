import 'package:assets_manager/bloc/thanhly_edit_bloc.dart';
import 'package:assets_manager/bloc/thanhly_edit_bloc_provider.dart';
import 'package:assets_manager/classes/money_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:intl/intl.dart';

class ThanhLyEditPage extends StatefulWidget {
  const ThanhLyEditPage({Key? key}) : super(key: key);

  @override
  _ThanhLyEditPageState createState() => _ThanhLyEditPageState();
}

class _ThanhLyEditPageState extends State<ThanhLyEditPage> {
  ThanhLyEditBloc? thanhLyEditBloc;
  TextEditingController _tenTsController = new TextEditingController();
  TextEditingController _donViTLController = new TextEditingController();
  TextEditingController _nguyenGiaTLController = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tenTsController = TextEditingController();
    _donViTLController = TextEditingController();
    _nguyenGiaTLController = TextEditingController();
    _nguyenGiaTLController = new MoneyMaskedTextControllers(
      thousandSeparator: '.',
      initialValue: 0,
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    thanhLyEditBloc = ThanhLyEditBlocProvider.of(context)?.thanhLyEditBloc;
  }

  void _addOrUpdate() {
    thanhLyEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  Future<String> _selectDatetime(String selectedDate) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(2013, 1, 1),
        maxTime: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xác Nhận Thanh Lý',
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
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 10.0)),
              StreamBuilder(
                stream: thanhLyEditBloc?.tenTsEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _tenTsController.value =
                      _tenTsController.value.copyWith(text: snapshot.data);
                  return TextFormField(
                    readOnly: true,
                    controller: _tenTsController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Tên Tài sản',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (tenTs) =>
                        thanhLyEditBloc?.tenTsEditChanged.add(tenTs),
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ), //Tên TS
              //NgaySX
              StreamBuilder(
                stream: thanhLyEditBloc?.donViTLEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _donViTLController.value =
                      _donViTLController.value.copyWith(text: snapshot.data);
                  return TextField(
                    maxLines: null,
                    controller: _donViTLController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        labelText: 'Đơn Vị Thanh Lý',
                        prefixIcon: Icon(Icons.assignment_outlined),
                        labelStyle:
                            TextStyle(color: Colors.blueAccent, fontSize: 15),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    onChanged: (dv) =>
                        thanhLyEditBloc?.donViTLEditChanged.add(dv),
                  );
                },
              ), //DVTL
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: thanhLyEditBloc?.nguyenGiaTLEdit,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  _nguyenGiaTLController.value = _nguyenGiaTLController.value
                      .copyWith(text: snapshot.data);
                  return new TextField(
                      keyboardType: TextInputType.number,
                      controller: _nguyenGiaTLController,
                      decoration: InputDecoration(
                          labelText: 'Nguyên Giá Thanh Lý',
                          prefixIcon: Icon(Icons.assignment_outlined),
                          labelStyle:
                              TextStyle(color: Colors.blueAccent, fontSize: 15),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.green, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onChanged: (nguyenGia) => {
                            thanhLyEditBloc?.nguyenGiaTLEditChanged
                                .add(_getOnlyNumbers(nguyenGia).toVND()),
                          });
                },
              ), //Nguyên Giá
              //TGSD
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0xffCED0D2)),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: StreamBuilder(
                    stream: thanhLyEditBloc?.ngayTLEdit,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
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
                                  "Ngày thanh lý:  " +
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
                              thanhLyEditBloc?.ngayTLEditChanged
                                  .add(_pickerDate);
                            },
                          )
                        ],
                      );
                    },
                  ),
                ),
              ), //NgayTL
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
                    },
                  ),
                ],
              ) //Save
            ],
          ),
        ),
      ),
    );
  }

  String _getOnlyNumbers(String text) {
    String cleanedText = text;

    var onlyNumbersRegex = new RegExp(r'[^\d]');

    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');

    return cleanedText;
  }
}
