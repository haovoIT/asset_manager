import 'package:assets_manager/component/global_styles.dart';
import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  const AppBarCustom({
    super.key,
    required this.title,
    this.actions,
  });
  final title;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GlobalStyles.textStyleTitle,
      ),
      automaticallyImplyLeading: false,
      elevation: 0.0,
      actions: actions ??
          <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.lightGreen.shade800,
                ))
          ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
