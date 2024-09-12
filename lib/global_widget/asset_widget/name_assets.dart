import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NameAssets extends StatelessWidget {
  const NameAssets({
    super.key,
    required this.nameAssetController,
    required this.stream,
    required this.sink,
    this.readOnly,
  });
  final TextEditingController nameAssetController;
  final Stream<String>? stream;
  final Sink<String>? sink;
  final readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          nameAssetController.value =
              nameAssetController.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            controller: nameAssetController,
            readOnly: readOnly ?? false,
            onChangeFunction: (nameAsset) => sink?.add(nameAsset),
            labelText: AssetString.LABEL_TEXT_NAME_ASSETS,
            prefixIcon: Icons.assignment_outlined,
            textCapitalization: TextCapitalization.words,
          );
        },
      ),
    );
  }
}
