import 'dart:async';

import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/contract_model.dart';
import 'package:assets_manager/services/db_contract_api.dart';

class ContractEditBloc {
  final DbCtApi dbCtApi;
  final bool add;
  Contract selectContract;

  ContractEditBloc({
    required this.add,
    required this.dbCtApi,
    required this.selectContract,
  }) {
    _startEditListeners().then((finished) => _getContract(add, selectContract));
  }

  final StreamController<String> _numberContractController =
      StreamController<String>.broadcast();
  Sink<String> get numberContractEditChanged => _numberContractController.sink;
  Stream<String> get numberContractEdit => _numberContractController.stream;

  final StreamController<String> _nameController =
      StreamController<String>.broadcast();
  Sink<String> get nameEditChanged => _nameController.sink;
  Stream<String> get nameEdit => _nameController.stream;

  final StreamController<String> _signingDateController =
      StreamController<String>.broadcast();
  Sink<String> get signingDateEditChanged => _signingDateController.sink;
  Stream<String> get signingDateEdit => _signingDateController.stream;

  final StreamController<String> _expirationDateController =
      StreamController<String>.broadcast();
  Sink<String> get expirationDateEditChanged => _expirationDateController.sink;
  Stream<String> get expirationDateEdit => _expirationDateController.stream;

  final StreamController<String> _nameSupplierController =
      StreamController<String>.broadcast();
  Sink<String> get nameSupplierEditChanged => _nameSupplierController.sink;
  Stream<String> get nameSupplierEdit => _nameSupplierController.stream;

  final StreamController<String> _detailController =
      StreamController<String>.broadcast();
  Sink<String> get detailEditChanged => _detailController.sink;
  Stream<String> get detailEdit => _detailController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  final StreamController<BaseResponse> _responseController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get responseEditChanged => _responseController.sink;
  Stream<BaseResponse> get responseEdit => _responseController.stream;

  _startEditListeners() async {
    _numberContractController.stream.listen((numberContract) {
      selectContract.numberContract = numberContract;
    });
    _nameController.stream.listen((name) {
      selectContract.name = name;
    });
    _signingDateController.stream.listen((signingDate) {
      selectContract.signingDate = signingDate;
    });

    _expirationDateController.stream.listen((expirationDate) {
      selectContract.expirationDate = expirationDate;
    });

    _nameSupplierController.stream.listen((nameSupplier) {
      selectContract.nameSupplier = nameSupplier;
    });

    _detailController.stream.listen((detail) {
      selectContract.detail = detail;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveContract();
      }
    });
  }

  void _getContract(bool add, Contract contract) {
    if (add) {
      selectContract = Contract();
      selectContract.numberContract = '';
      selectContract.name = '';
      selectContract.signingDate = DateTime.now().toString();
      selectContract.expirationDate = DateTime.now().toString();
      selectContract.nameSupplier = '';
      selectContract.detail = '';
    } else {
      selectContract.numberContract = contract.numberContract;
      selectContract.name = contract.name;
      selectContract.signingDate = contract.signingDate;
      selectContract.expirationDate = contract.expirationDate;
      selectContract.nameSupplier = contract.nameSupplier;
      selectContract.detail = contract.detail;
    }
    numberContractEditChanged.add(selectContract.numberContract ?? "");
    nameEditChanged.add(selectContract.name ?? "");
    signingDateEditChanged.add(selectContract.signingDate ?? "");
    expirationDateEditChanged.add(selectContract.expirationDate ?? "");
    nameSupplierEditChanged.add(selectContract.nameSupplier ?? "");
    detailEditChanged.add(selectContract.detail ?? "");
  }

  void _saveContract() async {
    Contract contract = Contract(
      documentID: selectContract.documentID,
      numberContract: selectContract.numberContract,
      name: selectContract.name,
      signingDate: selectContract.signingDate,
      expirationDate: selectContract.expirationDate,
      nameSupplier: selectContract.nameSupplier,
      detail: selectContract.detail,
    );
    add ? dbCtApi.addContract(contract) : dbCtApi.updateContract(contract);

    if (add) {
      final response = await dbCtApi.addContract(contract);
      responseEditChanged.add(response!);
    } else {
      final response = await dbCtApi.updateContract(contract);
      responseEditChanged.add(response!);
    }
  }

  void dispose() {
    _numberContractController.close();
    _nameController.close();
    _signingDateController.close();
    _expirationDateController.close();
    _nameSupplierController.close();
    _detailController.close();
    _saveController.close();
    _responseController.close();
  }
}
