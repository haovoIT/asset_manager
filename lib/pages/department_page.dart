import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/department_bloc.dart';
import 'package:assets_manager/bloc/department_bloc_provider.dart';
import 'package:assets_manager/bloc/department_edit_bloc.dart';
import 'package:assets_manager/bloc/department_edit_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/department_model.dart';
import 'package:assets_manager/pages/department_edit_page.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_department.dart';
import 'package:flutter/material.dart';

class DepartmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthenticationServer _authenticationserver =
        AuthenticationServer(context);
    final AuthenticationBloc _authenticationBloc =
        AuthenticationBloc(_authenticationserver);
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
            return DepartmentBlocProvider(
                departmentBloc: DepartmentBloc(
                    DbDepartmentService(), _authenticationserver),
                uid: snapshot.data!,
                child: Warehouse());
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Phòng Ban'),
              ),
            );
          }
        },
      ),
    );
  }
}

class Warehouse extends StatefulWidget {
  const Warehouse({Key? key}) : super(key: key);

  @override
  _WarehouseState createState() => _WarehouseState();
}

class _WarehouseState extends State<Warehouse> {
  DepartmentBloc? _departmentBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _departmentBloc = DepartmentBlocProvider.of(context)?.departmentBloc;
  }

  void _addOrEditDepartment(
      {required bool add, required DepartmentModel department}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => DepartmentEditBlocProvider(
                departmentEditBloc:
                    DepartmentEditBloc(add, DbDepartmentService(), department),
                child: DepartmentEditPage(
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
        title: Text('Danh Sách Phòng Ban'),
      ),
      body: StreamBuilder(
          stream: _departmentBloc?.listDepartment,
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
                  child: Text('Thêm Phòng Ban.'),
                ),
              );
            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          _addOrEditDepartment(add: true, department: DepartmentModel());
        },
        icon: Icon(Icons.add),
        label: Text(DepartmentString.DEPARTMENT),
      ),
    );
  }

  Widget _buildListViewSeparated(data) {
    return ListView.separated(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final DepartmentModel item = data[index];
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
              leading: Text(
                (index + 1).toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    color: Colors.lightBlue),
              ),
              title: _itemTitle(item.code ?? ""),
              subtitle: _itemSubTitle(item: item),
              onTap: () {
                _addOrEditDepartment(add: false, department: data[index]);
              },
            ),
          ),
          confirmDismiss: (direction) async {
            bool confirmDelete = await await Alert.showConfirm(context,
                title: DepartmentString.TITLE_CONFIRM_DELETE,
                detail: DepartmentString.DETAIL_CONFIRM_DELETE,
                btTextTrue: CommonString.CONTINUE,
                btTextFalse: CommonString.CANCEL);
            if (confirmDelete) {
              _departmentBloc?.deleteDepartment.add(data[index]);
            }
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return GlobalStyles.sizedBoxHeight;
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
    required DepartmentModel item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSubTitle(DepartmentString.NAME, item.name),
        GlobalStyles.divider,
        _textSubTitle(DepartmentString.PHONE, item.phone),
        GlobalStyles.divider,
        _textSubTitle(DepartmentString.ADDRESS, item.address ?? ""),
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
