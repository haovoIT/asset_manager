import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChooseDepartmentName extends StatelessWidget {
  const ChooseDepartmentName({
    Key? key,
    this.assetsEditBloc,
    required this.departmentNameController,
    required this.title,
    required this.onTap,
    required this.isChanged,
  }) : super(key: key);
  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController departmentNameController;
  final title;
  final onTap;
  final bool isChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffCED0D2)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: StreamBuilder(
          stream: assetsEditBloc?.departmentNameEdit,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            if (isChanged) {
              departmentNameController.value =
                  departmentNameController.value.copyWith(text: snapshot.data);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    GlobalStyles.sizedBoxWidth,
                    Icon(
                      FontAwesomeIcons.houseUser,
                      color: Colors.black54,
                      size: 16,
                    ),
                    GlobalStyles.sizedBoxWidth,
                    Text(
                      title,
                      style: GlobalStyles.textStyleLabelTextFormField,
                    ),
                    GlobalStyles.iconArrowDropDown,
                  ],
                ),
                Text(
                  departmentNameController.text.toString(),
                  style: GlobalStyles.textStyleTextFormField,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
