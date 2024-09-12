import 'package:assets_manager/bloc/department_edit_bloc.dart';
import 'package:assets_manager/bloc/department_edit_bloc_provider.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/department_widget/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:flutter/material.dart';

class DepartmentEditPage extends StatefulWidget {
  const DepartmentEditPage({Key? key, required this.flag}) : super(key: key);
  final flag;

  @override
  _DepartmentEditPageState createState() => _DepartmentEditPageState();
}

class _DepartmentEditPageState extends State<DepartmentEditPage> {
  DepartmentEditBloc? _departmentEditBloc;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  String errorMessage = "";
  List<String?> validateGroup = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _departmentEditBloc =
        DepartmentEditBlocProvider.of(context)?.departmentEditBloc;
  }

  void _addOrUpdateDepartment() {
    _departmentEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneController = MaskedTextController(mask: '0000 000 000');
  }

  resetError() {
    if (errorMessage.isNotEmpty) {
      setState(() {
        errorMessage = "";
      });
    }
  }

  onSave() {
    resetError();
    validateGroup = [
      Validators().empty(_codeController.text, DepartmentString.REQUIRE_CODE),
      Validators().empty(_nameController.text, DepartmentString.REQUIRE_NAME),
      Validators().tel(
        _phoneController.text,
        {
          'EMPTY_TEL': DepartmentString.REQUIRE_PHONE,
          'VALID_TEL': DepartmentString.REQUIRE_PHONE_VALID,
        },
      ),
      Validators()
          .empty(_addressController.text, AssetString.REQUIRE_DEPARTMENT_NAME),
    ];
    this.errorMessage = Validators().validateForm(validateGroup)!;

    if (this.errorMessage == "") {
      _departmentEditBloc?.saveEditChanged.add('Save');
      Alert.showResponse(
              successMessage: widget.flag
                  ? DepartmentString.SUCCESS_MASSAGE
                  : DepartmentString.UPDATE_SUCCESS_MASSAGE,
              errorMessage: widget.flag
                  ? DepartmentString.ERROR_MASSAGE
                  : DepartmentString.UPDATE_ERROR_MASSAGE,
              context: context,
              streamBuilder: _departmentEditBloc?.responseAddEdit,
              sink: _departmentEditBloc?.responseAddEditChanged)
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
          title: DepartmentString.EDIT_TITLE,
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
                      children: <Widget>[
                        CodeWidget(
                            stream: _departmentEditBloc?.codeEdit,
                            sink: _departmentEditBloc?.codeEditChanged,
                            codeController: _codeController),
                        GlobalStyles.sizedBoxHeight,
                        NameDepartment(
                            stream: _departmentEditBloc?.nameEdit,
                            sink: _departmentEditBloc?.nameEditChanged,
                            nameController: _nameController),
                        PhoneWidget(
                            stream: _departmentEditBloc?.phoneEdit,
                            sink: _departmentEditBloc?.phoneEditChanged,
                            phoneController: _phoneController),
                        GlobalStyles.sizedBoxHeight,
                        AddressWidget(
                            stream: _departmentEditBloc?.addressEdit,
                            sink: _departmentEditBloc?.addressEditChanged,
                            controller: _addressController),
                      ],
                    ),
                  ),
                ),
              );
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
