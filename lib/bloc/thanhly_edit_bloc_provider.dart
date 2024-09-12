import 'package:assets_manager/bloc/thanhly_edit_bloc.dart';
import 'package:flutter/cupertino.dart';

class ThanhLyEditBlocProvider extends InheritedWidget {
  final ThanhLyEditBloc thanhLyEditBloc;
  final String? uid;

  const ThanhLyEditBlocProvider(
      {Key? key,
      required Widget child,
      required this.thanhLyEditBloc,
      this.uid})
      : super(key: key, child: child);

  static ThanhLyEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThanhLyEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(ThanhLyEditBlocProvider old) =>
      thanhLyEditBloc != old.thanhLyEditBloc;
}
