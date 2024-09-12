import 'package:assets_manager/bloc/bloc_index.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/pages/department_list.dart';
import 'package:assets_manager/pages/depreciation_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../global_widget/asset_widget/index.dart';

class AssetConvertPage extends StatefulWidget {
  final bool flag;
  final AssetsModel assetsModel;
  const AssetConvertPage({
    Key? key,
    required this.flag,
    required this.assetsModel,
  }) : super(key: key);

  @override
  _AssetConvertPageState createState() => _AssetConvertPageState();
}

class _AssetConvertPageState extends State<AssetConvertPage> {
  AssetsEditBloc? _assetsEditBloc;
  HomeBloc? _homeBloc;
  TextEditingController _departmentNameController = new TextEditingController();
  TextEditingController _amountController = new TextEditingController();
  TextEditingController _amountConvertController = new TextEditingController();
  String errorMessage = "";
  List<String?> validateGroup = [];
  String _departmentName = '';
  String _idDepartment = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _departmentNameController = TextEditingController();
    _amountController = new MaskedTextController(mask: '000');
    _amountConvertController = new MaskedTextController(mask: '000');
    _amountController.value =
        _amountController.value.copyWith(text: widget.assetsModel.amount);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetsEditBloc = AssetsEditBlocProvider.of(context)!.assetsEditBloc;
  }

  resetError() {
    if (errorMessage.isNotEmpty) {
      setState(() {
        errorMessage = "";
      });
    }
  }

  onTapFull() async {
    final String _departmentName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentsList(flag: true),
      ),
    );
    _assetsEditBloc?.idDepartmentEditChanged
        .add(_departmentName.substring(0, 20));
    _assetsEditBloc?.departmentNameEditChanged
        .add(_departmentName.substring(20, _departmentName.length));
  }

  onTapAPart() async {
    final String _result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DepartmentsList(flag: true),
      ),
    );
    setState(() {
      _idDepartment = _result.substring(0, 20);
      _departmentName = _result.substring(20, _result.length);
      _departmentNameController.value =
          _departmentNameController.value.copyWith(text: _departmentName);
    });

    // _assetsEditBloc?.idDepartmentEditChanged
    //     .add(_departmentName.substring(0, 20));
    // _assetsEditBloc?.departmentNameEditChanged
    //     .add(_departmentName.substring(20, _departmentName.length));
  }

  onSave() {
    resetError();
    validateGroup = widget.flag
        ? [
            Validators().checkForNoDuplicates(_departmentNameController.text,
                widget.assetsModel.departmentName, {
              "EMPTY_VALUE_CHECK": AssetString.EMPTY_DEPARTMENT_VALUE_CHECK,
              "EMPTY_VALUE_DUPLICATE":
                  AssetString.EMPTY_DEPARTMENT_VALUE_DUPLICATE,
              "ERROR_NO_DUPLICATES": AssetString.ERROR_DEPARTMENT_NO_DUPLICATES
            }),
          ]
        : [
            Validators().checkForNoDuplicates(_departmentNameController.text,
                widget.assetsModel.departmentName, {
              "EMPTY_DEPARTMENT_VALUE_CHECK":
                  AssetString.EMPTY_DEPARTMENT_VALUE_CHECK,
              "EMPTY_DEPARTMENT_VALUE_DUPLICATE":
                  AssetString.EMPTY_DEPARTMENT_VALUE_DUPLICATE,
              "ERROR_DEPARTMENT_NO_DUPLICATES":
                  AssetString.ERROR_DEPARTMENT_NO_DUPLICATES
            }),
            Validators().checkAmount(
                _amountController.text, _amountConvertController.text, {
              "EMPTY_AMOUNT": AssetString.EMPTY_AMOUNT,
              "EMPTY_AMOUNT_CONVERT": AssetString.EMPTY_AMOUNT_CONVERT,
              "ERROR_CHECK_AMOUNT": AssetString.ERROR_CHECK_AMOUNT
            }),
          ];
    this.errorMessage = Validators().validateForm(validateGroup)!;

    if (this.errorMessage == "") {
      if (widget.flag) {
        _assetsEditBloc?.saveEditChanged.add(DomainProvider.CONVERT_ASSET_ALL);
        Alert.showResponse(
                successMessage: AssetString.CONVERT_SUCCESS_MASSAGE,
                errorMessage: AssetString.CONVERT_ERROR_MASSAGE,
                context: context,
                streamBuilder: _assetsEditBloc?.responseConvertEdit,
                sink: _assetsEditBloc?.responseConvertEditChanged)
            .then((value) {
          if (value == DomainProvider.SUCCESS) {
            _homeBloc?.deleteAssets.add(widget.assetsModel);
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Depreciation(
                          idAsset: widget.assetsModel.documentID ?? "",
                          flag: 3,
                          idDepartment: _idDepartment,
                        )));
          }
        });
      } else {
        int amount = int.parse(_amountController.text);
        int amountConvert = int.parse(_amountConvertController.text);
        int amountRemaining = amount - amountConvert;
        _assetsEditBloc?.amountEditChanged.add(amountRemaining.toString());
        _assetsEditBloc?.saveEditChanged.add('Save');
        _assetsEditBloc?.idDepartmentEditChanged.add(_idDepartment);
        _assetsEditBloc?.departmentNameEditChanged.add(_departmentName);
        _assetsEditBloc?.purposeOfUsingEditChanged.add(
            "${widget.assetsModel.purposeOfUsing}. Được chuyển đến từ Phòng ${widget.assetsModel.departmentName}");
        _assetsEditBloc?.amountEditChanged.add(amountConvert.toString());
        _assetsEditBloc?.saveEditChanged.add('Add');
        Alert.showResponse(
                successMessage: AssetString.CONVERT_SUCCESS_MASSAGE,
                errorMessage: AssetString.CONVERT_ERROR_MASSAGE,
                context: context,
                streamBuilder: _assetsEditBloc?.responseAddEdit,
                sink: _assetsEditBloc?.responseAddEditChanged)
            .then((value) {
          var response = value;
          final data = response['data'];
          final massage = response['massage'];
          if (massage == DomainProvider.SUCCESS) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Depreciation(
                  idAsset: widget.assetsModel.documentID ?? "",
                  newIdAsset: data,
                  flag: 3,
                  idDepartment: _idDepartment,
                ),
              ),
            );
          }
        });
      }
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
        title: AssetString.CONVERT_TITLE,
      ),
      body: widget.flag ? _build() : _buildAPart(),
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
    ));
  }

  Widget _build() {
    return SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GlobalStyles.sizedBoxHeight,
              ChooseDepartmentName(
                assetsEditBloc: _assetsEditBloc,
                departmentNameController: _departmentNameController,
                title: AssetString.CHOOSE_DEPARTMENT,
                onTap: onTapFull,
                isChanged: true,
              ),
            ],
          ),
        ));
  }

  Widget _buildAPart() {
    return SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GlobalStyles.sizedBoxHeight,
              _departmentWidget(),
              GlobalStyles.sizedBoxHeight,
              ChooseDepartmentName(
                assetsEditBloc: _assetsEditBloc,
                departmentNameController: _departmentNameController,
                title: AssetString.CHOOSE_FROM_DEPARTMENT,
                onTap: onTapAPart,
                isChanged: false,
              ), //Tên TS
              GlobalStyles.sizedBoxHeight,
              CustomTextFromField(
                inputType: TextInputType.number,
                controller: _amountController,
                labelText: AssetString.AMOUNT,
                prefixIcon: Icons.onetwothree,
                readOnly: true,
                fillColor: AppColors.gray,
              ), //SoLuong
              GlobalStyles.sizedBoxHeight,
              Container(
                child: Text(AssetString.QUESTION_AMOUNT_CONVERT),
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              ),
              CustomTextFromField(
                inputType: TextInputType.number,
                controller: _amountConvertController,
                labelText: AssetString.AMOUNT_CONVERT,
                prefixIcon: Icons.onetwothree,
              ),
            ],
          ),
        ));
  }

  Container _departmentWidget() {
    return Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffCED0D2)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: AppColors.gray,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: <Widget>[
                GlobalStyles.sizedBoxWidth,
                Icon(
                  FontAwesomeIcons.houseUser,
                  color: Colors.black54,
                  size: 16,
                ),
                GlobalStyles.sizedBoxWidth,
                Text(
                  AssetString.CHOOSE_TO_DEPARTMENT,
                  style: GlobalStyles.textStyleLabelTextFormField,
                ),
                GlobalStyles.iconArrowDropDown,
              ],
            ),
            Text(
              widget.assetsModel.departmentName ?? "",
              style: GlobalStyles.textStyleTextFormField,
            )
          ],
        ));
  }
}
