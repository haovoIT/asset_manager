import 'package:assets_manager/bloc/nhomtaisan_edit_bloc.dart';
import 'package:flutter/material.dart';

class NhomTaiSanEditBlocProvider extends InheritedWidget {
  final NhomTaiSanEditBloc nhomTaiSanEditBloc;
  final String? uid;

  const NhomTaiSanEditBlocProvider(
      {Key? key,
      required Widget child,
      required this.nhomTaiSanEditBloc,
      this.uid})
      : super(key: key, child: child);
  static NhomTaiSanEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NhomTaiSanEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(NhomTaiSanEditBlocProvider old) =>
      nhomTaiSanEditBloc != old.nhomTaiSanEditBloc;
}
