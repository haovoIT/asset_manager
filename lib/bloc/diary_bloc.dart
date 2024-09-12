import 'dart:async';

import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/services/db_asset_api.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_diary_api.dart';

class DiaryBloc {
  final DbDiaryApi dbDiaryApi;
  final DbApi dbApi;
  final AuthenticationApi authenticationApi;

  DiaryBloc(this.dbDiaryApi, this.authenticationApi, this.dbApi) {
    _starListeners();
  }

  final StreamController<String> _idAssetController =
      StreamController<String>.broadcast();
  Sink<String> get idAssetEditChanged => _idAssetController.sink;
  Stream<String> get idAssetEdit => _idAssetController.stream;

  final StreamController<String> _idDepartmentController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _idDepartmentController.sink;
  Stream<String> get maPbEdit => _idDepartmentController.stream;

  final StreamController<BaseResponse> _listDiaryController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get addListDiary => _listDiaryController.sink;
  Stream<BaseResponse> get listDiaryModel => _listDiaryController.stream;

  final StreamController<AssetsModel> _assetsController =
      StreamController<AssetsModel>.broadcast();
  Sink<AssetsModel> get addAssets => _assetsController.sink;
  Stream<AssetsModel> get assets => _assetsController.stream;

  void _starListeners() {
    _idAssetController.stream.listen((idAsset) async {
      dbDiaryApi.getDiaryList(idAsset).listen((listDiary) {
        addListDiary.add(listDiary);
      });
      final response = await dbApi.getAssets(documentID: idAsset);
      addAssets.add(response?.data);
    });
  }

  void dispose() {
    _idAssetController.close();
    _idDepartmentController.close();
    _listDiaryController.close();
    _assetsController.close();
  }
}
