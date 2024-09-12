import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/pages/nhomtaisanList.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AssetGroupName extends StatelessWidget {
  const AssetGroupName(
      {Key? key, this.assetsEditBloc, required this.assetGroupNameController})
      : super(key: key);
  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController assetGroupNameController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String _assetGroupName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NhomTaiSansList(),
          ),
        );
        assetsEditBloc?.assetGroupNameEditChanged.add(_assetGroupName);
      },
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
          stream: assetsEditBloc?.assetGroupNameEdit,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            assetGroupNameController.value =
                assetGroupNameController.value.copyWith(text: snapshot.data);
            /*if (assetGroupNameController.text.length > 1) {
              nts = false;
            }*/
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GlobalStyles.sizedBoxWidth,
                    Icon(
                      FontAwesomeIcons.groupArrowsRotate,
                      color: Colors.black54,
                      size: 18.0,
                    ),
                    GlobalStyles.sizedBoxWidth,
                    Text(
                      AssetString.CHOOSE_ASSET_GROUP,
                      style: GlobalStyles.textStyleLabelTextFormField,
                    ),
                    GlobalStyles.iconArrowDropDown,
                  ],
                ),
                Text(
                  assetGroupNameController.text.toString(),
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
