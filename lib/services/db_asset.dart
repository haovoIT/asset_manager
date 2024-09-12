import 'dart:io';

import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/services/db_asset_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../component/index.dart';

class DbFirestoreService implements DbApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'db_asset_manager';

  DbFirestoreService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<BaseResponse?> getAssetsList({required idDepartment}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.nameAsset!.compareTo(comp2.nameAsset!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _assetsDocs,
          message: MassageDbString.GET_LIST_ASSET_SUCCESS);
    });
  }

  Stream<BaseResponse?> getAssetsListKhauHao() {
    return _firestore
        .collection(_collectionAssets)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp2.qrCode!.compareTo(comp1.qrCode!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _assetsDocs,
          message: MassageDbString.GET_LIST_ASSET_SUCCESS);
    });
  }

  Stream<BaseResponse?> getListAssetsID(
      {required String idDepartment, required String id}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .where("qrCode", isEqualTo: id)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs.sort((comp1, comp2) => comp1.code!.compareTo(comp2.code!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _assetsDocs,
          message: MassageDbString.GET_LIST_ASSET_SUCCESS);
    });
  }

  Stream<BaseResponse?> getAssetsStatus(
      {required String idDepartment, required String status}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .where("status", isEqualTo: status)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs.sort((comp1, comp2) => comp1.code!.compareTo(comp2.code!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _assetsDocs,
          message: MassageDbString.GET_LIST_ASSET_SUCCESS);
    });
  }

  Stream<BaseResponse?> getAssetsOfDepartment({required String idDepartment}) {
    return _firestore
        .collection(_collectionAssets)
        .where("idDepartment", isEqualTo: idDepartment)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<AssetsModel> _assetsDocs =
          snapshot.docs.map((doc) => AssetsModel.fromDoc(doc)).toList();
      _assetsDocs.sort((comp1, comp2) => comp1.code!.compareTo(comp2.code!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _assetsDocs,
          message: MassageDbString.GET_LIST_ASSET_SUCCESS);
    });
  }

  Future<BaseResponse?> addAssets({required AssetsModel assets}) async {
    final collectionRef = _firestore.collection(_collectionAssets);
    final querySnapshot =
        await collectionRef.where('code', isEqualTo: assets.code).get();

    if (querySnapshot.docs.isEmpty) {
      DocumentReference _documentReference =
          await _firestore.collection(_collectionAssets).add({
        'nameAsset': assets.nameAsset,
        'code': assets.code,
        'idDepartment': assets.idDepartment,
        'departmentName': assets.departmentName,
        'yearOfManufacture': assets.yearOfManufacture,
        'producingCountry': assets.producingCountry,
        'assetGroupName': assets.assetGroupName,
        'status': assets.status,
        'originalPrice': assets.originalPrice,
        'usedTime': assets.usedTime,
        'amount': assets.amount,
        'contractName': assets.contractName,
        'purposeOfUsing': assets.purposeOfUsing,
        'qrCode': assets.qrCode,
        'userId': assets.userId,
        'starDate': assets.starDate,
        'endDate': assets.endDate,
        'depreciation': assets.depreciation,
        'dateCreate': assets.dateCreate,
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

  Future<BaseResponse?> updateAsset({required AssetsModel assets}) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(assets.documentID)
        .update({
      'nameAsset': assets.nameAsset,
      'code': assets.code,
      'idDepartment': assets.idDepartment,
      'departmentName': assets.departmentName,
      'yearOfManufacture': assets.yearOfManufacture,
      'producingCountry': assets.producingCountry,
      'assetGroupName': assets.assetGroupName,
      'status': assets.status,
      'originalPrice': assets.originalPrice,
      'usedTime': assets.usedTime,
      'amount': assets.amount,
      'contractName': assets.contractName,
      'purposeOfUsing': assets.purposeOfUsing,
      'qrCode': assets.qrCode,
      'userId': assets.userId,
      'starDate': assets.starDate,
      'endDate': assets.endDate,
      'depreciation': assets.depreciation,
      'dateCreate': assets.dateCreate,
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_ASSET_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_ASSET_SUCCESS);
  }

  @override
  Future<BaseResponse?> updateAssetWithTransaction(
      {required AssetsModel assets}) async {
    await _firestore.collection(_collectionAssets).doc(assets.documentID).set({
      'nameAsset': assets.nameAsset,
      'code': assets.code,
      'idDepartment': assets.idDepartment,
      'departmentName': assets.departmentName,
      'yearOfManufacture': assets.yearOfManufacture,
      'producingCountry': assets.producingCountry,
      'assetGroupName': assets.assetGroupName,
      'status': assets.status,
      'originalPrice': assets.originalPrice,
      'usedTime': assets.usedTime,
      'amount': assets.amount,
      'contractName': assets.contractName,
      'purposeOfUsing': assets.purposeOfUsing,
      'qrCode': assets.qrCode,
      'userId': assets.userId,
      'starDate': assets.starDate,
      'endDate': assets.endDate,
      'depreciation': assets.depreciation,
      'dateCreate': assets.dateCreate,
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_ASSET_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_ASSET_SUCCESS);
  }

  @override
  Future<BaseResponse?> deleteAsset({required AssetsModel assets}) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(assets.documentID)
        .delete()
        .catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.DELETE_ASSET_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.DELETE_ASSET_SUCCESS);
  }

  @override
  Future<BaseResponse?> getAssets({required String documentID}) {
    return _firestore
        .collection(_collectionAssets)
        .doc(documentID)
        .get()
        .then((doc) {
      AssetsModel _assetsDocs = AssetsModel.fromDocID(doc.data());
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _assetsDocs,
          message: MassageDbString.GET_ASSET_TO_ID_SUCCESS);
    }).onError((error, stackTrace) => BaseResponse(
            statusCode: HttpStatus.ok,
            status: 1,
            message: MassageDbString.GET_ASSET_TO_ID_ERROR));
  }
}
