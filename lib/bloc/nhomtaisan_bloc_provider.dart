import 'package:assets_manager/bloc/nhomtaisan_bloc.dart';
import 'package:flutter/material.dart';

class NhomTaiSanBlocProvider extends InheritedWidget {
  final NhomTaiSanBloc nhomTaiSanBloc;
  final String uid;

  const NhomTaiSanBlocProvider(
      {Key? key,
      required Widget child,
      required this.nhomTaiSanBloc,
      required this.uid})
      : super(key: key, child: child);

  static NhomTaiSanBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NhomTaiSanBlocProvider>();
  }

  @override
  bool updateShouldNotify(NhomTaiSanBlocProvider old) =>
      nhomTaiSanBloc != old.nhomTaiSanBloc;
}
