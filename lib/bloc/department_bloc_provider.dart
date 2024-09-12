import 'package:assets_manager/bloc/department_bloc.dart';
import 'package:flutter/material.dart';

class DepartmentBlocProvider extends InheritedWidget {
  final DepartmentBloc departmentBloc;
  final String uid;

  const DepartmentBlocProvider(
      {Key? key,
      required Widget child,
      required this.departmentBloc,
      required this.uid})
      : super(key: key, child: child);

  static DepartmentBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DepartmentBlocProvider>();
  }

  @override
  bool updateShouldNotify(DepartmentBlocProvider old) =>
      departmentBloc != old.departmentBloc;
}
