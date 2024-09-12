import 'package:assets_manager/component/app_colors.dart';
import 'package:flutter/material.dart';

class PasswordCustom extends StatefulWidget {
  const PasswordCustom(
      {Key? key,
      this.hintText,
      required this.inputType,
      this.controller,
      this.inputAction,
      this.labelText,
      this.errorText,
      this.onChangeFunction,
      this.validator})
      : super(key: key);
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final controller;
  final String? Function(String?)? validator;
  final Function(String)? onChangeFunction;

  @override
  _PassWordCustomState createState() => _PassWordCustomState();
}

class _PassWordCustomState extends State<PasswordCustom> {
  bool onTapIcon = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: widget.hintText,
          fillColor: AppColors.white,
          filled: true,
          errorMaxLines: 3,
          prefixIcon: Icon(Icons.lock_outline),
          labelText: widget.labelText,
          errorText: widget.errorText,
          hintStyle: TextStyle(color: AppColors.gray),
          isDense: true,
          contentPadding: EdgeInsets.all(18),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                onTapIcon = !onTapIcon;
              });
            },
            child: onTapIcon
                ? Icon(
                    Icons.visibility_off_outlined,
                    size: 25,
                  )
                : Icon(
                    Icons.visibility_outlined,
                    color: AppColors.main,
                    size: 25,
                  ),
          ),
          //errorStyle: TextStyle(color: Colors.white),
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
          labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 18)),
      style: TextStyle(color: Colors.black, fontSize: 18),
      controller: widget.controller,
      // validator: widget.validator,
      maxLines: 1,
      textAlign: TextAlign.start,
      obscureText: onTapIcon,
      keyboardType: widget.inputType,
      textInputAction: widget.inputAction,
      onChanged: widget.onChangeFunction,
    );
  }
}
