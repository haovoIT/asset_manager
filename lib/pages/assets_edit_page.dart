import 'package:assets_manager/bloc/bloc_index.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:assets_manager/classes/money_format.dart';
import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:assets_manager/pages/department_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';

import '../global_widget/asset_widget/index.dart';

class AssetEditPage extends StatefulWidget {
  final bool flag;
  const AssetEditPage({Key? key, required this.flag}) : super(key: key);

  @override
  _AssetEditPageState createState() => _AssetEditPageState();
}

class _AssetEditPageState extends State<AssetEditPage> {
  AssetsEditBloc? _assetsEditBloc;
  TextEditingController _nameAssetController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _departmentNameController = new TextEditingController();
  TextEditingController _producingCountryController =
      new TextEditingController();
  TextEditingController _assetGroupNameController = new TextEditingController();
  TextEditingController _statusController = new TextEditingController();
  TextEditingController _originalPriceController = new TextEditingController();
  TextEditingController _usedTimeController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _contractNameController = new TextEditingController();
  TextEditingController _purposeOfUsingController = new TextEditingController();
  TextEditingController _starDateController = new TextEditingController();
  TextEditingController _endDateController = new TextEditingController();
  String dropdownValue = '3';
  int userTimeInt = 12;
  //Kiểm tra nếu true thì tạo tài sản, nếu false thì cập nhật lại tài sản.
  bool flagStartDate = false;
  String errorMessage = "";
  List<String?> validateGroup = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _originalPriceController = MoneyMaskedTextControllers(
      thousandSeparator: '.',
      initialValue: 0,
    );
    _amountController = MaskedTextController(mask: '000');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetsEditBloc = AssetsEditBlocProvider.of(context)!.assetsEditBloc;
    if (widget.flag) {
      flagStartDate = true;
    }
  }

  onChangedFunctionUsedTime(selected) {
    _usedTimeController.text = selected;
    _assetsEditBloc?.usedTimeEditChanged.add(selected);
    setState(() {
      userTimeInt = int.parse(selected);
    });
    final endDate =
        Alert.addMonth(int.parse(selected), _starDateController.text);
    _assetsEditBloc?.endDateEditChanged.add(endDate);
  }

  resetError() {
    if (errorMessage.isNotEmpty) {
      setState(() {
        errorMessage = "";
      });
    }
  }

  onTap() async {
    final String? _departmentName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentsList(flag: true),
      ),
    );
    if (_departmentName != null && _departmentName.isNotEmpty == true) {
      _assetsEditBloc?.idDepartmentEditChanged
          .add(_departmentName.substring(0, 20));
      _assetsEditBloc?.departmentNameEditChanged
          .add(_departmentName.substring(20, _departmentName.length));
    }
  }

  onSave() {
    resetError();
    validateGroup = [
      Validators()
          .empty(_nameAssetController.text, AssetString.REQUIRE_NAME_ASSETS),
      Validators().empty(
          _departmentNameController.text, AssetString.REQUIRE_DEPARTMENT_NAME),
      Validators().empty(_producingCountryController.text,
          AssetString.REQUIRE_PRODUCING_COUNTRY),
      Validators().empty(_assetGroupNameController.text,
          AssetString.REQUIRE_CHOOSE_ASSET_GROUP_NAME),
      Validators().money(
          _originalPriceController.text, AssetString.REQUIRE_ORIGINAL_PRICE),
      Validators().empty(_amountController.text, AssetString.REQUIRE_AMOUNT),
      Validators().empty(_contractNameController.text,
          AssetString.REQUIRE_CHOOSE_CONTRACT_NAME),
      Validators().empty(_statusController.text, AssetString.REQUIRE_STATUS),
      Validators().empty(
          _purposeOfUsingController.text, AssetString.REQUIRE_PURPOSE_OF_USING),
    ];
    this.errorMessage = Validators().validateForm(validateGroup)!;

    if (this.errorMessage == "") {
      _assetsEditBloc?.depreciationEditChanged
          .add(Alert.depreciation(_originalPriceController.text, userTimeInt));
      _assetsEditBloc?.saveEditChanged.add('Save');
      Alert.showResponse(
              successMessage: widget.flag
                  ? AssetString.SUCCESS_MASSAGE
                  : AssetString.UPDATE_SUCCESS_MASSAGE,
              errorMessage: widget.flag
                  ? AssetString.ERROR_MASSAGE
                  : AssetString.UPDATE_ERROR_MASSAGE,
              context: context,
              streamBuilder: _assetsEditBloc?.responseSaveEdit,
              sink: _assetsEditBloc?.responseSaveEditChanged)
          .then((value) {
        if (value != null && value.status == 0) {
          Navigator.pop(context);
        }
      });
    } else {
      Alert.showError(
          title: CommonString.ERROR,
          message: errorMessage,
          buttonText: CommonString.OK,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCustom(
          title: AssetString.EDIT_TITLE,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                  child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: GlobalStyles.paddingPageLeftRight_15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CodeWidget(
                          stream: _assetsEditBloc?.codeEdit,
                          sink: _assetsEditBloc?.codeEditChanged,
                          codeController: _codeController),
                      GlobalStyles.sizedBoxHeight,
                      NameAssets(
                          stream: _assetsEditBloc?.nameAssetEdit,
                          sink: _assetsEditBloc?.nameAssetEditChanged,
                          nameAssetController: _nameAssetController),
                      GlobalStyles.sizedBoxHeight, //Tên TS
                      ChooseDepartmentName(
                        assetsEditBloc: _assetsEditBloc,
                        departmentNameController: _departmentNameController,
                        title: AssetString.CHOOSE_DEPARTMENT,
                        onTap: onTap,
                        isChanged: true,
                      ),
                      GlobalStyles.sizedBoxHeight,
                      ChooseYearOfManufacture(
                        assetsEditBloc: _assetsEditBloc,
                        userTime: userTimeInt,
                      ), //PhongBan
                      //NgaySX
                      GlobalStyles.sizedBoxHeight,
                      ProducingCountry(
                          assetsEditBloc: _assetsEditBloc,
                          producingCountryController:
                              _producingCountryController),
                      GlobalStyles.sizedBoxHeight, //NuocSX
                      AssetGroupName(
                        assetsEditBloc: _assetsEditBloc,
                        assetGroupNameController: _assetGroupNameController,
                      ),
                      GlobalStyles.sizedBoxHeight, //NhomTs
                      OriginalPrice(
                        stream: _assetsEditBloc?.originalPriceEdit,
                        originalPriceController: _originalPriceController,
                        readOnly: widget.flag == true ? false : true,
                        onChangeFunction: (originalPrice) => _assetsEditBloc
                            ?.originalPriceEditChanged
                            .add(Alert.getOnlyNumbers(originalPrice).toVND()),
                      ), //Nguyên Giá
                      GlobalStyles.sizedBoxHeight,
                      UsedTime(
                        usedTimeController: _usedTimeController,
                        stream: _assetsEditBloc?.usedTimeEdit,
                        userTimes: userTimeInt,
                        onChangedFunction: onChangedFunctionUsedTime,
                      ),
                      GlobalStyles.sizedBoxHeight, //TGSD
                      StartDate(
                        stream: _assetsEditBloc?.starDateEdit,
                        sinkEndDate: _assetsEditBloc?.endDateEditChanged,
                        sinkStartDate: _assetsEditBloc?.starDateEditChanged,
                        flagStartDate: flagStartDate,
                        userTime: userTimeInt,
                        startDateController: _starDateController,
                      ),
                      GlobalStyles.sizedBoxHeight, //NgayBD
                      EndDate(
                        stream: _assetsEditBloc?.endDateEdit,
                      ), //NgayKT
                      GlobalStyles.sizedBoxHeight,
                      Amount(
                        amountController: _amountController,
                        assetsEditBloc: _assetsEditBloc,
                      ), //SoLuong
                      GlobalStyles.sizedBoxHeight,
                      ChooseContractName(
                        assetsEditBloc: _assetsEditBloc,
                        contractNameController: _contractNameController,
                      ), //HopDong
                      GlobalStyles.sizedBoxHeight,
                      ChooseStatus(
                        assetsEditBloc: _assetsEditBloc,
                        statusController: _statusController,
                      ), //TinhTrang
                      GlobalStyles.sizedBoxHeight,
                      PurposeOfUsing(
                          assetsEditBloc: _assetsEditBloc,
                          purposeOfUsingController:
                              _purposeOfUsingController), //Mdsd
                    ],
                  ),
                ),
              ));
            },
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          width: double.infinity,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ButtonCustom(
                textHint: CommonString.CANCEL,
                onFunction: () => Navigator.pop(context),
                labelColor: AppColors.blacks,
                backgroundColor: AppColors.white,
                padding: GlobalStyles.paddingPageLeftRightHV_36_12,
                fontSize: 24,
              ),
              ButtonCustom(
                textHint: CommonString.SAVE,
                onFunction: () => onSave(),
                labelColor: AppColors.white,
                backgroundColor: AppColors.main,
                padding: GlobalStyles.paddingPageLeftRightHV_36_12,
                fontSize: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
