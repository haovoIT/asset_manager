import 'dart:io';

import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/history_asset_model.dart';
import 'package:assets_manager/services/db_history_asset_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbHistoryAssetService implements DbHistoryAssetApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'db_history_asset_manager';

  DbHistoryAssetService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<BaseResponse> getHistoryAsset(String qrCode) {
    return _firestore
        .collection(_collectionAssets)
        .where("qrCode", isEqualTo: qrCode)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<HistoryAssetModel> _historyAssetDocs =
          snapshot.docs.map((doc) => HistoryAssetModel.fromDoc(doc)).toList();
      _historyAssetDocs.sort(
          (comp1, comp2) => comp1.dateUpdate!.compareTo(comp2.dateUpdate!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _historyAssetDocs,
          message: MassageDbString.GET_LIST_HISTORY_ASSET_SUCCESS);
    });
  }

  Future<BaseResponse> addHistoryAsset(
      HistoryAssetModel historyAssetModel) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'nameAsset': historyAssetModel.nameAsset,
      'idAsset': historyAssetModel.idAsset,
      'code': historyAssetModel.code,
      'idDepartment': historyAssetModel.idDepartment,
      'departmentName': historyAssetModel.departmentName,
      'yearOfManufacture': historyAssetModel.yearOfManufacture,
      'producingCountry': historyAssetModel.producingCountry,
      'assetGroupName': historyAssetModel.assetGroupName,
      'status': historyAssetModel.status,
      'originalPrice': historyAssetModel.originalPrice,
      'usedTime': historyAssetModel.usedTime,
      'amount': historyAssetModel.amount,
      'contractName': historyAssetModel.contractName,
      'purposeOfUsing': historyAssetModel.purposeOfUsing,
      'qrCode': historyAssetModel.qrCode,
      'userId': historyAssetModel.userId,
      'starDate': historyAssetModel.starDate,
      'endDate': historyAssetModel.endDate,
      'depreciation': historyAssetModel.depreciation,
      'dateCreate': historyAssetModel.dateCreate,
      'userName': historyAssetModel.userName,
      'userEmail': historyAssetModel.userEmail,
      'dateUpdate': historyAssetModel.dateUpdate
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.ADD_HISTORY_ASSET_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        data: _documentReference.id,
        message: MassageDbString.ADD_HISTORY_ASSET_SUCCESS);
  }
}
