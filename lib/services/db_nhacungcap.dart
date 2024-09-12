import 'package:assets_manager/models/nhacungcap.dart';
import 'package:assets_manager/services/db_nhacungcap_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbNhaCungCapService implements DbNhaCungCapApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collection = 'NhaCungCap';

  DbNhaCungCapService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  @override
  Stream<List<NhaCungCap>> DanhSachNhaCungCap() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<NhaCungCap> _nhaCungCapDocs =
          snapshot.docs.map((doc) => NhaCungCap.fromdoc(doc)).toList();
      _nhaCungCapDocs
        ..sort((comp1, comp2) => comp1.TenNCC!.compareTo(comp2.TenNCC!));
      return _nhaCungCapDocs;
    });
  }

  Future<bool> ThemNhaCungCap(NhaCungCap nhaCungCap) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collection).add({
      'TenNCC': nhaCungCap.TenNCC,
      'DC': nhaCungCap.DC,
      'SDT': nhaCungCap.SDT,
      'Email': nhaCungCap.Email
    });
    return _documentReference.id != null;
  }

  void CapNhatNhaCungCap(NhaCungCap nhaCungCap) async {
    await _firestore.collection(_collection).doc(nhaCungCap.documentID).update({
      'TenNCC': nhaCungCap.TenNCC,
      'DC': nhaCungCap.DC,
      'SDT': nhaCungCap.SDT,
      'Email': nhaCungCap.Email
    }).catchError((error) => print('Error updating $error'));
  }

  void XoaNhaCungCap(NhaCungCap nhaCungCap) async {
    await _firestore
        .collection(_collection)
        .doc(nhaCungCap.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}
