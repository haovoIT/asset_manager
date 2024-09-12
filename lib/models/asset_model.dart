class AssetsModel {
  String? documentID;
  String? code;
  String? nameAsset;
  String? idDepartment;
  String? departmentName;
  String? yearOfManufacture;
  String? producingCountry;
  String? assetGroupName;
  String? status;
  String? originalPrice;
  String? usedTime;
  String? amount;
  String? contractName;
  String? purposeOfUsing;
  String? qrCode;
  String? userId;
  String? starDate;
  String? endDate;
  String? depreciation;
  String? dateCreate;

  AssetsModel(
      {this.documentID,
      this.code,
      this.nameAsset,
      this.idDepartment,
      this.departmentName,
      this.yearOfManufacture,
      this.producingCountry,
      this.assetGroupName,
      this.status,
      this.amount,
      this.usedTime,
      this.originalPrice,
      this.contractName,
      this.purposeOfUsing,
      this.qrCode,
      this.userId,
      this.starDate,
      this.endDate,
      this.depreciation,
      this.dateCreate});

  factory AssetsModel.fromDoc(dynamic doc) => AssetsModel(
        documentID: doc.id,
        nameAsset: doc['nameAsset'],
        code: doc['code'],
        idDepartment: doc['idDepartment'],
        departmentName: doc['departmentName'],
        yearOfManufacture: doc['yearOfManufacture'],
        producingCountry: doc['producingCountry'],
        assetGroupName: doc['assetGroupName'],
        status: doc['status'],
        originalPrice: doc['originalPrice'],
        usedTime: doc['usedTime'],
        amount: doc['amount'],
        contractName: doc['contractName'],
        purposeOfUsing: doc['purposeOfUsing'],
        qrCode: doc['qrCode'],
        userId: doc['userId'],
        starDate: doc['starDate'] ?? "",
        endDate: doc['endDate'] ?? "",
        depreciation: doc['depreciation'] ?? "",
        dateCreate: doc['dateCreate'] ?? "",
      );
  factory AssetsModel.fromDocID(dynamic doc) => AssetsModel(
        nameAsset: doc['nameAsset'],
        code: doc['code'],
        idDepartment: doc['idDepartment'],
        departmentName: doc['departmentName'],
        yearOfManufacture: doc['yearOfManufacture'],
        producingCountry: doc['producingCountry'],
        assetGroupName: doc['assetGroupName'],
        status: doc['status'],
        originalPrice: doc['originalPrice'],
        usedTime: doc['usedTime'],
        amount: doc['amount'],
        contractName: doc['contractName'],
        purposeOfUsing: doc['purposeOfUsing'],
        qrCode: doc['qrCode'],
        userId: doc['userId'],
        starDate: doc['starDate'] ?? "",
        endDate: doc['endDate'] ?? "",
        depreciation: doc['depreciation'] ?? "",
        dateCreate: doc['dateCreate'] ?? "",
      );
}
