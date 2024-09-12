import 'package:assets_manager/models/nhomtaisan.dart';
import 'package:assets_manager/services/db_nhomtaisan_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbNhomTaiSanService implements DbNhomTaiSanApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'NhomTaiSan';

  DbNhomTaiSanService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }
  @override
  Stream<List<NhomTaiSan>> danhsachNhomTS() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<NhomTaiSan> _nhomTSDocs =
          snapshot.docs.map((doc) => NhomTaiSan.fromDoc(doc)).toList();
      _nhomTSDocs
        ..sort((comp1, comp2) => comp1.TenNTS!.compareTo(comp2.TenNTS!));
      return _nhomTSDocs;
    });
  }

  Future<bool> themNTS(NhomTaiSan nhomTS) async {
    DocumentReference _documentReference = await _firestore
        .collection(_collection)
        .add({'TenNTS': nhomTS.TenNTS, 'DD': nhomTS.DD});
    return _documentReference != null;
  }

  void capnhatNTS(NhomTaiSan nhomTS) async {
    await _firestore
        .collection(_collection)
        .doc(nhomTS.documentID)
        .update({'TenNTS': nhomTS.TenNTS, 'DD': nhomTS.DD}).catchError(
            (error) => print('Error updating $error'));
  }

  void xoaNTS(NhomTaiSan nhomTS) async {
    await _firestore
        .collection(_collection)
        .doc(nhomTS.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}
