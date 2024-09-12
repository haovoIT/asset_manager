import 'dart:async';

import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/contract_model.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_contract_api.dart';

class ContractBloc {
  final DbCtApi dbCtApi;
  final AuthenticationApi authenticationApi;

  ContractBloc(this.dbCtApi, this.authenticationApi) {
    _startListeners();
  }

  final StreamController<BaseResponse> _contractController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListContract => _contractController.sink;
  Stream<BaseResponse> get listContract => _contractController.stream;

  final StreamController<Contract> _contractDeleteController =
      StreamController<Contract>.broadcast();
  Sink<Contract> get deleteContract => _contractDeleteController.sink;

  void _startListeners() {
    dbCtApi.getContractList().listen((contractDocs) {
      _addListContract.add(contractDocs!);
    });
    _contractDeleteController.stream.listen((contract) {
      dbCtApi.deleteContract(contract);
    });
  }

  void dispose() {
    _contractDeleteController.close();
    _contractController.close();
  }
}
