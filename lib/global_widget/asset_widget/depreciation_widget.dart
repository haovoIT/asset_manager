import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class DepreciationWidget extends StatelessWidget {
  const DepreciationWidget({
    super.key,
    required this.depreciationController,
    required this.stream,
    required this.sink,
    this.readOnly,
  });
  final TextEditingController depreciationController;
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
          depreciationController.value =
              depreciationController.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            controller: depreciationController,
            readOnly: readOnly ?? false,
            onChangeFunction: (depreciation) => sink?.add(depreciation),
            labelText: AssetString.LABEL_TEXT_DEPRECIATION,
            prefixIcon: Icons.assignment_outlined,
            textCapitalization: TextCapitalization.words,
          );
        },
      ),
    );
  }
}
