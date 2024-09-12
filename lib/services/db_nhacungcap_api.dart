import 'package:assets_manager/models/nhacungcap.dart';

abstract class DbNhaCungCapApi{
  Stream<List<NhaCungCap>> DanhSachNhaCungCap();
  Future<bool> ThemNhaCungCap(NhaCungCap nhaCungCap);
  void CapNhatNhaCungCap(NhaCungCap nhaCungCap);
  void XoaNhaCungCap(NhaCungCap nhaCungCap);
}