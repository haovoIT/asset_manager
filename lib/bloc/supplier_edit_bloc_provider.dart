import 'package:assets_manager/bloc/supplier_edit_bloc.dart';
import 'package:flutter/material.dart';

class SupplierEditBlocProvider extends InheritedWidget {
  final SupplierEditBloc supplierEditBloc;

  const SupplierEditBlocProvider(
      {Key? key, required Widget child, required this.supplierEditBloc})
      : super(key: key, child: child);

  static SupplierEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SupplierEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(SupplierEditBlocProvider old) =>
      supplierEditBloc != old.supplierEditBloc;
}
