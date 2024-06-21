import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class EmailWidget extends StatelessWidget {
  EmailWidget({
    super.key,
    required this.stream,
    required this.sink,
    required this.controller,
  });

  final TextEditingController controller;
  final Stream<String>? stream;
  final Sink<String>? sink;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        controller.value = controller.value.copyWith(text: snapshot.data);
        return CustomTextFromField(
          maxLines: 5,
          inputType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          controller: controller,
          labelText: SupplierString.LABEL_EMAIL,
          prefixIcon: Icons.assignment_outlined,
          onChangeFunction: (value) => sink?.add(value),
        );
      },
    );
  }
}
