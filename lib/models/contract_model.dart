class Contract {
  String? documentID;
  String? numberContract;
  String? name;
  String? signingDate;
  String? expirationDate;
  String? nameSupplier;
  String? detail;

  Contract({
    this.documentID,
    this.numberContract,
    this.name,
    this.signingDate,
    this.expirationDate,
    this.nameSupplier,
    this.detail,
  });

  factory Contract.fromDoc(dynamic doc) => Contract(
      documentID: doc.id,
      numberContract: doc['numberContract'],
      name: doc['name'],
      signingDate: doc['signingDate'],
      expirationDate: doc['expirationDate'],
      nameSupplier: doc['nameSupplier'],
      detail: doc['detail']);
}
