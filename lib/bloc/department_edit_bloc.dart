import 'dart:async';

import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/department_model.dart';
import 'package:assets_manager/services/db_department_api.dart';

class DepartmentEditBloc {
  final DbDepartmentApi dbDpmApi;
  final bool add;
  DepartmentModel selectDepartment;

  DepartmentEditBloc(this.add, this.dbDpmApi, this.selectDepartment) {
    _startEditListeners()
        .then((finished) => _getDepartment(add, selectDepartment));
  }

  final StreamController<String> _codeController =
      StreamController<String>.broadcast();
  Sink<String> get codeEditChanged => _codeController.sink;
  Stream<String> get codeEdit => _codeController.stream;

  final StreamController<String> _nameController =
      StreamController<String>.broadcast();
  Sink<String> get nameEditChanged => _nameController.sink;
  Stream<String> get nameEdit => _nameController.stream;

  final StreamController<String> _phoneController =
      StreamController<String>.broadcast();
  Sink<String> get phoneEditChanged => _phoneController.sink;
  Stream<String> get phoneEdit => _phoneController.stream;

  final StreamController<String> _addressController =
      StreamController<String>.broadcast();
  Sink<String> get addressEditChanged => _addressController.sink;
  Stream<String> get addressEdit => _addressController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  final StreamController<BaseResponse> _responseAddController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get responseAddEditChanged => _responseAddController.sink;
  Stream<BaseResponse> get responseAddEdit => _responseAddController.stream;

  _startEditListeners() async {
    _nameController.stream.listen((name) {
      selectDepartment.name = name;
    });
    _codeController.stream.listen((code) {
      selectDepartment.code = code;
    });
    _phoneController.stream.listen((phone) {
      selectDepartment.phone = phone;
    });
    _addressController.stream.listen((address) {
      selectDepartment.address = address;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveDepartment();
      }
    });
  }

  void _getDepartment(bool add, DepartmentModel department) {
    if (add) {
      selectDepartment = DepartmentModel();
      selectDepartment.name = '';
      selectDepartment.phone = '';
      selectDepartment.address = '';
      selectDepartment.code = '';
    } else {
      selectDepartment.name = department.name;
      selectDepartment.phone = department.phone;
      selectDepartment.address = department.address;
      selectDepartment.code = department.code;
    }
    nameEditChanged.add(selectDepartment.name ?? "");
    phoneEditChanged.add(selectDepartment.phone ?? "");
    addressEditChanged.add(selectDepartment.address ?? "");
    codeEditChanged.add(selectDepartment.code ?? "");
  }

  void _saveDepartment() async {
    if (add) {
      DepartmentModel department = DepartmentModel(
        documentID: selectDepartment.documentID,
        name: selectDepartment.name,
        phone: selectDepartment.phone,
        address: selectDepartment.address,
        code: selectDepartment.code,
        status: "0",
        dateCreate: DateTime.now().toString(),
      );
      final response =
          await dbDpmApi.addDepartment(departmentModel: department);
      responseAddEditChanged.add(response!);
    } else {
      DepartmentModel department = DepartmentModel(
        documentID: selectDepartment.documentID,
        name: selectDepartment.name,
        phone: selectDepartment.phone,
        address: selectDepartment.address,
        code: selectDepartment.code,
        status: selectDepartment.status,
        dateCreate: selectDepartment.dateCreate,
      );
      final response =
          await dbDpmApi.updateDepartment(departmentModel: department);
      responseAddEditChanged.add(response!);
    }
  }

  void dispose() {
    _nameController.close();
    _phoneController.close();
    _addressController.close();
    _saveController.close();
    _codeController.close();
    _responseAddController.close();
  }
}
