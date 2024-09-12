import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/global_widget/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../component/index.dart';

class ProducingCountry extends StatelessWidget {
  ProducingCountry({
    super.key,
    this.assetsEditBloc,
    required this.producingCountryController,
  });

  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController producingCountryController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: assetsEditBloc?.producingCountryEdit,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        producingCountryController.value =
            producingCountryController.value.copyWith(text: snapshot.data);
        return CustomTextFromField(
          controller: producingCountryController,
          textCapitalization: TextCapitalization.words,
          labelText: AssetString.PRODUCING_COUNTRY,
          prefixIcon: Icons.assignment_outlined,
          onChangeFunction: (producingCountry) =>
              assetsEditBloc?.producingCountryEditChanged.add(producingCountry),
        );
      },
    );
  }
}
