import 'package:assets_manager/component/index.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class SelectUserTime extends StatefulWidget {
  SelectUserTime({
    Key? key,
    required this.onChangedFunction,
    required this.selectItem,
  }) : super(key: key);
  final onChangedFunction;
  String selectItem;

  @override
  State<SelectUserTime> createState() => _SelectUserTimeState(
      onChangedFunction: onChangedFunction, selectItem: selectItem);
}

class _SelectUserTimeState extends State<SelectUserTime> {
  final keyUserTime = GlobalKey<DropdownSearchState<String>>();
  String selectItem;
  List<String> listItem = <String>[
    '12',
    '24',
    '36',
    '48',
    '60',
    '72',
    '84',
    '96',
    '108',
    '120',
    '132',
    '144',
    '156',
    '168',
    '180',
    '192',
    '204',
    '216',
    '228',
    '240',
  ];

  final onChangedFunction;

  _SelectUserTimeState(
      {required this.onChangedFunction, required this.selectItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      child: DropdownSearch<String>(
        key: keyUserTime,
        items: listItem,
        dropdownBuilder: (context, item) {
          return Text(
            item ?? "",
            style: GlobalStyles.textStyleTextFormField,
          );
        },
        dropdownButtonProps:
            DropdownButtonProps(icon: GlobalStyles.iconArrowDropDown),
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            contentPadding: EdgeInsets.fromLTRB(10, 5, 0, 5),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        compareFn: (i1, i2) => i1 == i2,
        popupProps: PopupPropsMultiSelection.dialog(
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              AssetString.USER_TIME,
              style: GlobalStyles.textStyleLabelTextFormField,
            ),
          ),
          showSelectedItems: true,
          itemBuilder: _customPopupItemBuilder,
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
              style: GlobalStyles.textStyleTextFormField,
              decoration: InputDecoration(
                label: Text(
                  AssetString.NUMBER_USER_TIME,
                  style: GlobalStyles.textStyleLabelTextFormField,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gray),
                    borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.main),
                    borderRadius: BorderRadius.circular(8)),
              )),
        ),
        selectedItem: selectItem != "" ? selectItem : listItem.first,
        onChanged: onChangedFunction,
      ),
    );
  }

  Widget _customPopupItemBuilder(
    BuildContext context,
    String item,
    bool isSelected,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: Column(
        children: [
          ListTile(
            selected: isSelected,
            title: Text(
              item,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () => keyUserTime.currentState?.popupValidate([item]),
          ),
          !isSelected
              ? Divider(
                  thickness: 2,
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
