import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SigningDate extends StatelessWidget {
  SigningDate({
    Key? key,
    required this.stream,
    required this.sink,
    required this.controller,
  }) : super(key: key);
  final Stream<String>? stream;
  final Sink<String>? sink;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xffCED0D2),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          controller.value = controller.value.copyWith(text: snapshot.data);

          return GestureDetector(
            onTap: () async {
              String _pickerDate = await Alert.selectDatetime(
                context,
                selectedDate: snapshot.data,
              );
              controller.text = _pickerDate;
              sink?.add(_pickerDate);
            },
            child: Row(
              children: <Widget>[
                GlobalStyles.sizedBoxWidth,
                Icon(
                  Icons.start_outlined,
                  size: 18.0,
                  color: Colors.black54,
                ),
                GlobalStyles.sizedBoxWidth,
                Text(
                  ContractString.SIGNING_DATE,
                  style: GlobalStyles.textStyleLabelTextFormField,
                ),
                Text(
                  DateFormat('dd/ MM/ yyyy')
                      .format(DateTime.parse(snapshot.data)),
                  style: GlobalStyles.textStyleTextFormField,
                ),
                GlobalStyles.iconArrowDropDown,
              ],
            ),
          );
        },
      ),
    );
  }
}
