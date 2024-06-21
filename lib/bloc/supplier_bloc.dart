import 'dart:async';

import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/supplier_model.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_supplier_api.dart';

class SupplierBloc {
  final DbSupplierApi dbSupplierApi;
  final AuthenticationApi authenticationApi;

  SupplierBloc(this.dbSupplierApi, this.authenticationApi) {
    _startListeners();
  }

  final StreamController<BaseResponse> _supplierController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListSupplier => _supplierController.sink;
  Stream<BaseResponse> get listSupplier => _supplierController.stream;

  final StreamController<SupplierModel> _supplierDeleteController =
      StreamController<SupplierModel>.broadcast();
  Sink<SupplierModel> get deleteSupplier => _supplierDeleteController.sink;

  void _startListeners() {
    dbSupplierApi.getListSuppliers().listen((supplierDocs) {
      _addListSupplier.add(supplierDocs);
    });
    _supplierDeleteController.stream.listen((supplier) {
      dbSupplierApi.deleteSupplier(supplier);
    });
  }

  void dispose() {
    _supplierDeleteController.close();
    _supplierController.close();
  }
}
