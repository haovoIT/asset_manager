import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/contract_model.dart';

abstract class DbCtApi {
  Stream<BaseResponse?> getContractList();
  Future<BaseResponse?> addContract(Contract contract);
  Future<BaseResponse?> updateContract(Contract contract);
  Future<BaseResponse?> deleteContract(Contract contract);
}
