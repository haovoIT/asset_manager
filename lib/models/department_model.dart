class DepartmentModel {
  String? documentID;
  String? code;
  String? name;
  String? phone;
  String? address;
  String? dateCreate;
  String? status;

  DepartmentModel(
      {this.documentID,
      this.code,
      this.name,
      this.phone,
      this.address,
      this.dateCreate,
      this.status});
  factory DepartmentModel.fromDoc(dynamic doc) => DepartmentModel(
        documentID: doc.id,
        name: doc['name'],
        code: doc['code'],
        phone: doc['phone'],
        address: doc['address'],
        dateCreate: doc['dateCreate'],
        status: doc['status'],
      );

  factory DepartmentModel.fromDocNameDepartment(dynamic doc) =>
      DepartmentModel(documentID: doc.id, name: doc['name']);
}
