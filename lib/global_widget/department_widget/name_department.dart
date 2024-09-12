import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class NameDepartment extends StatelessWidget {
  const NameDepartment({
    super.key,
    required this.nameController,
    required this.stream,
    required this.sink,
    this.readOnly,
  });
  final TextEditingController nameController;
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
          nameController.value =
              nameController.value.copyWith(text: snapshot.data);

          return CustomTextFromField(
            maxLengthText: 30,
            controller: nameController,
            readOnly: readOnly ?? false,
            onChangeFunction: (name) => sink?.add(name),
            labelText: DepartmentString.LABEL_TEXT_NAME,
            prefixIcon: Icons.assignment_outlined,
            textCapitalization: TextCapitalization.words,
          );
        },
      ),
    );
  }
}
