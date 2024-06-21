import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/supplier_model.dart';

abstract class DbSupplierApi {
  Stream<BaseResponse> getListSuppliers();
  Future<BaseResponse> addSupplier(SupplierModel supplierModel);
  Future<BaseResponse> updateSupplier(SupplierModel supplierModel);
  Future<BaseResponse> deleteSupplier(SupplierModel supplierModel);
}
