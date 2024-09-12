import 'dart:async';

import 'package:assets_manager/models/nhacungcap.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:assets_manager/services/db_nhacungcap_api.dart';

class NhaCungCapBloc {
  final DbNhaCungCapApi dbNhaCungCapApi;
  final AuthenticationApi authenticationApi;

  NhaCungCapBloc(this.dbNhaCungCapApi, this.authenticationApi) {
    _startListeners();
  }

  final StreamController<List<NhaCungCap>> _nhaCungCapController =
      StreamController<List<NhaCungCap>>.broadcast();
  Sink<List<NhaCungCap>> get _addListNhaCungCap => _nhaCungCapController.sink;
  Stream<List<NhaCungCap>> get listNhaCungCap => _nhaCungCapController.stream;

  final StreamController<NhaCungCap> _nhaCungCapDeleteController =
      StreamController<NhaCungCap>.broadcast();
  Sink<NhaCungCap> get deleteNhaCungCap => _nhaCungCapDeleteController.sink;

  void _startListeners() {
    dbNhaCungCapApi.DanhSachNhaCungCap().listen((nhaCungCapDocs) {
      _addListNhaCungCap.add(nhaCungCapDocs);
    });
    _nhaCungCapDeleteController.stream.listen((nhaCungCap) {
      dbNhaCungCapApi.XoaNhaCungCap(nhaCungCap);
    });
  }

  void dispose() {
    _nhaCungCapDeleteController.close();
    _nhaCungCapController.close();
  }
}
