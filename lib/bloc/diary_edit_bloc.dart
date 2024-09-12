import 'dart:async';

import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/base_response.dart';
import 'package:assets_manager/models/diary_model.dart';
import 'package:assets_manager/services/service_index.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiaryEditBloc {
  final DbDiaryApi dbDiaryApi;
  final DbApi dbApi;
  final bool add;
  DiaryModel selectDiaryModel;

  DiaryEditBloc(
      {required this.dbDiaryApi,
      required this.add,
      required this.dbApi,
      required this.selectDiaryModel}) {
    _startEditListeners()
        .then((finished) => _getDiaryModel(add, selectDiaryModel));
  }
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  String idDepartment = '';
  String name = '';
  String? email = FirebaseAuth.instance.currentUser?.email;

  final StreamController<String> _nameAssetController =
      StreamController<String>.broadcast();
  Sink<String> get nameAssetEditChanged => _nameAssetController.sink;
  Stream<String> get nameAssetEdit => _nameAssetController.stream;

  final StreamController<String> _idDepartmentController =
      StreamController<String>.broadcast();
  Sink<String> get idDepartmentEditChanged => _idDepartmentController.sink;
  Stream<String> get idDepartmentEdit => _idDepartmentController.stream;

  final StreamController<String> _originalPriceController =
      StreamController<String>.broadcast();
  Sink<String> get originalPriceEditChanged => _originalPriceController.sink;
  Stream<String> get originalPriceEdit => _originalPriceController.stream;

  final StreamController<String> _usedTimeController =
      StreamController<String>.broadcast();
  Sink<String> get usedTimeEditChanged => _usedTimeController.sink;
  Stream<String> get usedTimeEdit => _usedTimeController.stream;

  final StreamController<String> _starDateController =
      StreamController<String>.broadcast();
  Sink<String> get starDateEditChanged => _starDateController.sink;
  Stream<String> get starDateEdit => _starDateController.stream;

  final StreamController<String> _endDateController =
      StreamController<String>.broadcast();
  Sink<String> get endDateEditChanged => _endDateController.sink;
  Stream<String> get endDateEdit => _endDateController.stream;

  final StreamController<String> _qrCodeController =
      StreamController<String>.broadcast();
  Sink<String> get qrCodeEditChanged => _qrCodeController.sink;
  Stream<String> get qrCodeEdit => _qrCodeController.stream;

  final StreamController<String> _detailController =
      StreamController<String>.broadcast();
  Sink<String> get detailEditChanged => _detailController.sink;
  Stream<String> get detailEdit => _detailController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  final StreamController<String> _depreciationController =
      StreamController<String>.broadcast();
  Sink<String> get depreciationEditChanged => _depreciationController.sink;
  Stream<String> get depreciationEdit => _depreciationController.stream;

  final StreamController<BaseResponse> _responseController =
      StreamController<BaseResponse>.broadcast();
  Sink<BaseResponse> get responseEditChanged => _responseController.sink;
  Stream<BaseResponse> get responseEdit => _responseController.stream;

  _startEditListeners() async {
    _nameAssetController.stream.listen((nameAsset) {
      selectDiaryModel.nameAsset = nameAsset;
    });
    _idDepartmentController.stream.listen((idDepartment) {
      selectDiaryModel.idDepartment = idDepartment;
    });

    _originalPriceController.stream.listen((originalPrice) {
      selectDiaryModel.originalPrice = originalPrice;
    });
    _usedTimeController.stream.listen((usedTime) {
      selectDiaryModel.usedTime = usedTime;
    });

    _starDateController.stream.listen((starDate) {
      selectDiaryModel.starDate = starDate;
    });
    _endDateController.stream.listen((endDate) {
      selectDiaryModel.endDate = endDate;
    });

    _depreciationController.stream.listen((depreciation) {
      selectDiaryModel.depreciation = depreciation;
    });

    _qrCodeController.stream.listen((qrCode) {
      selectDiaryModel.qrCode = qrCode;
    });

    _detailController.stream.listen((detail) {
      selectDiaryModel.detail = detail;
    });

    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveDiaryModel();
      }
    });
  }

  void _getDiaryModel(bool add, DiaryModel diaryModel) {
    if (add) {
      selectDiaryModel = DiaryModel();
      selectDiaryModel.qrCode = diaryModel.qrCode;
      selectDiaryModel.nameAsset = diaryModel.nameAsset;
      selectDiaryModel.idAsset = diaryModel.idAsset;
      selectDiaryModel.dateCreate = diaryModel.dateCreate;
      selectDiaryModel.idDepartment = diaryModel.idDepartment;
      selectDiaryModel.usedTime = diaryModel.usedTime;
      selectDiaryModel.originalPrice = diaryModel.originalPrice;
      selectDiaryModel.starDate = diaryModel.starDate;
      selectDiaryModel.endDate = diaryModel.endDate;
      selectDiaryModel.depreciation = diaryModel.depreciation;
      selectDiaryModel.detail = "";
      selectDiaryModel.userName = diaryModel.userName;
      selectDiaryModel.userEmail = diaryModel.userEmail;
      selectDiaryModel.dateUpdate = diaryModel.dateUpdate;
    } else {
      selectDiaryModel.qrCode = diaryModel.qrCode;
      selectDiaryModel.nameAsset = diaryModel.nameAsset;
      selectDiaryModel.idAsset = diaryModel.idAsset;
      selectDiaryModel.dateCreate = diaryModel.dateCreate;
      selectDiaryModel.idDepartment = diaryModel.idDepartment;
      selectDiaryModel.usedTime = diaryModel.usedTime;
      selectDiaryModel.originalPrice = diaryModel.originalPrice;
      selectDiaryModel.starDate = diaryModel.starDate;
      selectDiaryModel.endDate = diaryModel.endDate;
      selectDiaryModel.depreciation = diaryModel.depreciation;
      selectDiaryModel.detail = "";
      selectDiaryModel.userName = diaryModel.userName;
      selectDiaryModel.userEmail = diaryModel.userEmail;
      selectDiaryModel.dateUpdate = diaryModel.dateUpdate;
    }
    nameAssetEditChanged.add(selectDiaryModel.nameAsset ?? "");
    idDepartmentEditChanged.add(selectDiaryModel.idDepartment ?? "");
    originalPriceEditChanged.add(selectDiaryModel.originalPrice ?? "");
    usedTimeEditChanged.add(selectDiaryModel.usedTime ?? "");
    starDateEditChanged.add(selectDiaryModel.starDate ?? "");
    endDateEditChanged.add(selectDiaryModel.endDate ?? "");
    depreciationEditChanged.add(selectDiaryModel.depreciation ?? "");
    qrCodeEditChanged.add(selectDiaryModel.qrCode ?? "");
    detailEditChanged.add(selectDiaryModel.detail ?? "");
  }

  void _saveDiaryModel() async {
    idDepartment =
        displayName!.length > 20 ? displayName!.substring(0, 20) : '';
    name = displayName!.length > 20
        ? displayName!.substring(21, displayName!.length)
        : displayName!;
    DiaryModel diaryModel = DiaryModel(
        qrCode: selectDiaryModel.qrCode,
        dateCreate: DateTime.now().toString(),
        idAsset: selectDiaryModel.idAsset,
        nameAsset: selectDiaryModel.nameAsset,
        idDepartment: selectDiaryModel.idDepartment,
        usedTime: selectDiaryModel.usedTime,
        originalPrice: selectDiaryModel.originalPrice,
        starDate: selectDiaryModel.starDate,
        endDate: selectDiaryModel.endDate,
        depreciation: selectDiaryModel.depreciation,
        detail: selectDiaryModel.detail,
        userName: name,
        userEmail: email ?? "",
        dateUpdate: DateTime.now().toString());
    final responseAddDiary = await dbDiaryApi.addDiaryModel(diaryModel);
    if (responseAddDiary.status == 0) {
      final response =
          await dbApi.getAssets(documentID: selectDiaryModel.idAsset ?? "");
      if (response?.status == 0) {
        AssetsModel assetsModel = response?.data;

        assetsModel.documentID = selectDiaryModel.idAsset;
        assetsModel.originalPrice = selectDiaryModel.originalPrice;
        assetsModel.usedTime = selectDiaryModel.usedTime;
        assetsModel.endDate = selectDiaryModel.endDate;
        assetsModel.depreciation = selectDiaryModel.depreciation;
        final responseUpdateAsset =
            await dbApi.updateAssetWithTransaction(assets: assetsModel);
        responseEditChanged.add(responseUpdateAsset!);
      }
    } else {
      responseEditChanged.add(responseAddDiary);
    }
  }

  void dispose() {
    _nameAssetController.close();
    _idDepartmentController.close();
    _originalPriceController.close();
    _usedTimeController.close();
    _depreciationController.close();
    _starDateController.close();
    _endDateController.close();
    _qrCodeController.close();
    _saveController.close();
    _detailController.close();
    _responseController.close();
  }
}
