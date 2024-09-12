import 'package:flutter/material.dart';

class GlobalStyles {
  static final EdgeInsets paddingPageLeftRight =
      EdgeInsets.symmetric(horizontal: 10);
  static final EdgeInsets paddingPageTopBottom =
      EdgeInsets.symmetric(vertical: 10);
  static final EdgeInsets paddingPageLeftRight_15 =
      EdgeInsets.symmetric(horizontal: 15);
  static final EdgeInsets paddingPageLeftRight_25 =
      EdgeInsets.symmetric(horizontal: 25);
  static final EdgeInsets paddingPageLeftRight_45 =
      EdgeInsets.symmetric(horizontal: 45);
  static final EdgeInsets paddingPageLeftRightHV_36_12 =
      EdgeInsets.symmetric(horizontal: 36, vertical: 12);
  static final EdgeInsets paddingAll = EdgeInsets.all(12);
  static final Divider divider = Divider(
    thickness: 2,
  );

  static final SizedBox sizedBoxHeight_5 = SizedBox(
    height: 5,
  );
  static final SizedBox sizedBoxHeight_10 = SizedBox(
    height: 10,
  );
  static final SizedBox sizedBoxHeight = SizedBox(
    height: 15,
  );
  static final SizedBox sizedBoxHeight_20 = SizedBox(
    height: 20,
  );
  static final SizedBox sizedBoxWidth = SizedBox(
    width: 15,
  );
  static final SizedBox sizedBoxWidth_30 = SizedBox(
    width: 30,
  );
  static final SizedBox sizedBoxWidth_10 = SizedBox(
    width: 10,
  );
  static final SizedBox sizedBoxHeight_30 = SizedBox(
    height: 30,
  );

  static final SizedBox sizedBoxHeight_75 = SizedBox(
    height: 75,
  );
  static final SizedBox sizedBoxHeight_100 = SizedBox(
    height: 100,
  );

  static final TextStyle textStyleSize_16 = TextStyle(fontSize: 16);
  static final TextStyle textStyleTextFormField = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle textStyleLabelTextFormField = TextStyle(
    color: Colors.blueAccent,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static final TextStyle textStyleTitle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final Icon iconArrowDropDown = Icon(
    Icons.arrow_drop_down,
    color: Colors.black54,
    size: 24,
  );
}
