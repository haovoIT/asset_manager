import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/bloc/assets_edit_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/appbar_custom.dart';
import 'package:assets_manager/global_widget/button_custom.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/pages/depreciation_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LiquidationConfirmationPage extends StatefulWidget {
  final AssetsModel assetModel;
  LiquidationConfirmationPage({Key? key, required this.assetModel})
      : super(key: key);

  @override
  _LiquidationConfirmationPageState createState() =>
      _LiquidationConfirmationPageState();
}

class _LiquidationConfirmationPageState
    extends State<LiquidationConfirmationPage> {
  AssetsEditBloc? _assetsEditBloc;

  String tenTS = "";
  String maPb = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _assetsEditBloc = AssetsEditBlocProvider.of(context)?.assetsEditBloc;
  }

  void _addOrUpdateAssets() {
    _assetsEditBloc?.saveEditChanged.add('Save');
    Navigator.pop(context);
  }

  onSave() {
    _assetsEditBloc?.statusEditChanged.add("Đã Thanh Lý");
    _addOrUpdateAssets();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Depreciation(
                  idAsset: widget.assetModel.documentID ?? "",
                  flag: 1,
                )));

    /*_addorEditThanhLy(
                              add: true,
                              thanhLy: ThanhLy(
                                  documentID: maQR,
                                  Ten_ts: tenTS,
                                  Ma_pb: maPb,
                                  Don_vi_TL: '',
                                  Nguyen_gia_TL: '',
                                  Ngay_TL: ''));*/
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
          minimum: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _titleDetailLeftRight(
                    AssetString.INFO_NAME_ASSETS, widget.assetModel.nameAsset),
                _titleDetailLeftRight(AssetString.INFO_DEPARTMENT,
                    widget.assetModel.departmentName),
                _titleDetailLeftRight(
                    AssetString.INFO_YEAR_OF_MANUFACTURE,
                    widget.assetModel.yearOfManufacture != null &&
                            widget.assetModel.yearOfManufacture?.isNotEmpty ==
                                true
                        ? DateFormat("dd/ MM/ yyyy")
                            .format(DateTime.parse(
                                widget.assetModel.yearOfManufacture!))
                            .toString()
                        : ""),
                _titleDetailLeftRight(AssetString.INFO_PRODUCING_COUNTRY,
                    widget.assetModel.producingCountry),
                _titleDetailLeftRight(AssetString.INFO_ASSET_GROUP,
                    widget.assetModel.assetGroupName),
                _titleDetailLeftRight(AssetString.INFO_ORIGINAL_PRICE,
                    widget.assetModel.originalPrice),
                _titleDetailLeftRight(
                    AssetString.INFO_USER_TIME, widget.assetModel.usedTime),
                _titleDetailLeftRight(
                    AssetString.INFO_START_DATE,
                    widget.assetModel.starDate != null &&
                            widget.assetModel.starDate?.isNotEmpty == true
                        ? DateFormat("dd/ MM/ yyyy")
                            .format(DateTime.parse(widget.assetModel.starDate!))
                            .toString()
                        : ""),
                _titleDetailLeftRight(
                    AssetString.INFO_END_DATE,
                    widget.assetModel.endDate != null &&
                            widget.assetModel.endDate?.isNotEmpty == true
                        ? DateFormat("dd/ MM/ yyyy")
                            .format(DateTime.parse(widget.assetModel.endDate!))
                            .toString()
                        : ""),
                _titleDetailLeftRight(
                    AssetString.INFO_AMOUNT, widget.assetModel.amount),
                _titleDetailLeftRight(AssetString.INFO_CONTRACT_NAME,
                    widget.assetModel.contractName),
                _titleDetailLeftRight(
                    AssetString.INFO_STATUS, widget.assetModel.status),
                _titleDetailLeftRight(AssetString.INFO_PURPOSE_OF_USING,
                    widget.assetModel.purposeOfUsing), //Save
              ],
            ),
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
                textHint: CommonString.CONTINUE,
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

  Widget _titleDetailLeftRight(_title, _value) {
    final TextEditingController controller = new TextEditingController();
    controller.value = controller.value.copyWith(text: _value);
    return Padding(
        padding: GlobalStyles.paddingPageTopBottom,
        child: CustomTextFromField(
          inputType: TextInputType.text,
          inputAction: TextInputAction.done,
          controller: controller,
          labelText: _title,
          prefixIcon: Icons.assignment_outlined,
          readOnly: true,
        ));
  }
}
