import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';

class ChooseDetail extends StatelessWidget {
  const ChooseDetail(
      {Key? key,
      required this.detailController,
      required this.stream,
      required this.sink})
      : super(key: key);
  final Stream<String>? stream;
  final Sink<String>? sink;
  final TextEditingController detailController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? status = await Alert.selectDetail(context);
        sink?.add(Alert.getOnlyCharacters(status ?? ""));
      },
      child: Container(
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
            detailController.value =
                detailController.value.copyWith(text: snapshot.data);
            return Row(
              children: <Widget>[
                GlobalStyles.sizedBoxWidth,
                Icon(
                  Icons.stacked_bar_chart,
                  size: 22.0,
                  color: Colors.black54,
                ),
                GlobalStyles.sizedBoxWidth,
                Text(
                  AssetString.DETAIL,
                  style: GlobalStyles.textStyleLabelTextFormField,
                ),
                Text(
                  snapshot.data.toString(),
                  style: GlobalStyles.textStyleTextFormField,
                ),
                GlobalStyles.iconArrowDropDown,
              ],
            );
          },
        ),
      ),
    );
  }
}
