import 'dart:async';

import 'package:assets_manager/models/thanhly.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_thanhly_api.dart';

class ThanhLyBloc {
  final DbTLApi dbTLApi;
  final AuthenticationApi authenticationApi;

  ThanhLyBloc(this.dbTLApi, this.authenticationApi) {
    _starListeners();
  }

  final StreamController<List<ThanhLy>> _thanhLyController =
      StreamController<List<ThanhLy>>.broadcast();
  Sink<List<ThanhLy>> get _addThanhLy => _thanhLyController.sink;
  Stream<List<ThanhLy>> get dsThanhLy => _thanhLyController.stream;

  final StreamController<String> _maPbController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _maPbController.sink;
  Stream<String> get maPbEdit => _maPbController.stream;

  final StreamController<ThanhLy> _thanhLyDeleteController =
      StreamController<ThanhLy>.broadcast();
  Sink<ThanhLy> get deleteThanhLy => _thanhLyDeleteController.sink;

  void _starListeners() {
    _maPbController.stream.listen((maPb) {
      dbTLApi.getThanhLyList(maPb).listen((thanhLy) {
        _addThanhLy.add(thanhLy);
      });
    });

    _thanhLyDeleteController.stream.listen((thanhLy) {
      dbTLApi.deleteThanhLy(thanhLy);
    });
  }

  void dispose() {
    _maPbController.close();
    _thanhLyController.close();
    _thanhLyDeleteController.close();
  }
}
