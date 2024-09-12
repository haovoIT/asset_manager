import 'dart:async';

import 'package:assets_manager/models/kehoachkiemke.dart';
import 'package:assets_manager/services/db_kehoachkiemke_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KeHoachKiemKeEditBloc {
  final DbKHKKApi dbKHKKApi;
  final bool add;
  KeHoachKiemKe selectKeHoachKiemKe;

  KeHoachKiemKeEditBloc(this.add, this.dbKHKKApi, this.selectKeHoachKiemKe) {
    _startEditListeners()
        .then((finished) => _getKHKK(add, selectKeHoachKiemKe));
  }

  String? name = FirebaseAuth.instance.currentUser?.displayName;
  String? email = FirebaseAuth.instance.currentUser?.email;

  final StreamController<String> _maPbController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _maPbController.sink;
  Stream<String> get maPbEdit => _maPbController.stream;

  final StreamController<String> _ngayKKController =
      StreamController<String>.broadcast();
  Sink<String> get ngayKKEditChanged => _ngayKKController.sink;
  Stream<String> get ngayKKEdit => _ngayKKController.stream;

  final StreamController<List<String>> _assetsController =
      StreamController<List<String>>.broadcast();
  Sink<List<String>> get listAssetsEditChanged => _assetsController.sink;
  Stream<List<String>> get listAssetsEdit => _assetsController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  _startEditListeners() async {
    _maPbController.stream.listen((maPb) {
      selectKeHoachKiemKe.Ma_pb = maPb;
    });
    _ngayKKController.stream.listen((ngayKK) {
      selectKeHoachKiemKe.Ngay_KK = ngayKK;
    });
    _assetsController.stream.listen((listKHKK) {
      selectKeHoachKiemKe.list = listKHKK;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _saveKHKK();
      }
    });
  }

  void _getKHKK(bool add, KeHoachKiemKe keHoachKiemKe) {
    if (add) {
      selectKeHoachKiemKe = KeHoachKiemKe();
      selectKeHoachKiemKe.Ngay_KK = DateTime.now().toString();
      selectKeHoachKiemKe.Ma_pb = keHoachKiemKe.Ma_pb;
      selectKeHoachKiemKe.list = keHoachKiemKe.list;
    } else {
      selectKeHoachKiemKe.Ngay_KK = keHoachKiemKe.Ngay_KK;
      selectKeHoachKiemKe.Ma_pb = keHoachKiemKe.Ma_pb;
      selectKeHoachKiemKe.list = keHoachKiemKe.list;
    }
    ngayKKEditChanged.add(selectKeHoachKiemKe.Ngay_KK??"");
    maPbEditChanged.add(selectKeHoachKiemKe.Ma_pb??"");
    listAssetsEditChanged.add(selectKeHoachKiemKe.list??[]);
  }

  void _saveKHKK() {
    KeHoachKiemKe keHoachKiemKe = KeHoachKiemKe(
      documentID: selectKeHoachKiemKe.documentID,
      Ngay_KK: selectKeHoachKiemKe.Ngay_KK,
      Ma_pb: selectKeHoachKiemKe.Ma_pb,
      list: selectKeHoachKiemKe.list,
      Name: name ?? "",
      Email: email ?? "",
    );
    add
        ? dbKHKKApi.addKHKK(keHoachKiemKe)
        : dbKHKKApi.updateKHKK(keHoachKiemKe);
  }

  void dispose() {
    _maPbController.close();
    _ngayKKController.close();
    _assetsController.close();
    _saveController.close();
  }
}
