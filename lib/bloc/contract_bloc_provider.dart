import 'package:assets_manager/bloc/contract_bloc.dart';
import 'package:flutter/material.dart';

class ContractBlocProvider extends InheritedWidget {
  final ContractBloc contractBloc;
  final String uid;

  const ContractBlocProvider(
      {Key? key,
      required Widget child,
      required this.contractBloc,
      required this.uid})
      : super(key: key, child: child);

  static ContractBlocProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ContractBlocProvider>();
  }

  @override
  bool updateShouldNotify(ContractBlocProvider old) =>
      contractBloc != old.contractBloc;
}
