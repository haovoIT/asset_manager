import 'package:assets_manager/bloc/supplier_bloc.dart';
import 'package:flutter/material.dart';

class SupplierBlocProvider extends InheritedWidget {
  final SupplierBloc supplierBloc;
  final String uid;

  const SupplierBlocProvider(
      {Key? key,
      required Widget child,
      required this.supplierBloc,
      required this.uid})
      : super(key: key, child: child);

  static SupplierBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SupplierBlocProvider>();
  }

  @override
  bool updateShouldNotify(SupplierBlocProvider old) =>
      supplierBloc != old.supplierBloc;
}
