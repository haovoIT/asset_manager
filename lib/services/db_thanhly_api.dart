import 'package:assets_manager/models/thanhly.dart';

abstract class DbTLApi{
  Stream<List<ThanhLy>> getThanhLyList(String maPb);
  Future<bool> addThanhLy(ThanhLy thanhLy);
  void updateThanhLy(ThanhLy thanhLy);
  void deleteThanhLy(ThanhLy thanhLy);
}