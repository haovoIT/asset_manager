import 'dart:io';

import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/supplier_model.dart';
import 'package:assets_manager/services/db_supplier_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbSupplierService implements DbSupplierApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'db_supplier';

  DbSupplierService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  @override
  Stream<BaseResponse> getListSuppliers() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<SupplierModel> _suppliersDocs =
          snapshot.docs.map((doc) => SupplierModel.fromDoc(doc)).toList();
      _suppliersDocs
        ..sort((comp1, comp2) => comp1.name!.compareTo(comp2.name!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _suppliersDocs,
          message: MassageDbString.GET_LIST_SUPPLIERS_SUCCESS);
    });
  }

  @override
  Future<BaseResponse> addSupplier(SupplierModel supplierModel) async {
    final collectionRef = _firestore.collection(_collection);
    final querySnapshot =
        await collectionRef.where('name', isEqualTo: supplierModel.name).get();

    if (querySnapshot.docs.isEmpty) {
      DocumentReference _documentReference =
          await _firestore.collection(_collection).add({
        'name': supplierModel.name,
        'address': supplierModel.address,
        'phone': supplierModel.phone,
        'email': supplierModel.email
      });
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _documentReference.id,
          message: MassageDbString.ADD_ASSET_SUCCESS);
    } else {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.ADD_ASSET_ERROR_DUPLICATE);
    }
  }

  @override
  Future<BaseResponse> updateSupplier(SupplierModel supplierModel) async {
    await _firestore
        .collection(_collection)
        .doc(supplierModel.documentID)
        .update({
      'name': supplierModel.name,
      'address': supplierModel.address,
      'phone': supplierModel.phone,
      'email': supplierModel.email
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_SUPPLIER_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_SUPPLIER_SUCCESS);
  }

  Future<BaseResponse> deleteSupplier(SupplierModel supplierModel) async {
    await _firestore
        .collection(_collection)
        .doc(supplierModel.documentID)
        .delete()
        .catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.DELETE_SUPPLIER_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.DELETE_SUPPLIER_SUCCESS);
  }
}
