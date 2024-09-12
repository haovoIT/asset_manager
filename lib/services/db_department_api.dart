import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/department_model.dart';

abstract class DbDepartmentApi {
  Stream<BaseResponse?> getDepartmentList();
  Stream<BaseResponse?> getTenDepartmentList(String name);
  Stream<BaseResponse?> getDepartmentListTen();
  Future<BaseResponse?> addDepartment(
      {required DepartmentModel departmentModel});
  Future<BaseResponse?> updateDepartment(
      {required DepartmentModel departmentModel});
  Future<BaseResponse?> deleteDepartment(
      {required DepartmentModel departmentModel});
}
