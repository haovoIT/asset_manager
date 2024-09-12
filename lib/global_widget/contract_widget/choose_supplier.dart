import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/pages/page_index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChooseSupplierName extends StatelessWidget {
  const ChooseSupplierName({
    Key? key,
    required this.controller,
    required this.sink,
    required this.stream,
  }) : super(key: key);
  final Stream<String>? stream;
  final Sink<String>? sink;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final String? _supplierName = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NhaCungCapList(),
          ),
        );
        if (_supplierName != null && _supplierName.isNotEmpty == true) {
          sink?.add(_supplierName);
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
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            controller.value = controller.value.copyWith(text: snapshot.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    GlobalStyles.sizedBoxWidth,
                    Icon(
                      FontAwesomeIcons.groupArrowsRotate,
                      color: Colors.black54,
                      size: 18.0,
                    ),
                    GlobalStyles.sizedBoxWidth,
                    Text(
                      ContractString.SUPPLIER_NAME,
                      style: GlobalStyles.textStyleLabelTextFormField,
                    ),
                    GlobalStyles.iconArrowDropDown,
                  ],
                ),
                Text(
                  controller.text.toString(),
                  style: GlobalStyles.textStyleTextFormField,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
