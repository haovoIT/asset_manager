import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PhoneWidget extends StatelessWidget {
  const PhoneWidget({
    super.key,
    required this.phoneController,
    required this.stream,
    required this.sink,
    this.readOnly,
  });
  final TextEditingController phoneController;
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
          phoneController.value =
              phoneController.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            maxLengthText: 15,
            controller: phoneController,
            readOnly: readOnly ?? false,
            onChangeFunction: (name) => sink?.add(name),
            labelText: DepartmentString.LABEL_TEXT_PHONE,
            prefixIcon: Icons.phone,
            inputType: TextInputType.phone,
          );
        },
      ),
    );
  }
}
