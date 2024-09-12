import 'package:assets_manager/bloc/nhacungcap_edit_bloc.dart';
import 'package:flutter/material.dart';

class NhaCungCapEditBlocProvider extends InheritedWidget {
  final NhaCungCapEditBloc nhaCungCapEditBloc;

  const NhaCungCapEditBlocProvider(
      {Key? key, required Widget child, required this.nhaCungCapEditBloc})
      : super(key: key, child: child);

  static NhaCungCapEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<NhaCungCapEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(NhaCungCapEditBlocProvider old) =>
      nhaCungCapEditBloc != old.nhaCungCapEditBloc;
}
