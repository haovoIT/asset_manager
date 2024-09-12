import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/select_user_time.dart';
import 'package:flutter/material.dart';

class UsedTime extends StatelessWidget {
  UsedTime({
    Key? key,
    required this.usedTimeController,
    this.userTimes,
    required this.onChangedFunction,
    required this.stream,
    this.readOnly,
  }) : super(key: key);
  final Stream<String>? stream;
  final readOnly;
  final TextEditingController usedTimeController;
  final onChangedFunction;
  int? userTimes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffCED0D2)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white),
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          usedTimeController.value =
              usedTimeController.value.copyWith(text: snapshot.data);
          if (usedTimeController.text.length > 0) {
            userTimes = int.parse(usedTimeController.text);
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.date_range_sharp,
                size: 20.0,
                color: Colors.black54,
              ),
              GlobalStyles.sizedBoxWidth_10,
              Text(
                AssetString.USER_TIME,
                style: GlobalStyles.textStyleLabelTextFormField,
              ),
              SelectUserTime(
                  selectItem: snapshot.data,
                  onChangedFunction: onChangedFunction),
              Text(
                AssetString.MONTH,
                style: TextStyle(color: Colors.blueAccent, fontSize: 15),
              ),
            ],
          );
        },
      ),
    );
  }
}
