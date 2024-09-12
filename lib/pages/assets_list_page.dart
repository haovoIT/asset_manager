import 'package:assets_manager/bloc/authentication_bloc.dart';
import 'package:assets_manager/bloc/authentication_bloc_provider.dart';
import 'package:assets_manager/bloc/home_bloc.dart';
import 'package:assets_manager/bloc/home_bloc_provider.dart';
import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/services/db_asset.dart';
import 'package:assets_manager/services/db_authentic.dart';
import 'package:assets_manager/services/db_history_asset.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssetsPageList extends StatelessWidget {
  final String maPB;

  const AssetsPageList({Key? key, required this.maPB}) : super(key: key);
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
            return HomeBlocProvider(
              homeBloc: HomeBloc(DbFirestoreService(), DbHistoryAssetService(),
                  _authenticationserver),
              uid: snapshot.data!,
              child: AssetsPageLists(
                maPB: maPB,
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Text('Thêm Tài Sản.'),
              ),
            );
          }
        },
      ),
    );
  }
}

class AssetsPageLists extends StatefulWidget {
  final String maPB;
  const AssetsPageLists({Key? key, required this.maPB}) : super(key: key);

  @override
  _AssetsPageListsState createState() => _AssetsPageListsState();
}

class _AssetsPageListsState extends State<AssetsPageLists> {
  HomeBloc? _homeBloc;
  String? _uid;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _homeBloc = HomeBlocProvider.of(context)!.homeBloc;
    _uid = HomeBlocProvider.of(context)!.uid;
    _homeBloc!.maPBEditChanged.add(widget.maPB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Tài Sản"),
      ),
      body: StreamBuilder(
          stream: _homeBloc!.listAssetsPB,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return _buildListViewSeparated(snapshot.data?.data);
            } else {
              return Center(
                child: Container(
                  child: Text('Thêm Tài Sản.'),
                ),
              );
            }
          }),
    );
  }

  Widget _buildListViewSeparated(data) {
    return ListView.separated(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final AssetsModel item = data[index];
          return Card(
            child: Padding(
              padding: GlobalStyles.paddingPageLeftRight,
              child: ListTile(
                contentPadding: GlobalStyles.paddingAll,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.main)),
                tileColor: index % 2 == 0 ? Colors.green.shade50 : Colors.white,
                leading: Image.asset(
                  "assets/images/img.png",
                ),
                title: _itemTitle(item.code ?? ""),
                subtitle: _itemSubTitle(item: item),
                onTap: () => Alert.showInfoAsset(
                    title: AssetString.INFO_TITLE,
                    assetsModel: item,
                    context: context),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: Colors.white,
          );
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
    required AssetsModel item,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _textSubTitle(AssetString.INFO_NAME_ASSETS, item.nameAsset),
        GlobalStyles.divider,
        _textSubTitle(AssetString.DEPARTMENTS, item.departmentName),
        GlobalStyles.divider,
        _textSubTitle(AssetString.STATUS, item.status ?? ""),
        GlobalStyles.divider,
        _textSubTitle(
            AssetString.START_DATE,
            item.starDate != "" && item.starDate?.isNotEmpty == true
                ? DateFormat("dd/ MM/ yyyy")
                    .format(DateTime.parse(item.starDate!))
                : ""),
        GlobalStyles.divider,
        _textSubTitle(
            AssetString.END_DATE,
            item.endDate != "" && item.endDate?.isNotEmpty == true
                ? DateFormat("dd/ MM/ yyyy")
                    .format(DateTime.parse(item.endDate!))
                : ""),
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
