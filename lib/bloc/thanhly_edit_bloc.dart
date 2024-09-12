import 'dart:async';

import 'package:assets_manager/models/thanhly.dart';
import 'package:assets_manager/services/db_thanhly_api.dart';

class ThanhLyEditBloc {
  final DbTLApi dbTLApi;
  final bool add;
  ThanhLy chonThanhLy;

  ThanhLyEditBloc(this.dbTLApi, this.add, this.chonThanhLy) {
    _startEditListeners().then((finished) => _getThanhLy(add, chonThanhLy));
  }

  final StreamController<String> _tenTsController =
      StreamController<String>.broadcast();
  Sink<String> get tenTsEditChanged => _tenTsController.sink;
  Stream<String> get tenTsEdit => _tenTsController.stream;

  final StreamController<String> _maPbController =
      StreamController<String>.broadcast();
  Sink<String> get maPbEditChanged => _maPbController.sink;
  Stream<String> get maPbEdit => _maPbController.stream;

  final StreamController<String> _donViTLController =
      StreamController<String>.broadcast();
  Sink<String> get donViTLEditChanged => _donViTLController.sink;
  Stream<String> get donViTLEdit => _donViTLController.stream;

  final StreamController<String> _nguyenGiaTLController =
      StreamController<String>.broadcast();
  Sink<String> get nguyenGiaTLEditChanged => _nguyenGiaTLController.sink;
  Stream<String> get nguyenGiaTLEdit => _nguyenGiaTLController.stream;

  final StreamController<String> _ngayTLController =
      StreamController<String>.broadcast();
  Sink<String> get ngayTLEditChanged => _ngayTLController.sink;
  Stream<String> get ngayTLEdit => _ngayTLController.stream;

  final StreamController<String> _saveController =
      StreamController<String>.broadcast();
  Sink<String> get saveEditChanged => _saveController.sink;
  Stream<String> get saveEdit => _saveController.stream;

  _startEditListeners() async {
    _tenTsController.stream.listen((tenTs) {
      chonThanhLy.Ten_ts = tenTs;
    });
    _maPbController.stream.listen((maPb) {
      chonThanhLy.Ma_pb = maPb;
    });
    _donViTLController.stream.listen((dv) {
      chonThanhLy.Don_vi_TL = dv;
    });
    _nguyenGiaTLController.stream.listen((ng) {
      chonThanhLy.Nguyen_gia_TL = ng;
    });
    _ngayTLController.stream.listen((ngayTL) {
      chonThanhLy.Ngay_TL = ngayTL;
    });
    _saveController.stream.listen((action) {
      if (action == "Save") {
        _luuThanhLy();
      }
    });
  }

  void _getThanhLy(bool add, ThanhLy thanhLy) {
    if (add) {
      chonThanhLy = ThanhLy();
      chonThanhLy.documentID = thanhLy.documentID;
      chonThanhLy.Ten_ts = thanhLy.Ten_ts;
      chonThanhLy.Ma_pb = thanhLy.Ma_pb;
      chonThanhLy.Don_vi_TL = thanhLy.Don_vi_TL;
      chonThanhLy.Nguyen_gia_TL = thanhLy.Nguyen_gia_TL;
      chonThanhLy.Ngay_TL = DateTime.now().toString();
    } else {
      chonThanhLy.Ten_ts = thanhLy.Ten_ts;
      chonThanhLy.Ma_pb = thanhLy.Ma_pb;
      chonThanhLy.Don_vi_TL = thanhLy.Don_vi_TL;
      chonThanhLy.Nguyen_gia_TL = thanhLy.Nguyen_gia_TL;
      chonThanhLy.Ngay_TL = thanhLy.Ngay_TL;
    }
    tenTsEditChanged.add(chonThanhLy.Ten_ts ?? "");
    maPbEditChanged.add(chonThanhLy.Ma_pb ?? "");
    donViTLEditChanged.add(chonThanhLy.Don_vi_TL ?? "");
    nguyenGiaTLEditChanged.add(chonThanhLy.Nguyen_gia_TL ?? "");
    ngayTLEditChanged.add(chonThanhLy.Ngay_TL ?? "");
  }

  void _luuThanhLy() {
    ThanhLy thanhLy = ThanhLy(
        documentID: chonThanhLy.documentID,
        Ten_ts: chonThanhLy.Ten_ts,
        Ma_pb: chonThanhLy.Ma_pb,
        Don_vi_TL: chonThanhLy.Don_vi_TL,
        Nguyen_gia_TL: chonThanhLy.Nguyen_gia_TL,
        Ngay_TL: chonThanhLy.Ngay_TL);
    add ? dbTLApi.addThanhLy(thanhLy) : dbTLApi.updateThanhLy(thanhLy);
  }

  void dispose() {
    _tenTsController.close();
    _maPbController.close();
    _donViTLController.close();
    _ngayTLController.close();
    _nguyenGiaTLController.close();
    _saveController.close();
  }
}
