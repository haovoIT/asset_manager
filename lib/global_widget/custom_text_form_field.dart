import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';

class CustomTextFromField extends StatelessWidget {
  CustomTextFromField(
      {super.key,
      required this.controller,
      this.hintText,
      this.labelText,
      this.errorText,
      this.inputType,
      this.inputAction,
      this.validator,
      this.onChangeFunction,
      this.maxLengthText,
      this.label,
      this.prefixIcon,
      this.textCapitalization,
      this.maxLines,
      this.readOnly,
      this.fillColor});

  final TextEditingController controller;
  final label;

  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final String? Function(String?)? validator;
  final Function(String)? onChangeFunction;
  final int? maxLengthText;
  final prefixIcon;
  final textCapitalization;
  final readOnly;
  final fillColor;
  final maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      style: GlobalStyles.textStyleTextFormField,
      textAlign: TextAlign.start,
      maxLines: maxLines ?? 1,
      maxLength: maxLengthText ?? null,
      autofocus: false,
      keyboardType: inputType ?? TextInputType.text,
      textInputAction: inputAction ?? TextInputAction.next,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        labelText: labelText ?? "",
        hintText: hintText ?? "",
        labelStyle: GlobalStyles.textStyleLabelTextFormField,
        fillColor: fillColor ?? AppColors.white,
        filled: true,
        isDense: true,
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
        ),
        hintStyle:
            TextStyle(color: AppColors.gray, fontWeight: FontWeight.w400),
        contentPadding: EdgeInsets.all(18),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.gray),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.main),
            borderRadius: BorderRadius.circular(8)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.gray),
            borderRadius: BorderRadius.circular(8)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.main),
            borderRadius: BorderRadius.circular(8)),
      ),
      onChanged: onChangeFunction,
    );
  }
}
