import 'package:assets_manager/bloc/assets_edit_bloc.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/pages/contract_list_page.dart';
import 'package:flutter/material.dart';

class ChooseContractName extends StatelessWidget {
  const ChooseContractName(
      {Key? key,
      required this.assetsEditBloc,
      required this.contractNameController})
      : super(key: key);

  final AssetsEditBloc? assetsEditBloc;
  final TextEditingController contractNameController;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final String? contractName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContractList(),
          ),
        );
        if (contractName != null && contractName.isNotEmpty == true) {
          assetsEditBloc?.contractNameEditChanged.add(contractName ?? "");
        }
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Color(0xffCED0D2)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: StreamBuilder(
          stream: assetsEditBloc?.contractNameEdit,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            contractNameController.value =
                contractNameController.value.copyWith(text: snapshot.data);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GlobalStyles.sizedBoxWidth,
                    Icon(
                      Icons.assignment_outlined,
                      color: Colors.black54,
                      size: 20,
                    ),
                    GlobalStyles.sizedBoxWidth,
                    Text(AssetString.CHOOSE_CONTRACT_NAME,
                        style: GlobalStyles.textStyleLabelTextFormField),
                    GlobalStyles.iconArrowDropDown,
                  ],
                ),
                Text(contractNameController.text.toString(),
                    style: GlobalStyles.textStyleTextFormField)
              ],
            );
          },
        ),
      ),
    );
  }
}
