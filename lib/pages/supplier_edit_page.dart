import 'package:assets_manager/bloc/supplier_edit_bloc.dart';
import 'package:assets_manager/bloc/supplier_edit_bloc_provider.dart';
import 'package:assets_manager/classes/format_money.dart';
import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:assets_manager/global_widget/supplier_widget/index.dart';
import 'package:flutter/material.dart';

class SupplierEditPage extends StatefulWidget {
  const SupplierEditPage({Key? key, required this.flag}) : super(key: key);
  final flag;

  @override
  _SupplierEditPageState createState() => _SupplierEditPageState();
}

class _SupplierEditPageState extends State<SupplierEditPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SupplierEditBloc? _supplierEditBloc;
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  String errorMessage = "";
  List<String?> validateGroup = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneController = MaskedTextController(mask: '0000 000 000');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supplierEditBloc = SupplierEditBlocProvider.of(context)?.supplierEditBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBarCustom(
          title: SupplierString.EDIT_TITLE,
        ),
        body: SafeArea(child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: GlobalStyles.paddingPageLeftRight_15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        NameSupplierWidget(
                            stream: _supplierEditBloc?.nameEdit,
                            sink: _supplierEditBloc?.nameEditChanged,
                            controller: _nameController),
                        GlobalStyles.sizedBoxHeight,
                        EmailWidget(
                            stream: _supplierEditBloc?.emailEdit,
                            sink: _supplierEditBloc?.emailEditChanged,
                            controller: _emailController),
                        GlobalStyles.sizedBoxHeight,
                        PhoneWidget(
                            stream: _supplierEditBloc?.phoneEdit,
                            sink: _supplierEditBloc?.phoneEditChanged,
                            controller: _phoneController),
                        GlobalStyles.sizedBoxHeight,
                        AddressWidget(
                            stream: _supplierEditBloc?.addressEdit,
                            sink: _supplierEditBloc?.addressEditChanged,
                            controller: _addressController),
                        GlobalStyles.sizedBoxHeight,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
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
                                padding:
                                    GlobalStyles.paddingPageLeftRightHV_36_12,
                                fontSize: 24,
                              ),
                              ButtonCustom(
                                textHint: CommonString.SAVE,
                                onFunction: () => onSave(),
                                labelColor: AppColors.white,
                                backgroundColor: AppColors.main,
                                padding:
                                    GlobalStyles.paddingPageLeftRightHV_36_12,
                                fontSize: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )),
      ),
    );
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
      Validators()
          .empty(_nameController.text, SupplierString.REQUIRE_NAME_SUPPLIER),
      Validators()
          .empty(_addressController.text, SupplierString.REQUIRE_ADDRESS),
      Validators().tel(_phoneController.text, {
        "EMPTY_TEL": SupplierString.REQUIRE_PHONE,
        "VALID_TEL": SupplierString.REQUIRE_PHONE_VALID,
      }),
      Validators().email(_emailController.text, {
        "EMPTY_EMAIL": SupplierString.REQUIRE_EMAIL,
        "VALID_EMAIL": SupplierString.REQUIRE_EMAIL_VALID,
      }),
    ];
    this.errorMessage = Validators().validateForm(validateGroup)!;

    if (this.errorMessage == "") {
      _supplierEditBloc?.saveEditChanged.add('Save');
      Alert.showResponse(
              successMessage: widget.flag
                  ? SupplierString.SUCCESS_MASSAGE
                  : SupplierString.UPDATE_SUCCESS_MASSAGE,
              errorMessage: widget.flag
                  ? SupplierString.ERROR_MASSAGE
                  : SupplierString.UPDATE_ERROR_MASSAGE,
              context: context,
              streamBuilder: _supplierEditBloc?.responseEdit,
              sink: _supplierEditBloc?.responseEditChanged)
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
}
