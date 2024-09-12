import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NumberContractWidget extends StatelessWidget {
  const NumberContractWidget({
    super.key,
    required this.controller,
    required this.stream,
    required this.sink,
    this.readOnly,
  });
  final TextEditingController controller;
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
          controller.value = controller.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            controller: controller,
            onChangeFunction: (code) => sink?.add(code),
            labelText: ContractString.NUMBER_CONTRACT,
            prefixIcon: Icons.code,
            textCapitalization: TextCapitalization.characters,
          );
        },
      ),
    );
  }
}
