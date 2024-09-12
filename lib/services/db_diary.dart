import 'dart:io';

import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/diary_model.dart';
import 'package:assets_manager/services/db_diary_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbDiaryService implements DbDiaryApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'db_diary';
  DbDiaryService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<BaseResponse> getDiaryList(String idAsset) {
    return _firestore
        .collection(_collection)
        .where("idAsset", isEqualTo: idAsset)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<DiaryModel> _diaryModelDocs =
          snapshot.docs.map((doc) => DiaryModel.fromDoc(doc)).toList();
      _diaryModelDocs.sort(
          (comp1, comp2) => comp1.dateUpdate!.compareTo(comp2.dateUpdate!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _diaryModelDocs,
          message: MassageDbString.GET_LIST_DIARY_SUCCESS);
    });
  }

  Future<BaseResponse> addDiaryModel(DiaryModel diaryModel) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collection).add({
      'nameAsset': diaryModel.nameAsset,
      'idDepartment': diaryModel.idDepartment,
      'idAsset': diaryModel.idAsset,
      'originalPrice': diaryModel.originalPrice,
      'usedTime': diaryModel.usedTime,
      'qrCode': diaryModel.qrCode,
      'starDate': diaryModel.starDate,
      'endDate': diaryModel.endDate,
      'depreciation': diaryModel.depreciation,
      'userName': diaryModel.userName,
      'userEmail': diaryModel.userEmail,
      'dateUpdate': diaryModel.dateUpdate,
      'detail': diaryModel.detail,
      'dateCreate': diaryModel.dateCreate,
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        data: _documentReference.id,
        message: MassageDbString.ADD_DIARY_SUCCESS);
  }

  Future<BaseResponse> updateDiaryModel(DiaryModel diaryModel) async {
    await _firestore.collection(_collection).doc(diaryModel.documentID).update({
      'nameAsset': diaryModel.nameAsset,
      'idDepartment': diaryModel.idDepartment,
      'idAsset': diaryModel.idAsset,
      'originalPrice': diaryModel.originalPrice,
      'usedTime': diaryModel.usedTime,
      'qrCode': diaryModel.qrCode,
      'starDate': diaryModel.starDate,
      'endDate': diaryModel.endDate,
      'depreciation': diaryModel.depreciation,
      'userName': diaryModel.userName,
      'userEmail': diaryModel.userEmail,
      'dateUpdate': diaryModel.dateUpdate,
      'detail': diaryModel.detail,
      'dateCreate': diaryModel.dateCreate,
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_DIARY_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_DIARY_SUCCESS);
  }

  Future<BaseResponse> deleteDiaryModel(DiaryModel diaryModel) async {
    await _firestore
        .collection(_collection)
        .doc(diaryModel.documentID)
        .delete()
        .catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_DIARY_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_DIARY_SUCCESS);
  }
}
