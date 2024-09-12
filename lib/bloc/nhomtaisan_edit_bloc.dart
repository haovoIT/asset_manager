import 'dart:async';

import 'package:assets_manager/models/nhomtaisan.dart';
import 'package:assets_manager/services/db_nhomtaisan_api.dart';

class NhomTaiSanEditBloc {
  final DbNhomTaiSanApi dbNhomTaiSanApi;
  final bool add;
  NhomTaiSan chonNhomTaiSan;

  NhomTaiSanEditBloc(this.add, this.dbNhomTaiSanApi, this.chonNhomTaiSan) {
    _startEditListeners()
        .then((finished) => _getNhomtaiSan(add, chonNhomTaiSan));
  }

  final StreamController<String> _tenNTSController =
      StreamController<String>.broadcast();
  Sink<String> get tenNTSEditChanged => _tenNTSController.sink;
  Stream<String> get tenNTSEdit => _tenNTSController.stream;

  final StreamController<String> _ddController =
      StreamController<String>.broadcast();
  Sink<String> get ddEditChanged => _ddController.sink;
  Stream<String> get ddEdit => _ddController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  _startEditListeners() async {
    _tenNTSController.stream.listen((tenNTS) {
      chonNhomTaiSan.TenNTS = tenNTS;
    });
    _ddController.stream.listen((dd) {
      chonNhomTaiSan.DD = dd;
    });

    _saveController.stream.listen((action) {
      if (action == "Save") {
        _luuNhomTaiSan();
      }
    });
  }

  void _getNhomtaiSan(bool add, NhomTaiSan nhomTaiSan) {
    if (add) {
      chonNhomTaiSan = NhomTaiSan();
      chonNhomTaiSan.TenNTS = '';
      chonNhomTaiSan.DD = '';
    } else {
      chonNhomTaiSan.TenNTS = nhomTaiSan.TenNTS;
      chonNhomTaiSan.DD = nhomTaiSan.DD;
    }
    tenNTSEditChanged.add(chonNhomTaiSan.TenNTS ?? "");
    ddEditChanged.add(chonNhomTaiSan.DD ?? "");
  }

  void _luuNhomTaiSan() {
    NhomTaiSan nhomTaiSan = NhomTaiSan(
      documentID: chonNhomTaiSan.documentID,
      TenNTS: chonNhomTaiSan.TenNTS,
      DD: chonNhomTaiSan.DD,
    );

    add
        ? dbNhomTaiSanApi.themNTS(nhomTaiSan)
        : dbNhomTaiSanApi.capnhatNTS(nhomTaiSan);
  }

  void dispose() {
    _tenNTSController.close();
    _ddController.close();
    _saveController.close();
  }
}
