import 'dart:async';

import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/supplier_model.dart';
import 'package:assets_manager/services/db_supplier_api.dart';

class SupplierEditBloc {
  final DbSupplierApi dbSupplierApi;
  final bool add;
  SupplierModel selectSupplier;

  SupplierEditBloc(
      {required this.add,
      required this.dbSupplierApi,
      required this.selectSupplier}) {
    _startEditListeners()
        .then((finished) => _getNhaCungCap(add, selectSupplier));
  }

  final StreamController<String> _nameController =
      StreamController<String>.broadcast();
  Sink<String> get nameEditChanged => _nameController.sink;
  Stream<String> get nameEdit => _nameController.stream;

  final StreamController<String> _addressController =
      StreamController<String>.broadcast();
  Sink<String> get addressEditChanged => _addressController.sink;
  Stream<String> get addressEdit => _addressController.stream;

  final StreamController<String> _phoneController =
      StreamController<String>.broadcast();
  Sink<String> get phoneEditChanged => _phoneController.sink;
  Stream<String> get phoneEdit => _phoneController.stream;

  final StreamController<String> _emailController =
      StreamController<String>.broadcast();
  Sink<String> get emailEditChanged => _emailController.sink;
  Stream<String> get emailEdit => _emailController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  final StreamController<BaseResponse> _responseController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get responseEditChanged => _responseController.sink;
  Stream<BaseResponse> get responseEdit => _responseController.stream;

  /*final StreamController<String> _Controller = StreamController<String>.broadcast();
  Sink<String> get EditChanged => _Controller.sink;
  Stream<String> get Edit => _Controller.stream;*/

  _startEditListeners() async {
    _nameController.stream.listen((name) {
      selectSupplier.name = name;
    });
    _addressController.stream.listen((address) {
      selectSupplier.address = address;
    });

    _phoneController.stream.listen((phone) {
      selectSupplier.phone = phone;
    });

    _emailController.stream.listen((email) {
      selectSupplier.email = email;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _luuNhaCungCap();
      }
    });
  }

  void _getNhaCungCap(bool add, SupplierModel supplierModel) {
    if (add) {
      selectSupplier = SupplierModel();
      selectSupplier.name = '';
      selectSupplier.address = '';
      selectSupplier.phone = '';
      selectSupplier.email = '';
    } else {
      selectSupplier.name = supplierModel.name;
      selectSupplier.address = supplierModel.address;
      selectSupplier.phone = supplierModel.phone;
      selectSupplier.email = supplierModel.email;
    }
    nameEditChanged.add(selectSupplier.name ?? "");
    addressEditChanged.add(selectSupplier.address ?? "");
    phoneEditChanged.add(selectSupplier.phone ?? "");
    emailEditChanged.add(selectSupplier.email ?? "");
  }

  void _luuNhaCungCap() async {
    SupplierModel supplierModel = SupplierModel(
        documentID: selectSupplier.documentID,
        name: selectSupplier.name,
        address: selectSupplier.address,
        phone: selectSupplier.phone,
        email: selectSupplier.email);

    if (add) {
      final response = await dbSupplierApi.addSupplier(supplierModel);
      responseEditChanged.add(response);
    } else {
      final response = await dbSupplierApi.updateSupplier(supplierModel);
      responseEditChanged.add(response);
    }
  }

  void dispose() {
    _nameController.close();
    _addressController.close();
    _phoneController.close();
    _emailController.close();
    _saveController.close();
    _responseController.close();
  }
}
