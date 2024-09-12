import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/history_asset_model.dart';

abstract class DbHistoryAssetApi {
  Stream<BaseResponse> getHistoryAsset(String idAsset);
  Future<BaseResponse> addHistoryAsset(HistoryAssetModel historyAssetModel);
}
