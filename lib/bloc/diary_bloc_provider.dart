
import 'package:assets_manager/bloc/diary_bloc.dart';
import 'package:flutter/cupertino.dart';

class DiaryBlocProvider extends InheritedWidget {
  final DiaryBloc diaryBloc;
  final String uid;

  const DiaryBlocProvider(
      {Key? key,
      required Widget child,
      required this.diaryBloc,
      required this.uid})
      : super(key: key, child: child);

  static DiaryBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DiaryBlocProvider>();
  }

  @override
  bool updateShouldNotify(DiaryBlocProvider old) =>
      diaryBloc != old.diaryBloc;
}
