import 'package:assets_manager/bloc/nhacungcap_bloc.dart';
import 'package:flutter/material.dart';

class NhaCungCapBlocProvider extends InheritedWidget {
  final NhaCungCapBloc nhaCungCapBloc;
  final String uid;

  const NhaCungCapBlocProvider(
      {Key? key,
      required Widget child,
      required this.nhaCungCapBloc,
      required this.uid})
      : super(key: key, child: child);

  static NhaCungCapBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NhaCungCapBlocProvider>();
  }

  @override
  bool updateShouldNotify(NhaCungCapBlocProvider old) =>
      nhaCungCapBloc != old.nhaCungCapBloc;
}
