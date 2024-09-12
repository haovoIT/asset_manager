import 'package:assets_manager/bloc/contract_edit_bloc.dart';
import 'package:assets_manager/bloc/contract_edit_bloc_provider.dart';
import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/contract_widget/index.dart';
import 'package:assets_manager/global_widget/global_widget_index.dart';
import 'package:flutter/material.dart';

class ContractEditPage extends StatefulWidget {
  const ContractEditPage({Key? key, required this.flag}) : super(key: key);
  final flag;

  @override
  _ContractEditPageState createState() => _ContractEditPageState();
}

class _ContractEditPageState extends State<ContractEditPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ContractEditBloc? _contractEditBloc;
  TextEditingController _numberContractController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _signingDateController = new TextEditingController();
  TextEditingController _expirationDateController = new TextEditingController();
  TextEditingController _nameSupplierController = new TextEditingController();
  TextEditingController _detailController = new TextEditingController();
  String errorMessage = "";
  List<String?> validateGroup = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contractEditBloc = ContractEditBlocProvider.of(context)!.contractEditBloc;
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
          title: ContractString.EDIT_TITLE,
        ),
        body: SafeArea(
          child: LayoutBuilder(
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
                          NumberContractWidget(
                              stream: _contractEditBloc?.numberContractEdit,
                              sink:
                                  _contractEditBloc?.numberContractEditChanged,
                              controller: _numberContractController),
                          GlobalStyles.sizedBoxHeight,
                          NameContract(
                              stream: _contractEditBloc?.nameEdit,
                              sink: _contractEditBloc?.nameEditChanged,
                              controller: _nameController),
                          GlobalStyles.sizedBoxHeight,
                          SigningDate(
                            stream: _contractEditBloc?.signingDateEdit,
                            sink: _contractEditBloc?.signingDateEditChanged,
                            controller: _signingDateController,
                          ),
                          GlobalStyles.sizedBoxHeight,
                          ExpirationDate(
                            stream: _contractEditBloc?.expirationDateEdit,
                            sink: _contractEditBloc?.expirationDateEditChanged,
                            controller: _expirationDateController,
                          ),
                          GlobalStyles.sizedBoxHeight,
                          ChooseSupplierName(
                            stream: _contractEditBloc?.nameSupplierEdit,
                            sink: _contractEditBloc?.nameSupplierEditChanged,
                            controller: _nameSupplierController,
                          ),
                          GlobalStyles.sizedBoxHeight,
                          DetailWidget(
                            stream: _contractEditBloc?.detailEdit,
                            sink: _contractEditBloc?.detailEditChanged,
                            controller: _detailController,
                          ),
                        ],
                      ),
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
      Validators().empty(_numberContractController.text,
          ContractString.REQUIRE_NUMBER_CONTRACT),
      Validators()
          .empty(_nameController.text, ContractString.REQUIRE_NAME_CONTRACT),
      Validators().empty(
          _signingDateController.text, ContractString.REQUIRE_SIGNING_DATE),
      Validators().empty(_expirationDateController.text,
          ContractString.REQUIRE_EXPIRATION_DATE),
      Validators().empty(
          _nameSupplierController.text, ContractString.REQUIRE_SUPPLIER_NAME),
      Validators().empty(_detailController.text, ContractString.REQUIRE_DETAIL),
    ];
    this.errorMessage = Validators().validateForm(validateGroup)!;

    if (this.errorMessage == "") {
      _contractEditBloc?.saveEditChanged.add('Save');
      Alert.showResponse(
              successMessage: widget.flag
                  ? ContractString.SUCCESS_MASSAGE
                  : ContractString.UPDATE_SUCCESS_MASSAGE,
              errorMessage: widget.flag
                  ? ContractString.ERROR_MASSAGE
                  : ContractString.UPDATE_ERROR_MASSAGE,
              context: context,
              streamBuilder: _contractEditBloc?.responseEdit,
              sink: _contractEditBloc?.responseEditChanged)
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
