import 'dart:async';

import 'package:assets_manager/models/nhacungcap.dart';
import 'package:assets_manager/services/db_nhacungcap_api.dart';

class NhaCungCapEditBloc {
  final DbNhaCungCapApi dbNhaCungCapApi;
  final bool add;
  NhaCungCap chonNhaCungCap;

  NhaCungCapEditBloc(this.add, this.dbNhaCungCapApi, this.chonNhaCungCap) {
    _startEditListeners()
        .then((finished) => _getNhaCungCap(add, chonNhaCungCap));
  }

  final StreamController<String> _tenNCCController =
      StreamController<String>.broadcast();
  Sink<String> get tenNCCEditChanged => _tenNCCController.sink;
  Stream<String> get tenNCCEdit => _tenNCCController.stream;

  final StreamController<String> _dcController =
      StreamController<String>.broadcast();
  Sink<String> get dcEditChanged => _dcController.sink;
  Stream<String> get dcEdit => _dcController.stream;

  final StreamController<String> _sdtController =
      StreamController<String>.broadcast();
  Sink<String> get sdtEditChanged => _sdtController.sink;
  Stream<String> get sdtEdit => _sdtController.stream;

  final StreamController<String> _emailController =
      StreamController<String>.broadcast();
  Sink<String> get emailEditChanged => _emailController.sink;
  Stream<String> get emailEdit => _emailController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  /*final StreamController<String> _Controller = StreamController<String>.broadcast();
  Sink<String> get EditChanged => _Controller.sink;
  Stream<String> get Edit => _Controller.stream;*/

  _startEditListeners() async {
    _tenNCCController.stream.listen((tenNCC) {
      chonNhaCungCap.TenNCC = tenNCC;
    });
    _dcController.stream.listen((dc) {
      chonNhaCungCap.DC = dc;
    });

    _sdtController.stream.listen((sdt) {
      chonNhaCungCap.SDT = sdt;
    });

    _emailController.stream.listen((email) {
      chonNhaCungCap.Email = email;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _luuNhaCungCap();
      }
    });
  }

  void _getNhaCungCap(bool add, NhaCungCap nhaCungCap) {
    if (add) {
      chonNhaCungCap = NhaCungCap();
      chonNhaCungCap.TenNCC = '';
      chonNhaCungCap.DC = '';
      chonNhaCungCap.SDT = '';
      chonNhaCungCap.Email = '';
    } else {
      chonNhaCungCap.TenNCC = nhaCungCap.TenNCC;
      chonNhaCungCap.DC = nhaCungCap.DC;
      chonNhaCungCap.SDT = nhaCungCap.SDT;
      chonNhaCungCap.Email = nhaCungCap.Email;
    }
    tenNCCEditChanged.add(chonNhaCungCap.TenNCC ?? "");
    dcEditChanged.add(chonNhaCungCap.DC ?? "");
    sdtEditChanged.add(chonNhaCungCap.SDT ?? "");
    emailEditChanged.add(chonNhaCungCap.Email ?? "");
  }

  void _luuNhaCungCap() {
    NhaCungCap nhaCungCap = NhaCungCap(
        documentID: chonNhaCungCap.documentID,
        TenNCC: chonNhaCungCap.TenNCC,
        DC: chonNhaCungCap.DC,
        SDT: chonNhaCungCap.SDT,
        Email: chonNhaCungCap.Email);

    add
        ? dbNhaCungCapApi.ThemNhaCungCap(nhaCungCap)
        : dbNhaCungCapApi.CapNhatNhaCungCap(nhaCungCap);
  }

  void dispose() {
    _tenNCCController.close();
    _dcController.close();
    _sdtController.close();
    _emailController.close();
    _saveController.close();
  }
}
