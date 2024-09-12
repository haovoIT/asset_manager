import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';

class ChooseStatus extends StatelessWidget {
  const ChooseStatus(
      {Key? key, this.assetsEditBloc, required this.statusController})
      : super(key: key);
  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController statusController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        String? status = await Alert.selectStatus(context);
        assetsEditBloc?.statusEditChanged
            .add(Alert.getOnlyCharacters(status ?? ""));
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
          stream: assetsEditBloc?.statusEdit,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            statusController.value =
                statusController.value.copyWith(text: snapshot.data);
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
                  AssetString.STATUS,
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
