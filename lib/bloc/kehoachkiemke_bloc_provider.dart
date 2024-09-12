import 'package:assets_manager/bloc/kehoachkiemke_bloc.dart';
import 'package:flutter/cupertino.dart';

class KeHoachKiemKeBlocProvider extends InheritedWidget {
  final KeHoachKiemKeBloc keHoachKiemKeBloc;
  final String uid;

  const KeHoachKiemKeBlocProvider(
      {Key? key,
      required Widget child,
      required this.keHoachKiemKeBloc,
      required this.uid})
      : super(key: key, child: child);

  static KeHoachKiemKeBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<KeHoachKiemKeBlocProvider>();
  }

  @override
  bool updateShouldNotify(KeHoachKiemKeBlocProvider old) =>
      keHoachKiemKeBloc != old.keHoachKiemKeBloc;
}
