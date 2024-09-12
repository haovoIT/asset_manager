import 'dart:io';

import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/department_model.dart';
import 'package:assets_manager/services/db_department_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbDepartmentService implements DbDepartmentApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionDepartments = 'db_department';

  DbDepartmentService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }
  Stream<BaseResponse?> getDepartmentList() {
    return _firestore
        .collection(_collectionDepartments)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<DepartmentModel> _departmentDocs =
          snapshot.docs.map((doc) => DepartmentModel.fromDoc(doc)).toList();
      _departmentDocs
          .sort((comp1, comp2) => comp1.code!.compareTo(comp2.code!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _departmentDocs,
          message: MassageDbString.GET_LIST_DEPARTMENT_SUCCESS);
    });
  }

  Stream<BaseResponse?> getTenDepartmentList(String nameDepartment) {
    return _firestore
        .collection(_collectionDepartments)
        .where("nameDepartment", isEqualTo: nameDepartment)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<DepartmentModel> _departmentDocs =
          snapshot.docs.map((doc) => DepartmentModel.fromDoc(doc)).toList();
      _departmentDocs
          .sort((comp1, comp2) => comp1.code!.compareTo(comp2.code!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _departmentDocs,
          message: MassageDbString.GET_LIST_DEPARTMENT_SUCCESS);
    });
  }

  Stream<BaseResponse?> getDepartmentListTen() {
    return _firestore
        .collection(_collectionDepartments)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<DepartmentModel> _departmentDocs = snapshot.docs
          .map((doc) => DepartmentModel.fromDocNameDepartment(doc))
          .toList();
      _departmentDocs
          .sort((comp1, comp2) => comp1.code!.compareTo(comp2.code!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _departmentDocs,
          message: MassageDbString.GET_LIST_DEPARTMENT_SUCCESS);
    });
  }

  Future<BaseResponse?> addDepartment(
      {required DepartmentModel departmentModel}) async {
    final collectionRef = _firestore.collection(_collectionDepartments);
    final querySnapshot = await collectionRef
        .where('code', isEqualTo: departmentModel.code)
        .get();

    if (querySnapshot.docs.isEmpty) {
      DocumentReference _documentReference =
          await _firestore.collection(_collectionDepartments).add({
        'name': departmentModel.name,
        'code': departmentModel.code,
        'phone': departmentModel.phone,
        'address': departmentModel.address,
        'dateCreate': departmentModel.dateCreate,
        'status': departmentModel.status,
      });
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _documentReference.id,
          message: MassageDbString.ADD_DEPARTMENT_SUCCESS);
    } else {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.ADD_DEPARTMENT_ERROR_DUPLICATE);
    }
  }

  Future<BaseResponse?> updateDepartment(
      {required DepartmentModel departmentModel}) async {
    await _firestore
        .collection(_collectionDepartments)
        .doc(departmentModel.documentID)
        .update({
      'name': departmentModel.name,
      'code': departmentModel.code,
      'phone': departmentModel.phone,
      'address': departmentModel.address,
      'dateCreate': departmentModel.dateCreate,
      'status': departmentModel.status,
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_DEPARTMENT_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_DEPARTMENT_SUCCESS);
  }

  Future<BaseResponse?> deleteDepartment(
      {required DepartmentModel departmentModel}) async {
    await _firestore
        .collection(_collectionDepartments)
        .doc(departmentModel.documentID)
        .delete()
        .catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.DELETE_DEPARTMENT_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.DELETE_DEPARTMENT_SUCCESS);
  }
}
