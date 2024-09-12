class HistoryAssetModel {
  String? documentID;
  String? nameAsset;
  String? code;
  String? idAsset;
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
  String? userName;
  String? userEmail;
  String? dateUpdate;

  HistoryAssetModel({
    this.documentID,
    this.nameAsset,
    required this.code,
    this.idAsset,
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
    this.dateCreate,
    this.userName,
    this.userEmail,
    this.dateUpdate,
  });
  factory HistoryAssetModel.fromDoc(dynamic doc) => HistoryAssetModel(
      documentID: doc.id,
      nameAsset: doc['nameAsset'],
      code: doc['code'],
      idAsset: doc['idAsset'],
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
      userName: doc['userName'],
      userEmail: doc['userEmail'],
      dateUpdate: doc['dateUpdate']);
}
