import 'dart:async';

import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/model_index.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_department_api.dart';

class DepartmentBloc {
  final DbDepartmentApi dbDepartmentApi;
  final AuthenticationApi authenticationApi;

  DepartmentBloc(this.dbDepartmentApi, this.authenticationApi) {
    _startListeners();
  }

  final StreamController<BaseResponse> _departmentController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListDepartment => _departmentController.sink;
  Stream<BaseResponse> get listDepartment => _departmentController.stream;

  final StreamController<DepartmentModel> _departmentDeleteController =
      StreamController<DepartmentModel>.broadcast();
  Sink<DepartmentModel> get deleteDepartment =>
      _departmentDeleteController.sink;

  final StreamController<String> _tenPbController =
      StreamController<String>.broadcast();
  Sink<String> get tenPbEditChanged => _tenPbController.sink;
  Stream<String> get tenPbEdit => _tenPbController.stream;

  final StreamController<BaseResponse> _departmentNameController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListNameDepartment =>
      _departmentNameController.sink;
  Stream<BaseResponse> get listNameDepartment =>
      _departmentNameController.stream;

  void _startListeners() {
    /*authenticationApi.getFirebaseAuth().currentUser.then((user) {
      dbApi.getAssetsList(user.uid).listen((assetsDocs) {
        _addListAssets.add(assetsDocs);
      });
      _assetsDeleteController.stream.listen((assets) {
        dbApi.deleteAsset(assets);
      });
    });*/
    dbDepartmentApi.getDepartmentList().listen((departmentDocs) {
      _addListDepartment.add(departmentDocs!);
    });
    _departmentDeleteController.stream.listen((department) {
      dbDepartmentApi.deleteDepartment(departmentModel: department);
    });

    _tenPbController.stream.listen((tenPb) {
      dbDepartmentApi.getTenDepartmentList(tenPb).listen((departmentDocs) {
        _addListNameDepartment.add(departmentDocs!);
      });
    });
  }

  void dispose() {
    _departmentDeleteController.close();
    _departmentController.close();
    _departmentNameController.close();
    _tenPbController.close();
  }
}
