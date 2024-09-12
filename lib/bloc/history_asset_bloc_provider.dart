import 'package:assets_manager/bloc/history_asset_bloc.dart';
import 'package:flutter/material.dart';

class HistoryAssetBlocProvider extends InheritedWidget {
  final HistoryAssetBloc historyAssetBloc;
  final String uid;

  const HistoryAssetBlocProvider(
      {Key? key,
      required Widget child,
      required this.historyAssetBloc,
      required this.uid})
      : super(key: key, child: child);

  static HistoryAssetBlocProvider? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<HistoryAssetBlocProvider>();
  }

  @override
  bool updateShouldNotify(HistoryAssetBlocProvider old) =>
      historyAssetBloc != old.historyAssetBloc;
}
