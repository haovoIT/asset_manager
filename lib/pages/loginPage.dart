import 'package:assets_manager/bloc/login_bloc.dart';
import 'package:assets_manager/component/app_colors.dart';
import 'package:assets_manager/component/app_images.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/component/domain_service.dart';
import 'package:assets_manager/component/global_styles.dart';
import 'package:assets_manager/component/shared_preferences.dart';
import 'package:assets_manager/global_widget/password_custom.dart';
import 'package:assets_manager/global_widget/text_field_login.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../component/alert.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SharedPreferencesManager {
  LoginBloc? loginBloc;
  bool _showPass = false;
  String email = "";
  TextEditingController resetEmailController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  int bioType = 0;

  @override
  void initState() {
    onInit();
    super.initState();
  }

  onInit() async {
    loginBloc = LoginBloc(
      context: context,
      authenticationApi: AuthenticationServer(context),
    );

    email = await sharedPreferencesGet(SharedPreferencesKey.EMAIL);
    if (email != "null") {
      emailController.text = email;
      loginBloc?.emailChanged.add(emailController.text);
    }

    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    if (availableBiometrics.contains(BiometricType.face)) {
      setState(() {
        bioType = 1;
      });
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      // Touch ID.
      setState(() {
        bioType = 2;
      });
    }
  }

  biometricLogin() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: LoginString.LOCALIZED_REASON,
        options: const AuthenticationOptions(
            useErrorDialogs: true, biometricOnly: true, stickyAuth: true),
      );
      if (isAuthenticated) {
        final result =
            await await sharedPreferencesGet(SharedPreferencesKey.PASSWORD);
        if (result.isNotEmpty) {
          passwordController.text = result;
          loginBloc?.emailChanged.add(emailController.text);
          loginBloc?.passwordChanged.add(result);
          loginBloc?.loginOrCreateChanged.add(DomainProvider.ACT_LOGIN);
        }
      }
    } on PlatformException catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.bgAuthentication),
            fit: BoxFit.fill,
          ),
          color: AppColors.whiteBg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottomOpacity: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: GlobalStyles.paddingPageLeftRight_25,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 120,
                          child: Image.asset(AppImages.imLogo),
                        ),
                        GlobalStyles.sizedBoxHeight,
                        Text(
                          LoginString.ASSET_MANAGER_VI.toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontSize: 24,
                          ),
                        ),
                        GlobalStyles.sizedBoxHeight_30,
                        StreamBuilder(
                          stream: loginBloc?.email,
                          builder: (context, snapshot) {
                            return TextFieldLogin(
                              hintText: LoginString.HINT_TEXT_EMAIL,
                              labelText: LoginString.LABEL_TEXT_EMAIL,
                              errorText: snapshot.error != null
                                  ? snapshot.error.toString()
                                  : "",
                              onChangeFunction: loginBloc?.emailChanged.add,
                              inputAction: TextInputAction.next,
                              controller: emailController,
                            );
                          },
                        ),
                        GlobalStyles.sizedBoxHeight_10,
                        StreamBuilder(
                          stream: loginBloc?.password,
                          builder: (context, snapshot) => PasswordCustom(
                            controller: passwordController,
                            inputType: TextInputType.visiblePassword,
                            hintText: LoginString.HINT_TEXT_PASSWORD,
                            labelText: LoginString.LABEL_TEXT_PASSWORD,
                            errorText: snapshot.error != null
                                ? snapshot.error.toString()
                                : "",
                            onChangeFunction: loginBloc?.passwordChanged.add,
                          ),
                        ),
                        GlobalStyles.sizedBoxHeight_10,
                        _biometricLogin(),
                        GlobalStyles.sizedBoxHeight,
                        _buildLoginAndCreateButton(),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: TextButton(
                            child: Text(
                              LoginString.HAVE_ACCOUNT,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontStyle: FontStyle.italic,
                              ),
                              textScaleFactor: 1.0,
                            ),
                            onPressed: () {
                              Alert.showForgotPassword(context,
                                  resetEmailController: resetEmailController,
                                  loginBloc: loginBloc);
                            },
                          ),
                        ),
                        GlobalStyles.sizedBoxHeight_100,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    loginBloc?.dispose();
    super.dispose();
  }

  void onShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  Widget _buildLoginAndCreateButton() {
    return StreamBuilder(
      initialData: DomainProvider.ACT_LOGIN,
      stream: loginBloc?.loginOrCreateButton,
      builder: (context, snapshot) {
        if (snapshot.data == DomainProvider.ACT_LOGIN) {
          return _buttonLogin();
        } else
          return _buttonCreateAccount();
      },
    );
  }

  Column _buttonLogin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: loginBloc?.enableLoginCreateButton,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    backgroundColor: AppColors.mainSub),
                child: Text(
                  LoginString.LOGIN_TEXT_BUTTON,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  if (snapshot.data == true) {
                    loginBloc?.loginOrCreateChanged
                        .add(DomainProvider.ACT_LOGIN);
                  } else {
                    Alert.showError(
                        title: CommonString.ERROR,
                        message: AppString.EMPTY,
                        buttonText: CommonString.CANCEL,
                        context: context);
                  }
                },
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            loginBloc?.loginOrCreateButtonChanged
                .add(DomainProvider.CREATE_ACCOUNT);
          },
          child: Text(
            LoginString.CREATE_ACCOUNT_TEXT_BUTTON,
          ),
        )
      ],
    );
  }

  Column _buttonCreateAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        StreamBuilder(
          initialData: false,
          stream: loginBloc?.enableLoginCreateButton,
          builder: (context, snapshot) => Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                ),
                child: Text(
                  LoginString.CREATE_ACCOUNT_TEXT_BUTTON,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.red),
                ),
                onPressed: () async {
                  if (snapshot.data == true) {
                    loginBloc?.loginOrCreateChanged
                        .add(DomainProvider.CREATE_ACCOUNT);
                  } else {
                    Alert.showError(
                        title: CommonString.ERROR,
                        message: AppString.EMPTY,
                        buttonText: CommonString.CANCEL,
                        context: context);
                  }
                }),
          ),
        ),
        TextButton(
            onPressed: () {
              loginBloc?.loginOrCreateButtonChanged
                  .add(DomainProvider.ACT_LOGIN);
            },
            child: Text(LoginString.LOGIN_TEXT_BUTTON))
      ],
    );
  }

  Widget _biometricLogin() {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: bioType == 1
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => biometricLogin(),
                        child: Image.asset(
                          AppImages.icFaceId,
                          width: 25,
                          height: 25,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            LoginString.FACE_ID,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff63656A), fontSize: 18),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Alert.showForgotPassword(context,
                            resetEmailController: resetEmailController,
                            loginBloc: loginBloc);
                      },
                      child: Text(
                        LoginString.FORGOT_PASSWORD,
                        style: TextStyle(color: AppColors.gray, fontSize: 18),
                        textAlign: TextAlign.end,
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ),
                )
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => biometricLogin(),
                        child: Image.asset(
                          AppImages.icFingerPrint,
                          width: 25,
                          height: 25,
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            LoginString.FINGER_PRINT,
                            style: TextStyle(
                              color: Color(0xff63656A),
                              fontSize: 18,
                            ),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Alert.showForgotPassword(context,
                            resetEmailController: resetEmailController,
                            loginBloc: loginBloc);
                      },
                      child: Text(
                        LoginString.FORGOT_PASSWORD,
                        style: TextStyle(
                            color: AppColors.lightBlack, fontSize: 18),
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
