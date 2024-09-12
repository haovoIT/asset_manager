import 'package:assets_manager/bloc/kehoachkiemke_edit_bloc.dart';
import 'package:flutter/material.dart';

class KeHoachKiemKeEditBlocProvider extends InheritedWidget {
  final KeHoachKiemKeEditBloc keHoachKiemKeEditBloc;

  const KeHoachKiemKeEditBlocProvider(
      {Key? key, required Widget child, required this.keHoachKiemKeEditBloc})
      : super(key: key, child: child);

  static KeHoachKiemKeEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<KeHoachKiemKeEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(KeHoachKiemKeEditBlocProvider old) => false;
}
