import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/login_bloc.dart';
import 'package:assets_manager/component/app_colors.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/component/domain_service.dart';
import 'package:assets_manager/component/global_styles.dart';
import 'package:assets_manager/global_widget/text_field_login.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/model_index.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:intl/intl.dart';

class Alert {
  static Duration duration = const Duration(seconds: 2);

  static void showLoadingIndicator(
      {String? message, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (val) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: AppColors.main,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  message ?? "",
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.main,
                      decoration: TextDecoration.none),
                )
              ],
            ),
          );
        });
  }

  static void closeLoadingIndicator(context) {
    Navigator.of(context).pop();
  }

  static void showForgotPassword(
    context, {
    required TextEditingController resetEmailController,
    required LoginBloc? loginBloc,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            LoginString.FORGOT_PASSWORD,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    LoginString.CONTENT_FORGOT_PASS,
                    textAlign: TextAlign.center,
                  ),
                  GlobalStyles.sizedBoxHeight_10,
                  StreamBuilder(
                      stream: loginBloc?.emailsEdit,
                      builder: (context, snapshot) => TextFieldLogin(
                            hintText: LoginString.HINT_TEXT_EMAIL,
                            labelText: LoginString.LABEL_TEXT_EMAIL,
                            errorText: snapshot.error != null
                                ? snapshot.error.toString()
                                : "",
                            onChangeFunction: (email) =>
                                loginBloc?.emailsEditChanged.add(email),
                            inputAction: TextInputAction.done,
                          ))
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                CommonString.CANCEL,
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            StreamBuilder(
              initialData: false,
              stream: loginBloc?.forgotPasswordEdit,
              builder: (context, snapshot) => Container(
                width: 100,
                height: 60,
                child: ElevatedButton(
                  child: Text(
                    CommonString.CONTINUE,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    loginBloc?.forgotPasswordEditChanged
                        .add(DomainProvider.RESET);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static Future<dynamic> showSuccess(
      {required String title,
      String? message,
      required String buttonText,
      required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message ?? ""),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(buttonText),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  static Future<dynamic> showError({
    required String title,
    required String message,
    required String buttonText,
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(buttonText),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void confirmLogout(context,
      {required AuthenticationBloc? authenticationBloc}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppString.LOGOUT,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(AppString.CONTENT_LOGOUT),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(CommonString.CANCEL)),
              TextButton(
                  onPressed: () {
                    authenticationBloc?.logoutUser.add(true);
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    CommonString.CONTINUE,
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  static Future<String> selectDatetime(
    context, {
    required selectedDate,
    maxTime,
    minTime,
  }) async {
    DateTime _initialDate = DateTime.parse(selectedDate);
    final DateTime? _pickedDate = await DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: minTime ?? DateTime(2013, 1, 1),
      maxTime: maxTime ?? DateTime.now(),
      theme: DatePickerTheme(
          headerColor: Colors.blue,
          itemStyle: TextStyle(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
          doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
      currentTime: _initialDate,
      locale: LocaleType.vi,
    );

    if (_pickedDate != null) {
      selectedDate = DateTime(
              _pickedDate.year,
              _pickedDate.month,
              _pickedDate.day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second,
              DateTime.now().millisecond,
              DateTime.now().microsecond)
          .toString();
    }
    return selectedDate;
  }

  static String getOnlyNumbers(String text) {
    String cleanedText = text;
    var onlyNumbersRegex = new RegExp(r'\D');
    cleanedText = cleanedText.replaceAll(onlyNumbersRegex, '');
    return cleanedText;
  }

  static Future<String> selectDatetimeStartDate(context,
      {required DateTime selectedDate, required DateTime minTime}) async {
    DateTime _initialDate = selectedDate;
    final DateTime? _pickedDate = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: minTime,
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            headerColor: Colors.blue,
            itemStyle: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
            doneStyle: TextStyle(color: Colors.white, fontSize: 16)),
        currentTime: _initialDate,
        locale: LocaleType.vi);

    if (_pickedDate != null) {
      selectedDate = DateTime(
          _pickedDate.year,
          _pickedDate.month,
          _pickedDate.day,
          DateTime.now().hour,
          DateTime.now().minute,
          DateTime.now().second,
          DateTime.now().millisecond,
          DateTime.now().microsecond);
    }
    return selectedDate.toString();
  }

  static String addMonth(int userTime, String startDate) {
    DateTime ngayBD = DateTime.parse(startDate);
    String selectedDate;
    double index = userTime / 12;
    selectedDate = DateTime(
            ngayBD.year + index.toInt(),
            ngayBD.month,
            ngayBD.day,
            ngayBD.hour,
            ngayBD.minute,
            ngayBD.second,
            ngayBD.millisecond,
            ngayBD.microsecond)
        .toString();
    return selectedDate;
  }

  static double onChangeDepreciation({
    required userTimeInt,
    required numberMonths,
    required originalPrice,
    required accumulatedDouble,
  }) {
    double depreciationDouble = 0.0;
    double residualDouble = 0.0;
    int residualMonthInt = 0;
    residualDouble =
        double.parse(Alert.getOnlyNumbers(originalPrice)) - accumulatedDouble;
    residualMonthInt = userTimeInt - numberMonths;
    depreciationDouble = residualDouble / residualMonthInt;
    return depreciationDouble;
  }

  static Future<String?> selectStatus(context) async {
    String? results;
    await Picker(
        height: 220,
        itemExtent: 50,
        textStyle: GlobalStyles.textStyleTextFormField,
        adapter: PickerDataAdapter<String>(pickerData: AssetString.LIST_STATUS),
        changeToFirst: true,
        hideHeader: false,
        cancelText: CommonString.CANCEL,
        confirmText: CommonString.CONTINUE,
        cancelTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        confirmTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        title: Text(
          AssetString.CHOOSE_STATUS,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        headerColor: AppColors.accentBlue,
        selectedTextStyle:
            TextStyle(color: AppColors.greenLight, fontWeight: FontWeight.bold),
        onConfirm: (picker, value) {
          results = picker.adapter.text;
        }).showModal(context);
    return results;
  }

  static Future<String?> selectDetail(context) async {
    String? results;
    await Picker(
        height: 220,
        itemExtent: 50,
        textStyle: GlobalStyles.textStyleTextFormField,
        adapter: PickerDataAdapter<String>(pickerData: AssetString.LIST_DETAIL),
        changeToFirst: true,
        hideHeader: false,
        cancelText: CommonString.CANCEL,
        confirmText: CommonString.CONTINUE,
        cancelTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        confirmTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
        title: Text(
          AssetString.CHOOSE_DETAIL,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        headerColor: AppColors.accentBlue,
        selectedTextStyle:
            TextStyle(color: AppColors.greenLight, fontWeight: FontWeight.bold),
        onConfirm: (picker, value) {
          results = picker.adapter.text;
        }).showModal(context);
    return results;
  }

  static Future<dynamic> showResponse({
    required String successMessage,
    required String errorMessage,
    required BuildContext context,
    required Stream<BaseResponse>? streamBuilder,
    required Sink<BaseResponse>? sink,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => StreamBuilder(
        stream: streamBuilder,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final data = snapshot.data;
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (data.status == 0) {
            return CupertinoAlertDialog(
              title: Text(CommonString.SUCCESS),
              content: Text(successMessage),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(CommonString.OK),
                  onPressed: () {
                    Navigator.of(context).pop(data);
                  },
                )
              ],
            );
          } else if (data.status == 1) {
            return CupertinoAlertDialog(
              title: Text(CommonString.ERROR),
              content: Text(data.message),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text(CommonString.OK),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
          return CupertinoAlertDialog(
            title: Text(CommonString.ERROR),
            content: Text(CommonString.ERROR_MESSAGE),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(CommonString.OK),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  static String getOnlyCharacters(String text) {
    String cleanedText = text;
    cleanedText = cleanedText.replaceAll('[', '');
    cleanedText = cleanedText.replaceAll(']', '');
    return cleanedText;
  }

  static String depreciation(String originalPrice, int usedTime) {
    int submit;
    submit = int.parse(Alert.getOnlyNumbers(originalPrice)) ~/ usedTime;
    return submit.toVND();
  }

  static Future<dynamic> showConfirm(
    context, {
    required String title,
    required String detail,
    required String btTextTrue,
    required String btTextFalse,
    bool? isClose,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: Text(
              detail,
              style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(btTextFalse),
                onPressed: () => Navigator.pop(context, false),
              ),
              CupertinoDialogAction(
                child: Text(btTextTrue),
                onPressed: () => Navigator.pop(context, true),
              ),
              isClose != null && isClose == true
                  ? CupertinoDialogAction(
                      child: Text(CommonString.CANCEL),
                      onPressed: () => Navigator.pop(context),
                    )
                  : SizedBox(),
            ],
          );
        });
  }

  static Future<dynamic> showInfoAsset(
      {required String title,
      required AssetsModel assetsModel,
      required BuildContext context}) {
    Widget _textSubTitle(_titleDetail, _subtitleDetail) {
      return Row(
        children: [
          Expanded(
            child: Text(
              _titleDetail,
              style: TextStyle(fontSize: 16, color: AppColors.black),
            ),
          ),
          Expanded(
            child: Text(
              _subtitleDetail ?? "",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      );
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Thẻ Tài Sản Chi Tiết',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
          ),
          content: SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BarcodeWidget(
                    data: assetsModel.qrCode ?? "",
                    barcode: Barcode.qrCode(),
                    width: 200,
                    height: 200,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.only(left: 40.0),
                  ),
                  Divider(
                    color: Colors.green,
                  ),
                  _textSubTitle(
                      AssetString.INFO_NAME_ASSETS, assetsModel.nameAsset),
                  GlobalStyles.divider,
                  _textSubTitle(
                      AssetString.INFO_DEPARTMENT, assetsModel.departmentName),
                  GlobalStyles.divider,
                  _textSubTitle(
                      AssetString.INFO_YEAR_OF_MANUFACTURE,
                      assetsModel.yearOfManufacture != "" &&
                              assetsModel.yearOfManufacture?.isNotEmpty == true
                          ? DateFormat("dd/ MM/ yyyy").format(
                              DateTime.parse(assetsModel.yearOfManufacture!))
                          : ""),
                  GlobalStyles.divider,
                  _textSubTitle(AssetString.INFO_PRODUCING_COUNTRY,
                      assetsModel.producingCountry),
                  GlobalStyles.divider,
                  _textSubTitle(
                      AssetString.INFO_ASSET_GROUP, assetsModel.assetGroupName),
                  GlobalStyles.divider,
                  _textSubTitle(
                      AssetString.INFO_CONTRACT_NAME, assetsModel.contractName),
                  GlobalStyles.divider,
                  _textSubTitle(AssetString.INFO_ORIGINAL_PRICE,
                      assetsModel.originalPrice),
                  GlobalStyles.divider,
                  _textSubTitle(AssetString.INFO_STATUS, assetsModel.status),
                  GlobalStyles.divider,
                  _textSubTitle(
                      AssetString.INFO_USER_TIME, assetsModel.usedTime),
                  GlobalStyles.divider,
                  _textSubTitle(AssetString.INFO_AMOUNT, assetsModel.amount),
                  GlobalStyles.divider,
                  _textSubTitle(AssetString.INFO_PURPOSE_OF_USING,
                      assetsModel.purposeOfUsing),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(CommonString.CANCEL),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //
  // static Future<dynamic> selectFile() async {
  //   return showDialog(
  //     context: Get.context!,
  //     builder: (_) => Dialog(
  //       insetPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
  //       child: Builder(
  //         builder: (context) {
  //           var width = MediaQuery.of(context).size.width;
  //
  //           return Container(
  //             width: width,
  //             margin: EdgeInsets.symmetric(vertical: 15),
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 15),
  //                   child: Text(
  //                     FlutterI18n.translate(context, "COMMON.uploadFile"),
  //                     style:
  //                         TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: width,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(top: 15),
  //                     child: TextButton(
  //                         style: ButtonStyle(
  //                             alignment: Alignment.centerLeft,
  //                             overlayColor: MaterialStateProperty.all(
  //                                 AppColors.gray.withOpacity(0.2)),
  //                             padding: MaterialStateProperty.all<EdgeInsets>(
  //                                 EdgeInsets.symmetric(horizontal: 15))),
  //                         onPressed: () => Get.back(result: "image"),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 12),
  //                           child: Text(
  //                             FlutterI18n.translate(context, "COMMON.image"),
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w400),
  //                           ),
  //                         )),
  //                   ),
  //                 ),
  //                 Container(
  //                   width: width,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(bottom: 15),
  //                     child: TextButton(
  //                         style: ButtonStyle(
  //                             alignment: Alignment.centerLeft,
  //                             overlayColor: MaterialStateProperty.all(
  //                                 AppColors.gray.withOpacity(0.2)),
  //                             padding: MaterialStateProperty.all<EdgeInsets>(
  //                                 EdgeInsets.symmetric(horizontal: 15))),
  //                         onPressed: () => Get.back(result: "pdf"),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 12),
  //                           child: Text(
  //                             FlutterI18n.translate(context, "COMMON.pdf"),
  //                             style: TextStyle(
  //                                 fontSize: 16,
  //                                 color: Colors.black,
  //                                 fontWeight: FontWeight.w400),
  //                           ),
  //                         )),
  //                   ),
  //                 ),
  //                 Align(
  //                   alignment: Alignment.centerRight,
  //                   child: Padding(
  //                     padding: EdgeInsets.only(right: 15),
  //                     child: TextButton(
  //                         style: ButtonStyle(
  //                             alignment: Alignment.bottomRight,
  //                             overlayColor: MaterialStateProperty.all(
  //                                 AppColors.gray.withOpacity(0.2)),
  //                             padding: MaterialStateProperty.all<EdgeInsets>(
  //                                 EdgeInsets.symmetric(horizontal: 15))),
  //                         onPressed: () => Get.back(),
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 12),
  //                           child: Text(
  //                             FlutterI18n.translate(context, "COMMON.cancel"),
  //                             style: TextStyle(
  //                                 fontSize: 17, fontWeight: FontWeight.w400),
  //                           ),
  //                         )),
  //                   ),
  //                 )
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
  //
  // static Future<dynamic> showConfirmDialog({detail}) {
  //   return showDialog(
  //     context: Get.context!,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Text(FlutterI18n.translate(context, "COMMON.confirm")),
  //       content: Text(detail ?? ""),
  //       actions: <Widget>[
  //         CupertinoDialogAction(
  //           child: Text(FlutterI18n.translate(context, "COMMON.ok")),
  //           onPressed: () => Get.back(result: true),
  //         ),
  //         CupertinoDialogAction(
  //           child: Text(FlutterI18n.translate(context, "COMMON.cancel")),
  //           onPressed: () => Get.back(result: false),
  //         )
  //       ],
  //     ),
  //     barrierDismissible: false,
  //   );
  // }
  //
  // static Future<dynamic> showSelectImage() {
  //   /* -- 1 for camera
  //      -- 2 for photo
  //    */
  //   return Get.bottomSheet(
  //     SafeArea(
  //         child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Container(
  //           margin: EdgeInsets.symmetric(horizontal: 5),
  //           decoration: BoxDecoration(
  //               color: Color(0xffF1F1F1),
  //               borderRadius: BorderRadius.circular(15)),
  //           child: CupertinoActionSheet(
  //               title: Column(
  //                 children: [
  //                   Text(
  //                     FlutterI18n.translate(
  //                         Get.context!, "addRequest.attachments"),
  //                     style: TextStyle(fontWeight: FontWeight.bold),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(top: 10),
  //                     child: Text(FlutterI18n.translate(
  //                         Get.context!, "addRequest.typeFile")),
  //                   ),
  //                 ],
  //               ),
  //               actions: [
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 6),
  //                   child: CupertinoDialogAction(
  //                     child: Text(
  //                       FlutterI18n.translate(Get.context!, "addRequest.image"),
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w600, fontSize: 18),
  //                     ),
  //                     onPressed: () => Get.back(result: "image"),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 1),
  //                   child: CupertinoDialogAction(
  //                     child: Text(
  //                       FlutterI18n.translate(
  //                           Get.context!, "addRequest.document"),
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.w500, fontSize: 18),
  //                     ),
  //                     onPressed: () => Get.back(result: "document"),
  //                   ),
  //                 ),
  //               ]),
  //         ),
  //         Container(
  //           margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
  //           height: 60,
  //           decoration: BoxDecoration(
  //               color: Color(0xffF1F1F1),
  //               borderRadius: BorderRadius.circular(14)),
  //           child: CupertinoActionSheet(actions: [
  //             CupertinoDialogAction(
  //               child: Center(
  //                 child: Text(
  //                   FlutterI18n.translate(Get.context!, "addRequest.cancel"),
  //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //                 ),
  //               ),
  //               onPressed: () => Get.back(),
  //             ),
  //           ]),
  //         )
  //       ],
  //     )),
  //     isScrollControlled: true,
  //   );
  // }
  //
  // static Future<dynamic> showImageModal(
  //     {required String appbarTitle,
  //     required List<dynamic>? imageList,
  //     required int index}) {
  //   return Get.generalDialog(
  //     barrierColor: Colors.white,
  //     barrierDismissible: false,
  //     pageBuilder: (_, __, ___) {
  //       return SizedBox.expand(
  //         child: Scaffold(
  //             appBar: AppBar(
  //               backgroundColor: Colors.transparent,
  //               centerTitle: true,
  //               elevation: 0,
  //               leading: IconButton(
  //                 icon: Icon(
  //                   Icons.arrow_back_outlined,
  //                   size: 20,
  //                   color: AppColors.main,
  //                 ),
  //                 onPressed: () => Get.back(),
  //               ),
  //               title: Text(
  //                 appbarTitle,
  //                 style: TextStyle(
  //                   color: AppColors.main,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               automaticallyImplyLeading: false,
  //             ),
  //             body: PageView.builder(
  //                 itemCount: imageList!.length,
  //                 controller: PageController(initialPage: index),
  //                 itemBuilder: (context, index) {
  //                   return Stack(
  //                     alignment: Alignment.topRight,
  //                     children: [
  //                       PhotoView(
  //                         imageProvider: NetworkImage(
  //                             "${dotenv.env['APIURL']}" + imageList[index]!),
  //                         backgroundDecoration: BoxDecoration(
  //                           color: Colors.white,
  //                         ),
  //                       ),
  //                       IconButton(
  //                         icon: CircleAvatar(
  //                           backgroundColor: AppColors.gray.withOpacity(0.4),
  //                           radius: 20,
  //                           child: Icon(
  //                             Icons.download_sharp,
  //                             size: 20,
  //                             color: AppColors.main,
  //                           ),
  //                         ),
  //                         onPressed: () async {
  //                           String url =
  //                               "${dotenv.env['APIURL']}" + imageList[index];
  //                           var response = await Dio().get(url,
  //                               options:
  //                                   Options(responseType: ResponseType.bytes));
  //                           final result = await ImageGallerySaver.saveImage(
  //                               Uint8List.fromList(response.data),
  //                               quality: 60,
  //                               name: "Giaic_connect_" +
  //                                   DateTime.now().toString());
  //                           if (result["errorMessage"] != "null") {
  //                             Get.snackbar(
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.success"),
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.successDownload"),
  //                               backgroundColor: Colors.white,
  //                               titleText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.success"),
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 16,
  //                                     color: AppColors.main),
  //                               ),
  //                               messageText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.successDownload"),
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   color: AppColors.main,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               duration: const Duration(seconds: 2),
  //                               icon: SvgPicture.asset(
  //                                 AppImages.icLogo,
  //                                 fit: BoxFit.fill,
  //                                 height: 45,
  //                                 width: 45,
  //                               ),
  //                               borderRadius: 20.0,
  //                               borderColor: AppColors.main,
  //                               borderWidth: 1,
  //                             );
  //                           } else {
  //                             Get.snackbar(
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.error"),
  //                               FlutterI18n.translate(
  //                                   Get.context!, "COMMON.failedDownload"),
  //                               backgroundColor: Colors.white,
  //                               titleText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.error"),
  //                                 style: TextStyle(
  //                                     fontWeight: FontWeight.bold,
  //                                     fontSize: 16,
  //                                     color: AppColors.red),
  //                               ),
  //                               messageText: Text(
  //                                 FlutterI18n.translate(
  //                                     Get.context!, "COMMON.failedDownload"),
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   color: AppColors.main,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                               duration: const Duration(seconds: 2),
  //                               icon: SvgPicture.asset(
  //                                 AppImages.icLogo,
  //                                 fit: BoxFit.fill,
  //                                 height: 45,
  //                                 width: 45,
  //                               ),
  //                               borderRadius: 20.0,
  //                               borderColor: AppColors.main,
  //                               borderWidth: 1,
  //                             );
  //                           }
  //                         },
  //                       ),
  //                     ],
  //                   );
  //                 })),
  //       );
  //     },
  //   );
  // }
  //
  // static Future<dynamic> showQuestionDeleteAccount({
  //   String? message,
  //   String? textConfirm,
  //   String? yesButton,
  //   String? cancelButton,
  //   Function()? functionYes,
  // }) {
  //   return showDialog(
  //     context: Get.context!,
  //     barrierDismissible: false,
  //     builder: (context) => AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Text(
  //             message ?? "",
  //             textAlign: TextAlign.center,
  //             style: TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //                 color: AppColors.main),
  //           ),
  //           SizedBox(
  //             height: 15,
  //           ),
  //           Text(
  //             textConfirm ?? "",
  //             textAlign: TextAlign.left,
  //             style: TextStyle(fontSize: 18),
  //           ),
  //         ],
  //       ),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
  //       actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(Radius.circular(10))),
  //       actions: <Widget>[
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             TextButton(
  //                 onPressed: () => Get.back(),
  //                 child: Text(
  //                   cancelButton ?? "",
  //                   style: TextStyle(color: Colors.black),
  //                 ),
  //                 style: TextButton.styleFrom(
  //                     primary: AppColors.gray,
  //                     shape: RoundedRectangleBorder(
  //                         side: BorderSide(
  //                           width: 0.5,
  //                           color: Color(0xff333333),
  //                         ),
  //                         borderRadius: BorderRadius.circular(10)))),
  //             TextButton(
  //                 onPressed: functionYes ?? () => Get.back(result: true),
  //                 child: Text(yesButton ?? ""),
  //                 style: TextButton.styleFrom(
  //                   primary: Colors.white,
  //                   backgroundColor: AppColors.main,
  //                   shape: RoundedRectangleBorder(
  //                       side: BorderSide(width: 1, color: AppColors.main),
  //                       borderRadius: BorderRadius.circular(10)),
  //                 )),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
  //
  // static Future<dynamic> showImageModalFile(
  //     {required String appbarTitle,
  //     required List<dynamic>? imageList,
  //     required int index}) {
  //   return Get.generalDialog(
  //     barrierColor: Colors.white,
  //     barrierDismissible: false,
  //     pageBuilder: (_, __, ___) {
  //       return SizedBox.expand(
  //         child: Scaffold(
  //             appBar: AppBar(
  //               backgroundColor: Colors.transparent,
  //               centerTitle: true,
  //               elevation: 0,
  //               leading: IconButton(
  //                 icon: Icon(
  //                   Icons.arrow_back_outlined,
  //                   size: 20,
  //                   color: AppColors.main,
  //                 ),
  //                 onPressed: () => Get.back(),
  //               ),
  //               title: Text(
  //                 appbarTitle,
  //                 style: TextStyle(
  //                   color: AppColors.main,
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               automaticallyImplyLeading: false,
  //             ),
  //             body: PageView.builder(
  //                 itemCount: imageList!.length,
  //                 controller: PageController(initialPage: index),
  //                 itemBuilder: (context, index) {
  //                   return PhotoView(
  //                     imageProvider: FileImage(imageList[index]),
  //                   );
  //                 })),
  //       );
  //     },
  //   );
  // }
}
