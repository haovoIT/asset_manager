import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:flutter/material.dart';

class HomeBlocProvider extends InheritedWidget {
  final HomeBloc homeBloc;
  final String uid;
  @override
  bool updateShouldNotify(HomeBlocProvider old) => homeBloc != old.homeBloc;

  const HomeBlocProvider({
    Key? key,
    required Widget child,
    required this.homeBloc,
    required this.uid,
  }) : super(key: key, child: child);

  static HomeBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeBlocProvider>();
  }
}
