import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/diary_model.dart';

abstract class DbDiaryApi {
  Stream<BaseResponse> getDiaryList(String idAsset);
  Future<BaseResponse> addDiaryModel(DiaryModel diaryModel);
  Future<BaseResponse> updateDiaryModel(DiaryModel diaryModel);
  Future<BaseResponse> deleteDiaryModel(DiaryModel diaryModel);
}
