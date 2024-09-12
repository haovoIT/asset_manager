class NhomTaiSan{
  String? documentID;
  String? TenNTS;
  String? DD;

  NhomTaiSan({
    this.documentID,
    this.TenNTS,
    this.DD
});
  factory NhomTaiSan.fromDoc(dynamic doc)=>NhomTaiSan(
    documentID: doc.id,
    TenNTS: doc['TenNTS'],
    DD: doc['DD']
  ) ;
}