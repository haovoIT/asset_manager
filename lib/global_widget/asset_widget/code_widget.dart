import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class CodeWidget extends StatelessWidget {
  const CodeWidget({
    super.key,
    required this.codeController,
    required this.stream,
    required this.sink,
    this.readOnly,
  });
  final TextEditingController codeController;
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
          codeController.value =
              codeController.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            controller: codeController,
            readOnly: readOnly ?? false,
            onChangeFunction: (code) => sink?.add(code),
            labelText: AssetString.LABEL_TEXT_CODE,
            prefixIcon: Icons.code,
            textCapitalization: TextCapitalization.characters,
          );
        },
      ),
    );
  }
}
