import 'dart:async';

import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/services/db_asset_api.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_history_asset_api.dart';

class HomeBloc {
  final DbApi dbApi;
  final DbHistoryAssetApi dbHistoryAssetApi;
  final AuthenticationApi authenticationApi;

  HomeBloc(this.dbApi, this.dbHistoryAssetApi, this.authenticationApi) {
    _startListeners();
  }
  String? maQr;

  final StreamController<String> _tenTsController =
      StreamController<String>.broadcast();
  Sink<String> get tenTsEditChanged => _tenTsController.sink;
  Stream<String> get tenTsEdit => _tenTsController.stream;

  final StreamController<String> _maController =
      StreamController<String>.broadcast();
  Sink<String> get maEditChanged => _maController.sink;
  Stream<String> get maEdit => _maController.stream;

  final StreamController<String> _maPBController =
      StreamController<String>.broadcast();
  Sink<String> get maPBEditChanged => _maPBController.sink;
  Stream<String> get maPBEdit => _maPBController.stream;

  final StreamController<String> _tinhtrangController =
      StreamController<String>.broadcast();
  Sink<String> get tinhtrangEditChanged => _tinhtrangController.sink;
  Stream<String> get tinhtrangEdit => _tinhtrangController.stream;

  final StreamController<BaseResponse> _assetsController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListAssets => _assetsController.sink;
  Stream<BaseResponse> get listAssets => _assetsController.stream;

  final StreamController<BaseResponse> _assetIDController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListIDAssets => _assetIDController.sink;
  Stream<BaseResponse> get listIDAssets => _assetIDController.stream;

  final StreamController<BaseResponse> _assetTTController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListTTAssets => _assetTTController.sink;
  Stream<BaseResponse> get listTTAssets => _assetTTController.stream;

  final StreamController<BaseResponse> _assetsPBController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get _addListAssetsPB => _assetsPBController.sink;
  Stream<BaseResponse> get listAssetsPB => _assetsPBController.stream;

  //final StreamController<Assets> _assetController = StreamController<Assets>.broadcast();
  //Sink<Assets> get _addAssets => _assetController.sink;
  //Stream<Assets> get assets => _assetController.stream;

  final StreamController<AssetsModel> _assetsDeleteController =
      StreamController<AssetsModel>.broadcast();
  Sink<AssetsModel> get deleteAssets => _assetsDeleteController.sink;

  void _startListeners() {
    _maPBController.stream.listen((idDepartment) {
      dbApi.getAssetsList(idDepartment: idDepartment).listen((assetsDocs) {
        _addListAssets.add(assetsDocs!);
      });
    });

    /*dbApi.getAssetsListDSD().listen((assetsDocs) {
      _addListDSDAssets.add(assetsDocs);
    });

    dbApi.getAssetsListKhauHao().listen((assetsDocs) {
      _addListAssetsKH.add(assetsDocs);
    });*/

    _assetsDeleteController.stream.listen((assets) {
      dbApi.deleteAsset(assets: assets);
      //dbHistoryAssetApi.deleteHistoryAssetID(assets.qrCode ?? "");
    });

    _maController.stream.listen((maTs) {
      dbApi
          .getListAssetsID(
              idDepartment: maTs.substring(27, maTs.length),
              id: maTs.substring(0, 26))
          .listen((assets) {
        _addListIDAssets.add(assets!);
      });
    });

    _maPBController.stream.listen((idDepartment) {
      _tinhtrangController.stream.listen((status) {
        dbApi
            .getAssetsStatus(idDepartment: idDepartment, status: status)
            .listen((listAssetTT) {
          _addListTTAssets.add(listAssetTT!);
        });
      });
    });

    _maPBController.stream.listen((idDepartment) {
      dbApi
          .getAssetsOfDepartment(idDepartment: idDepartment)
          .listen((listAssetsPB) {
        _addListAssetsPB.add(listAssetsPB!);
      });
    });
  }

  void dispose() {
    _assetsDeleteController.close();
    _assetsController.close();
    _maController.close();
    _tenTsController.close();
    _assetIDController.close();
    _tinhtrangController.close();
    _assetTTController.close();
    _addListAssetsPB.close();
    _maPBController.close();
    _assetsPBController.close();
  }
}
