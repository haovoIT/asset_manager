import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseYearOfManufacture extends StatelessWidget {
  ChooseYearOfManufacture({
    Key? key,
    required this.assetsEditBloc,
    required this.userTime,
  }) : super(key: key);
  final AssetsEditBloc? assetsEditBloc;
  final userTime;

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
        stream: assetsEditBloc?.yearOfManufactureEdit,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return GestureDetector(
            onTap: () async {
              String _pickerDate = await Alert.selectDatetime(context,
                  selectedDate: snapshot.data);

              assetsEditBloc?.yearOfManufactureEditChanged.add(_pickerDate);
              assetsEditBloc?.starDateEditChanged.add(_pickerDate);
              final endDate = Alert.addMonth(userTime, _pickerDate);
              assetsEditBloc?.endDateEditChanged.add(endDate);
            },
            child: Row(
              children: <Widget>[
                GlobalStyles.sizedBoxWidth,
                Icon(
                  Icons.date_range,
                  size: 18.0,
                  color: Colors.black54,
                ),
                GlobalStyles.sizedBoxWidth,
                Text(
                  AssetString.YEAR_OF_MANUFACTURE,
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
