import 'dart:io';

import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/contract_model.dart';
import 'package:assets_manager/services/db_contract_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbContractService implements DbCtApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'db_contract';

  DbContractService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }
  Stream<BaseResponse?> getContractList() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<Contract> _contractDocs =
          snapshot.docs.map((doc) => Contract.fromDoc(doc)).toList();
      _contractDocs..sort((comp1, comp2) => comp1.name!.compareTo(comp2.name!));
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _contractDocs,
          message: MassageDbString.GET_LIST_CONTRACT_SUCCESS);
    });
  }

  Future<BaseResponse?> addContract(Contract contract) async {
    final collectionRef = _firestore.collection(_collection);
    final querySnapshot = await collectionRef
        .where('numberContract', isEqualTo: contract.numberContract)
        .where('expirationDate', isEqualTo: contract.expirationDate)
        .get();

    if (querySnapshot.docs.isEmpty) {
      DocumentReference _documentReference =
          await _firestore.collection(_collection).add({
        'numberContract': contract.numberContract,
        'name': contract.name,
        'signingDate': contract.signingDate,
        'expirationDate': contract.expirationDate,
        'nameSupplier': contract.nameSupplier,
        'detail': contract.detail
      });
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 0,
          data: _documentReference.id,
          message: MassageDbString.ADD_CONTRACT_SUCCESS);
    } else {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.ADD_CONTRACT_ERROR_DUPLICATE);
    }
  }

  Future<BaseResponse?> updateContract(Contract contract) async {
    await _firestore.collection(_collection).doc(contract.documentID).update({
      'numberContract': contract.numberContract,
      'name': contract.name,
      'signingDate': contract.signingDate,
      'expirationDate': contract.expirationDate,
      'nameSupplier': contract.nameSupplier,
      'detail': contract.detail
    }).catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.UPDATE_CONTRACT_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.UPDATE_CONTRACT_SUCCESS);
  }

  Future<BaseResponse?> deleteContract(Contract contract) async {
    await _firestore
        .collection(_collection)
        .doc(contract.documentID)
        .delete()
        .catchError((error) {
      return BaseResponse(
          statusCode: HttpStatus.ok,
          status: 1,
          message: MassageDbString.DELETE_CONTRACT_ERROR);
    });
    return BaseResponse(
        statusCode: HttpStatus.ok,
        status: 0,
        message: MassageDbString.DELETE_CONTRACT_SUCCESS);
  }
}
