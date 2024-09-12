import 'package:assets_manager/bloc/contract_edit_bloc.dart';
import 'package:flutter/material.dart';

class ContractEditBlocProvider extends InheritedWidget {
  final ContractEditBloc contractEditBloc;

  const ContractEditBlocProvider(
      {Key? key, required Widget child, required this.contractEditBloc})
      : super(key: key, child: child);

  static ContractEditBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ContractEditBlocProvider>();
  }

  @override
  bool updateShouldNotify(ContractEditBlocProvider old) => false;
}
