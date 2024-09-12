import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndDate extends StatelessWidget {
  EndDate({Key? key, required this.stream}) : super(key: key);
  final Stream<String>? stream;

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
          return Row(
            children: <Widget>[
              GlobalStyles.sizedBoxWidth,
              Icon(
                Icons.edit_calendar_outlined,
                size: 18.0,
                color: Colors.black54,
              ),
              GlobalStyles.sizedBoxWidth,
              Text(
                AssetString.END_DATE,
                style: GlobalStyles.textStyleLabelTextFormField,
              ),
              Text(
                DateFormat('dd/ MM/ yyyy')
                    .format(DateTime.parse(snapshot.data)),
                style: GlobalStyles.textStyleTextFormField,
              ),
              //GlobalStyles.iconArrowDropDown,
            ],
          );
        },
      ),
    );
  }
}
