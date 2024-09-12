import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/contract_bloc.dart';
import 'package:assets_manager/bloc/contract_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/contract_model.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_contract.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationServer =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationServer);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ContractBlocProvider(
                contractBloc:
                    ContractBloc(DbContractService(), _authenticationServer),
                uid: snapshot.data!,
                child: ContractLists());
          } else {
            return Center(
              child: Container(
                child: Text(ContractString.ADD_CONTRACT),
              ),
            );
          }
        },
      ),
    );
  }
}

class ContractLists extends StatefulWidget {
  const ContractLists({Key? key}) : super(key: key);

  @override
  _ContractListsState createState() => _ContractListsState();
}

class _ContractListsState extends State<ContractLists> {
  ContractBloc? _contractBloc;
  TextEditingController tenController = new TextEditingController();
  String tenHD = "";
  bool flag = true;
  List<Contract> listContract = [];
  List<Contract> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contractBloc = ContractBlocProvider.of(context)!.contractBloc;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tenController.addListener(() {
      setState(() {
        tenHD = tenController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: new Icon(Icons.search),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          title: TextFormField(
            enabled: true,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: ContractString.HINT_SEARCH,
            ),
            controller: tenController,
            onChanged: (name) {
              listContract.clear();
              flag = false;
            },
          )),
      body: StreamBuilder(
          stream: _contractBloc?.listContract,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              list = snapshot.data.data;
              return _build(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text(ContractString.ADD_CONTRACT),
                ),
              );
            }
          }),
    );
  }

  Widget _build(AsyncSnapshot snapshot) {
    if (flag) {
      return _buildListViewSeparated(list);
    } else {
      for (int i = 0; i < snapshot.data.length; i++) {
        if (snapshot.data[i].TenHD
            .toLowerCase()
            .contains(tenHD.toLowerCase())) {
          listContract.add(snapshot.data[i]);
        }
      }
      return _buildListViewSeparated(listContract);
    }
  }

  Widget _buildListViewSeparated(List<Contract> listContracts) {
    return ListView.separated(
      itemCount: listContracts.length,
      itemBuilder: (BuildContext context, int index) {
        DateTime now = DateTime.now();
        Contract item = listContracts[index];
        DateTime ngayHH = item.expirationDate != null
            ? DateTime.parse(item.expirationDate!)
            : DateTime.now();
        var soNgay = ngayHH.difference(now);
        listContract.add(listContracts[index]);
        return Dismissible(
          key: Key(listContract[index].documentID!),
          child: Padding(
            padding: GlobalStyles.paddingPageLeftRight,
            child: ListTile(
              contentPadding: GlobalStyles.paddingAll,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: AppColors.main)),
              tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
              leading: Column(
                children: <Widget>[
                  Text(
                    (index + 1).toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                        color: Colors.lightBlue),
                  ),
                ],
              ),
              title: _itemTitle(item.numberContract ?? ""),
              subtitle: _itemSubTitle(item: item),
              onTap: () {
                Navigator.pop(context, listContracts[index].name);
              },
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          color: Colors.green,
        );
      },
    );
  }

  Widget _itemTitle(String _title) {
    return Text(
      _title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24.0,
        color: AppColors.main,
      ),
    );
  }

  Widget _itemSubTitle({
    required Contract item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSubTitle(ContractString.INFO_NAME_CONTRACT, item.name),
        GlobalStyles.divider,
        _textSubTitle(
            ContractString.INFO_SIGNING_DATE,
            item.signingDate != "" && item.signingDate?.isNotEmpty == true
                ? DateFormat("dd / MM / yyyy")
                    .format(DateTime.parse(item.signingDate!))
                : ""),
        GlobalStyles.divider,
        _textSubTitle(
            ContractString.INFO_EXPIRATION_DATE,
            item.expirationDate != "" && item.expirationDate?.isNotEmpty == true
                ? DateFormat("dd / MM / yyyy")
                    .format(DateTime.parse(item.expirationDate!))
                : ""),
        GlobalStyles.divider,
        Text(
          ContractString.INFO_DETAIL,
          style: TextStyle(fontSize: 16, color: AppColors.black),
        ),
        Text(
          item.detail ?? "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  Widget _textSubTitle(_titleDetail, _subtitleDetail) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _titleDetail,
            style: TextStyle(fontSize: 16, color: AppColors.black),
          ),
        ),
        Expanded(
          child: Text(
            _subtitleDetail ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
