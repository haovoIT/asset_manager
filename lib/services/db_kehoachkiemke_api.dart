import 'package:assets_manager/models/kehoachkiemke.dart';

abstract class DbKHKKApi{
  Stream<List<KeHoachKiemKe>> getKHKKList(String maPb);
  Future<bool> addKHKK(KeHoachKiemKe keHoachKiemKe);
  void updateKHKK(KeHoachKiemKe keHoachKiemKe);
  void deleteKHKK(KeHoachKiemKe keHoachKiemKe);
}