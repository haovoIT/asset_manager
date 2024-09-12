import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PurposeOfUsing extends StatelessWidget {
  PurposeOfUsing({
    super.key,
    required this.assetsEditBloc,
    required this.purposeOfUsingController,
  });

  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController purposeOfUsingController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: assetsEditBloc?.purposeOfUsingEdit,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        purposeOfUsingController.value =
            purposeOfUsingController.value.copyWith(text: snapshot.data);
        return CustomTextFromField(
          maxLines: 5,
          inputType: TextInputType.multiline,
          inputAction: TextInputAction.newline,
          controller: purposeOfUsingController,
          labelText: AssetString.PURPOSE_OF_USING,
          prefixIcon: Icons.assignment_outlined,
          onChangeFunction: (purposeOfUsing) =>
              assetsEditBloc?.purposeOfUsingEditChanged.add(purposeOfUsing),
        );
      },
    );
  }
}
