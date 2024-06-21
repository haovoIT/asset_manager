class SupplierModel {
  String? documentID;
  String? name;
  String? address;
  String? phone;
  String? email;

  SupplierModel({
    this.documentID,
    this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory SupplierModel.fromDoc(dynamic doc) => SupplierModel(
      documentID: doc.id,
      name: doc['name'],
      address: doc['address'],
      phone: doc['phone'],
      email: doc['email']);
}
