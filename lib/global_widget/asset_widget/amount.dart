import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class Amount extends StatelessWidget {
  const Amount({
    Key? key,
    this.assetsEditBloc,
    required this.amountController,
  }) : super(key: key);
  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController amountController;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: assetsEditBloc?.amountEdit,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        amountController.value =
            amountController.value.copyWith(text: snapshot.data);
        return CustomTextFromField(
          inputType: TextInputType.number,
          controller: amountController,
          labelText: AssetString.AMOUNT,
          prefixIcon: Icons.onetwothree,
          onChangeFunction: (amount) =>
              assetsEditBloc?.amountEditChanged.add(amount),
        );
      },
    );
  }
}
