import 'package:assets_manager/bloc/thanhly_bloc.dart';
import 'package:flutter/cupertino.dart';

class ThanhLyBlocProvider extends InheritedWidget {
  final ThanhLyBloc thanhLyBloc;
  final String? uid;

  const ThanhLyBlocProvider(
      {Key? key, required Widget child, required this.thanhLyBloc, this.uid})
      : super(key: key, child: child);

  static ThanhLyBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThanhLyBlocProvider>();
  }

  @override
  bool updateShouldNotify(ThanhLyBlocProvider old) =>
      thanhLyBloc != old.thanhLyBloc;
}
