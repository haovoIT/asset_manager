import 'package:assets_manager/models/thanhly.dart';
import 'package:assets_manager/services/db_thanhly_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbThanhLyService implements DbTLApi {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _collectionAssets = 'ThanhLy';

  DbThanhLyService() {
    _firestore.settings =
        const Settings(sslEnabled: true, persistenceEnabled: true);
  }

  Stream<List<ThanhLy>> getThanhLyList(String maPb) {
    return _firestore
        .collection(_collectionAssets)
        .where("Ma_pb", isEqualTo: maPb)
        .snapshots()
        .map((QuerySnapshot snapshot) {
      List<ThanhLy> _assetsDocs =
          snapshot.docs.map((doc) => ThanhLy.fromDoc(doc)).toList();
      _assetsDocs
          .sort((comp1, comp2) => comp1.Ten_ts!.compareTo(comp2.Ten_ts!));
      return _assetsDocs;
    });
  }

  Future<bool> addThanhLy(ThanhLy thanhLy) async {
    DocumentReference _documentReference =
        await _firestore.collection(_collectionAssets).add({
      'documentID': thanhLy.documentID,
      'Ten_ts': thanhLy.Ten_ts,
      'Ma_pb': thanhLy.Ma_pb,
      'Don_vi_TL': thanhLy.Don_vi_TL,
      'Nguyen_gia_TL': thanhLy.Nguyen_gia_TL,
      'Ngay_TL': thanhLy.Ngay_TL
    });

    return _documentReference.id != null;
  }

  void updateThanhLy(ThanhLy thanhLy) async {
    await _firestore
        .collection(_collectionAssets)
        .doc(thanhLy.documentID)
        .update({
      'Ten_ts': thanhLy.Ten_ts,
      'Ma_pb': thanhLy.Ma_pb,
      'Don_vi_TL': thanhLy.Don_vi_TL,
      'Nguyen_gia_TL': thanhLy.Nguyen_gia_TL,
      'Ngay_TL': thanhLy.Ngay_TL
    }).catchError((error) => print('Error updating $error'));
  }

  void deleteThanhLy(ThanhLy thanhLy) async {
    // TODO: implement deleteSoKhauHao
    await _firestore
        .collection(_collectionAssets)
        .doc(thanhLy.documentID)
        .delete()
        .catchError((error) => print('Error updating $error'));
  }
}
