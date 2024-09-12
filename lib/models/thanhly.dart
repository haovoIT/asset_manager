class ThanhLy {
  String? documentID;
  String? Ten_ts;
  String? Ma_pb;
  String? Don_vi_TL;
  String? Nguyen_gia_TL;
  String? Ngay_TL;

  ThanhLy(
      {this.documentID,
      this.Ten_ts,
      this.Ma_pb,
      this.Don_vi_TL,
      this.Nguyen_gia_TL,
      this.Ngay_TL});
  factory ThanhLy.fromDoc(dynamic doc) => ThanhLy(
      documentID: doc['documentID'],
      Ten_ts: doc['Ten_ts'],
      Ma_pb: doc['Ma_pb'],
      Don_vi_TL: doc['Don_vi_TL'],
      Nguyen_gia_TL: doc['Nguyen_gia_TL'],
      Ngay_TL: doc['Ngay_TL']);
}
