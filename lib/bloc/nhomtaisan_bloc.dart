import 'dart:async';

import 'package:assets_manager/models/nhomtaisan.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_nhomtaisan_api.dart';

class NhomTaiSanBloc {
  final DbNhomTaiSanApi dbNhomTaiSanApi;
  final AuthenticationApi authenticationApi;

  NhomTaiSanBloc(this.dbNhomTaiSanApi, this.authenticationApi) {
    _starListenner();
  }

  final StreamController<List<NhomTaiSan>> _dsNhomTaiSanController =
      StreamController<List<NhomTaiSan>>.broadcast();
  Sink<List<NhomTaiSan>> get _themDSNhomTaiSan => _dsNhomTaiSanController.sink;
  Stream<List<NhomTaiSan>> get dsNhomTaiSan => _dsNhomTaiSanController.stream;

  final StreamController<NhomTaiSan> _xoaNTSController =
      StreamController<NhomTaiSan>.broadcast();
  Sink<NhomTaiSan> get xoaNTS => _xoaNTSController.sink;

  void _starListenner() {
    dbNhomTaiSanApi.danhsachNhomTS().listen((ntsDoc) {
      _themDSNhomTaiSan.add(ntsDoc);
    });
    _xoaNTSController.stream.listen((nts) {
      dbNhomTaiSanApi.xoaNTS(nts);
    });
  }

  void dispose() {
    _dsNhomTaiSanController.close();
    _xoaNTSController.close();
  }
}
