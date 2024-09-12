import 'dart:async';

import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class OriginalPrice extends StatelessWidget {
  OriginalPrice(
      {Key? key,
      required this.originalPriceController,
      required this.stream,
      required this.onChangeFunction,
      this.readOnly})
      : super(key: key);
  final TextEditingController originalPriceController;
  final bool? readOnly;
  final Stream<String>? stream;
  final onChangeFunction;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        originalPriceController.value =
            originalPriceController.value.copyWith(text: snapshot.data);
        return CustomTextFromField(
          readOnly: readOnly ?? false,
          fillColor: readOnly != null && readOnly == true
              ? AppColors.gray
              : AppColors.white,
          inputType: TextInputType.number,
          inputAction: TextInputAction.next,
          controller: originalPriceController,
          labelText: AssetString.ORIGINAL_PRICE,
          prefixIcon: Icons.price_change_outlined,
          onChangeFunction: onChangeFunction /**/,
        );
      },
    );
  }
}
