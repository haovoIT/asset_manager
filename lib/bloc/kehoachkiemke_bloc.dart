import 'dart:async';

import 'package:assets_manager/models/kehoachkiemke.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_kehoachkiemke_api.dart';

class KeHoachKiemKeBloc {
  final DbKHKKApi dbKHKKApi;
  final AuthenticationApi authenticationApi;

  KeHoachKiemKeBloc(this.dbKHKKApi, this.authenticationApi) {
    _starListenner();
  }
  final StreamController<String> _maPBController =
      StreamController<String>.broadcast();
  Sink<String> get maPBEditChanged => _maPBController.sink;
  Stream<String> get maPBEdit => _maPBController.stream;

  final StreamController<List<KeHoachKiemKe>> _dsKeHoachKiemKeController =
      StreamController<List<KeHoachKiemKe>>.broadcast();
  Sink<List<KeHoachKiemKe>> get _themDSKeHoachKiemKe =>
      _dsKeHoachKiemKeController.sink;
  Stream<List<KeHoachKiemKe>> get dsKeHoachKiemKe =>
      _dsKeHoachKiemKeController.stream;

  final StreamController<KeHoachKiemKe> _xoaKHKKController =
      StreamController<KeHoachKiemKe>.broadcast();
  Sink<KeHoachKiemKe> get xoaKHKK => _xoaKHKKController.sink;

  void _starListenner() {
    _maPBController.stream.listen((maPB) {
      dbKHKKApi.getKHKKList(maPB).listen((khkkDoc) {
        _themDSKeHoachKiemKe.add(khkkDoc);
      });
    });

    _xoaKHKKController.stream.listen((khkk) {
      dbKHKKApi.deleteKHKK(khkk);
    });
  }

  void dispose() {
    _dsKeHoachKiemKeController.close();
    _xoaKHKKController.close();
    _maPBController.close();
  }
}
