import 'package:assets_manager/models/kehoachkiemke.dart';
import 'package:assets_manager/services/db_kehoachkiemke_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbKeHoachKiemKeService implements DbKHKKApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'KeHoachKiemKe';

  DbKeHoachKiemKeService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<KeHoachKiemKe>> getKHKKList(String maPb) {
    return _firestore
        .collection(_collectionAssets)
        .where("Ma_pb", isEqualTo: maPb)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<KeHoachKiemKe> _assetsDocs =
          snapshot.docs.map((doc) => KeHoachKiemKe.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp2.Ngay_KK!.compareTo(comp1.Ngay_KK!));
      return _assetsDocs;
    });
  }

  Future<bool> addKHKK(KeHoachKiemKe keHoachKiemKe) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'Ma_pb': keHoachKiemKe.Ma_pb,
      'Ngay_KK': keHoachKiemKe.Ngay_KK,
      'Name': keHoachKiemKe.Name,
      'Email': keHoachKiemKe.Email,
      'listAsset': keHoachKiemKe.list
    });
    return _documentReference.id != null;
  }

  void updateKHKK(KeHoachKiemKe keHoachKiemKe) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(keHoachKiemKe.documentID)
        .update({
      'Ma_pb': keHoachKiemKe.Ma_pb,
      'Ngay_KK': keHoachKiemKe.Ngay_KK,
      'Name': keHoachKiemKe.Name,
      'Email': keHoachKiemKe.Email,
      'listAsset': keHoachKiemKe.list
    }).catchError((error) => print('Error updating $error'));
  }

  void deleteKHKK(KeHoachKiemKe keHoachKiemKe) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(keHoachKiemKe.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}
