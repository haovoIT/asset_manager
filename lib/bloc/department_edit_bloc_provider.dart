import 'package:assets_manager/bloc/department_edit_bloc.dart';
import 'package:flutter/material.dart';

class DepartmentEditBlocProvider extends InheritedWidget {
  final DepartmentEditBloc departmentEditBloc;

  const DepartmentEditBlocProvider(
      {Key? key, required Widget child, required this.departmentEditBloc})
      : super(key: key, child: child);

  static DepartmentEditBlocProvider? of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<DepartmentEditBlocProvider>());
  }

  @override
  bool updateShouldNotify(DepartmentEditBlocProvider old) => false;
}
