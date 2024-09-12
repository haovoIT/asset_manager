import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/base_response.dart';

abstract class DbApi {
  Stream<BaseResponse?> getAssetsList({required idDepartment});
  Stream<BaseResponse?> getAssetsListKhauHao();
  Stream<BaseResponse?> getAssetsOfDepartment({required String idDepartment});
  Stream<BaseResponse?> getListAssetsID(
      {required String idDepartment, required String id});
  Stream<BaseResponse?> getAssetsStatus(
      {required String idDepartment, required String status});
  Future<BaseResponse?> getAssets({required String documentID});
  Future<BaseResponse?> addAssets({required AssetsModel assets});
  Future<BaseResponse?> updateAsset({required AssetsModel assets});
  Future<BaseResponse?> updateAssetWithTransaction(
      {required AssetsModel assets});
  Future<BaseResponse?> deleteAsset({required AssetsModel assets});
}
