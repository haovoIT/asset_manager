import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:flutter/material.dart';

class AssetsEditBlocProvider extends InheritedWidget {
  final AssetsEditBloc assetsEditBloc;

  const AssetsEditBlocProvider(
      {Key? key, required Widget child, required this.assetsEditBloc})
      : super(key: key, child: child);

  static AssetsEditBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AssetsEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(AssetsEditBlocProvider old) => false;
}
