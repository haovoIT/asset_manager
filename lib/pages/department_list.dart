import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/department_bloc.dart';
import 'package:assets_manager/bloc/department_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/department_model.dart';
import 'package:assets_manager/pages/assets_list_page.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_department.dart';
import 'package:flutter/material.dart';

class DepartmentsList extends StatelessWidget {
  final bool flag;

  DepartmentsList({Key? key, required this.flag}) : super(key: key);
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
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return DepartmentBlocProvider(
                departmentBloc: DepartmentBloc(
                    DbDepartmentService(), _authenticationserver),
                uid: snapshot.data!,
                child: DepartmentList(
                  flag: flag,
                ));
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Phòng Ban.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class DepartmentList extends StatefulWidget {
  final bool flag;
  const DepartmentList({Key? key, required this.flag}) : super(key: key);

  @override
  _DepartmentListState createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  DepartmentBloc? _departmentBloc;
  TextEditingController tenController = new TextEditingController();
  String nameSearch = "";
  bool flag = true;
  List<DepartmentModel> listDepartment = [];
  List<DepartmentModel> list = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _departmentBloc = DepartmentBlocProvider.of(context)?.departmentBloc;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tenController.addListener(() {
      setState(() {
        nameSearch = tenController.text;
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
              onPressed: () {
                tenController.clear();
                setState(() {
                  flag = true;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
          title: TextFormField(
            enabled: true,
            style: TextStyle(fontSize: 18.0, color: Colors.black),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: DepartmentString.HINT_NAME_SEARCH,
            ),
            controller: tenController,
            onChanged: (name) {
              listDepartment.clear();
              flag = false;
            },
          )),
      body: Container(
        child: StreamBuilder(
            stream: _departmentBloc?.listDepartment,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                list = snapshot.data.data;
                return _build(snapshot.data.data);
              } else {
                return Center(
                  child: Container(
                    child: Text('Thêm Phòng Ban.'),
                  ),
                );
              }
            }),
      ),
    );
  }

  Widget _build(data) {
    if (flag) {
      return _buildListViewSeparated(list);
    } else {
      for (int i = 0; i < data.length; i++) {
        if (data[i].name.toLowerCase().contains(nameSearch.toLowerCase())) {
          listDepartment.add(data[i]);
        }
      }
      return _buildListViewSeparated(listDepartment);
    }
  }

  Widget _buildListViewSeparated(List<DepartmentModel> listDepartments) {
    return ListView.separated(
      itemCount: listDepartments.length,
      itemBuilder: (BuildContext context, int index) {
        final DepartmentModel item = listDepartments[index];
        return Padding(
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
              widget.flag
                  ? Navigator.pop(
                      context, listDepartments[index].documentID! + item.name!)
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssetsPageList(
                                maPB: listDepartments[index].documentID!,
                              )));
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return GlobalStyles.sizedBoxHeight;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    tenController.dispose();
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
        // GlobalStyles.divider,
        // _textSubTitle(DepartmentString.ADDRESS, item.address ?? ""),
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
