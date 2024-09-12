import 'package:assets_manager/component/index.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.bgAuthentication),
            fit: BoxFit.fill,
          ),
          color: AppColors.whiteBg),
      child: child,
    );
  }
}
