import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/supplier_bloc.dart';
import 'package:assets_manager/bloc/supplier_bloc_provider.dart';
import 'package:assets_manager/bloc/supplier_edit_bloc.dart';
import 'package:assets_manager/bloc/supplier_edit_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/inPDF/inPDF_DanhSachNhaCungCap.dart';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/supplier_model.dart';
import 'package:assets_manager/pages/supplier_edit_page.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_supplier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SupplierPageInit extends StatelessWidget {
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
            return SupplierBlocProvider(
                supplierBloc:
                    SupplierBloc(DbSupplierService(), _authenticationServer),
                uid: snapshot.data!,
                child: SupplierPage());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Nhà Cung Cấp.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class SupplierPage extends StatefulWidget {
  const SupplierPage({Key? key}) : super(key: key);

  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  SupplierBloc? _supplierBloc;
  List<SupplierModel> listSupplier = [];
  String email = FirebaseAuth.instance.currentUser?.email ?? "";
  String displayName = FirebaseAuth.instance.currentUser?.displayName ?? "";
  String maPb = '';
  String name = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _supplierBloc = SupplierBlocProvider.of(context)?.supplierBloc;
    maPb = displayName.length > 20 ? displayName.substring(0, 20) : '';
    name = displayName.length > 20
        ? displayName.substring(21, displayName.length)
        : displayName;
  }

  void _addOrEditNhaCungCap(
      {required bool add, required SupplierModel supplierModel}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => SupplierEditBlocProvider(
                supplierEditBloc: SupplierEditBloc(
                  add: add,
                  dbSupplierApi: DbSupplierService(),
                  selectSupplier: supplierModel,
                ),
                child: SupplierEditPage(
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
        title: Text(SupplierString.TITLE_LIST_PAGE),
        actions: [
          IconButton(
              onPressed: () async {
                final pdfFile = await PdfDSNhaCungCapApi.generate(
                    listSupplier, email, name);
                PdfApi.openFile(pdfFile, context);
              },
              icon: Icon(
                Icons.print,
                color: Colors.lightGreen.shade800,
              ))
        ],
      ),
      body: StreamBuilder(
          stream: _supplierBloc?.listSupplier,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot);
            } else {
              return Center(
                child: Container(
                  child: Text(SupplierString.ADD_SUPPLIER),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addOrEditNhaCungCap(add: true, supplierModel: SupplierModel());
        },
        icon: Icon(Icons.add),
        label: Text(SupplierString.SUPPLIER),
      ),
    );
  }

  Widget _buildListViewSeparated(data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        SupplierModel item = data[index];
        listSupplier.add(item);
        return Dismissible(
          key: Key(item.documentID!),
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
              title: _itemTitle(item.name ?? ""),
              subtitle: _itemSubTitle(item: item),
              onTap: () {
                _addOrEditNhaCungCap(
                  add: false,
                  supplierModel: item,
                );
              },
            ),
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await await Alert.showConfirm(context,
                title: SupplierString.TITLE_CONFIRM_DELETE,
                detail: SupplierString.DETAIL_CONFIRM_DELETE,
                btTextTrue: CommonString.CONTINUE,
                btTextFalse: CommonString.CANCEL);
            if (confirmDelete) {
              _supplierBloc?.deleteSupplier.add(item);
            }
            return null;
          },
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
    required SupplierModel item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSubTitle(SupplierString.LABEL_EMAIL, item.email),
        GlobalStyles.divider,
        _textSubTitle(SupplierString.LABEL_TEXT_PHONE, item.phone),
        GlobalStyles.divider,
        _textSubTitle(SupplierString.LABEL_TEXT_ADDRESS, item.address),
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
