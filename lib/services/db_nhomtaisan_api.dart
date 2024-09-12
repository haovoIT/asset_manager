import 'package:assets_manager/models/nhomtaisan.dart';

abstract class DbNhomTaiSanApi{
  Stream<List<NhomTaiSan>> danhsachNhomTS();
  Future<bool> themNTS(NhomTaiSan NhomTS);
  void capnhatNTS(NhomTaiSan NhomTS);
  void xoaNTS(NhomTaiSan NhomTS);
}