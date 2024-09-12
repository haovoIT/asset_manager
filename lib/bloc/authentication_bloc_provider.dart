import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc authenticationBloc;

  const AuthenticationBlocProvider(
      {Key? key, required Widget child, required this.authenticationBloc})
      : super(key: key, child: child);

  static AuthenticationBlocProvider? of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>());
  }

  @override
  bool updateShouldNotify(AuthenticationBlocProvider old) =>
      authenticationBloc != old.authenticationBloc;
}
