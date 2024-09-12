import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final double? mineWidth;
  final String textHint;
  final backgroundColor;
  final labelColor;
  final onFunction;
  final EdgeInsets? padding;
  final double? fontSize;
  final double? radius;
  final FontWeight? fontWeight;
  final margin;

  const ButtonCustom(
      {this.mineWidth,
      required this.textHint,
      required this.onFunction,
      this.backgroundColor,
      this.labelColor,
      this.fontSize,
      this.padding,
      this.radius,
      this.fontWeight,
      this.margin,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: mineWidth,
          margin: margin ?? EdgeInsets.zero,
          child: ElevatedButton(
            onPressed: onFunction,
            child: Text(
              textHint,
            ),
            style: ElevatedButton.styleFrom(
                foregroundColor: labelColor,
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius ?? 8)),
                padding: padding ?? EdgeInsets.fromLTRB(0, 12, 0, 12),
                textStyle: TextStyle(
                  fontSize: fontSize ?? 18,
                  fontWeight: fontWeight ?? FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }
}
