import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/contract_bloc.dart';
import 'package:assets_manager/bloc/contract_bloc_provider.dart';
import 'package:assets_manager/bloc/contract_edit_bloc.dart';
import 'package:assets_manager/bloc/contract_edit_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachHopDong.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/contract_model.dart';
import 'package:assets_manager/pages/contract_edit_page.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_contract.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractPage extends StatelessWidget {
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return ContractBlocProvider(
                contractBloc:
                    ContractBloc(DbContractService(), _authenticationServer),
                uid: snapshot.data!,
                child: ContractPages());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Hợp Đồng.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class ContractPages extends StatefulWidget {
  const ContractPages({Key? key}) : super(key: key);

  @override
  _ContractPagesState createState() => _ContractPagesState();
}

class _ContractPagesState extends State<ContractPages> {
  ContractBloc? _contractBloc;
  List<Contract> listContract = [];
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';
  String email = FirebaseAuth.instance.currentUser?.email ?? "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _contractBloc = ContractBlocProvider.of(context)?.contractBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  void _addOrEditContract({required bool add, required Contract contract}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => ContractEditBlocProvider(
                contractEditBloc: ContractEditBloc(
                  add: add,
                  dbCtApi: DbContractService(),
                  selectContract: contract,
                ),
                child: ContractEditPage(
                  flag: add,
                ),
              ),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ContractString.TITLE_LIST_PAGE),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile =
                    await PdfDSHopDongApi.generate(listContract, email, name);
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _contractBloc?.listContract,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot.data.data);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Hợp đồng.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addOrEditContract(add: true, contract: Contract());
        },
        icon: Icon(Icons.add),
        label: Text('Hợp Đồng '),
      ),
    );
  }

  Widget _buildListViewSeparated(data) {
    return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          DateTime now = DateTime.now();
          Contract item = data[index];
          DateTime ngayHH = item.expirationDate != null
              ? DateTime.parse(item.expirationDate!)
              : DateTime.now();
          var soNgay = ngayHH.difference(now);
          listContract.add(data[index]);

          return Dismissible(
            key: Key(data[index].documentID),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
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
                          fontSize: 24.0,
                          color: Colors.lightBlue),
                    ),
                  ],
                ),
                title: _itemTitle(item.numberContract ?? ""),
                subtitle: _itemSubTitle(item: item),
                onTap: () {
                  _addOrEditContract(
                    add: false,
                    contract: data[index],
                  );
                },
              ),
            ),
            confirmDismiss: (direction) async {
              bool confirmDelete = await await Alert.showConfirm(context,
                  title: ContractString.TITLE_CONFIRM_DELETE,
                  detail: ContractString.DETAIL_CONFIRM_DELETE,
                  btTextTrue: CommonString.CONTINUE,
                  btTextFalse: CommonString.CANCEL);
              if (confirmDelete) {
                _contractBloc?.deleteContract.add(data[index]);
              }
              return null;
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return GlobalStyles.sizedBoxHeight;
        });
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
