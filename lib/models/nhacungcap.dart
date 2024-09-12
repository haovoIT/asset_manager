class NhaCungCap {
  String? documentID;
  String? TenNCC;
  String? DC;
  String? SDT;
  String? Email;

  NhaCungCap({
    this.documentID,
    this.TenNCC,
    this.DC,
    this.SDT,
    this.Email,
  });

  factory NhaCungCap.fromdoc(dynamic doc) => NhaCungCap(
      documentID: doc.id,
      TenNCC: doc['TenNCC'],
      DC: doc['DC'],
      SDT: doc['SDT'],
      Email: doc['Email']
  );

}