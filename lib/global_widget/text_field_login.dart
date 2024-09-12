import 'package:assets_manager/component/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldLogin extends StatelessWidget {
  const TextFieldLogin(
      {Key? key,
      this.hintText,
      this.controller,
      this.labelText,
      this.errorText,
      this.inputType,
      this.inputAction,
      this.validator,
      this.onChangeFunction,
      this.inputFormatCustom,
      this.maxLengthText})
      : super(key: key);

  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final controller;
  final String? Function(String?)? validator;
  final Function(String)? onChangeFunction;
  final FilteringTextInputFormatter? inputFormatCustom;
  final int? maxLengthText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText ?? "",
        hintText: hintText ?? "",
        fillColor: AppColors.white,
        filled: true,
        counterText: "",
        isDense: true,
        errorStyle: TextStyle(color: Colors.red),
        labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 18),
        errorText: errorText ?? "",
        prefixIcon: Icon(Icons.email),
        hintStyle:
            TextStyle(color: AppColors.gray, fontWeight: FontWeight.w400),
        contentPadding: EdgeInsets.all(18),
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
      style: TextStyle(color: Colors.black, fontSize: 18),
      controller: controller,
      // validator: validator,
      inputFormatters: [
        inputFormatCustom ?? FilteringTextInputFormatter.singleLineFormatter
      ],

      textAlign: TextAlign.start,
      maxLines: 1,
      maxLength: maxLengthText ?? null,
      autofocus: false,
      keyboardType: inputType,
      textInputAction: inputAction,
      onChanged: onChangeFunction,
    );
  }
}
