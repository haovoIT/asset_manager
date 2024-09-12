class DiaryModel {
  String? documentID;
  String? idAsset;
  String? qrCode;
  String? nameAsset;
  String? idDepartment;
  String? originalPrice;
  String? usedTime;
  String? starDate;
  String? endDate;
  String? depreciation;
  String? detail;
  String? userName;
  String? userEmail;
  String? dateUpdate;
  String? dateCreate;

  DiaryModel({
    this.documentID,
    this.nameAsset,
    this.idAsset,
    this.idDepartment,
    this.usedTime,
    this.originalPrice,
    this.qrCode,
    this.starDate,
    this.endDate,
    this.depreciation,
    this.userName,
    this.userEmail,
    this.dateUpdate,
    this.detail,
    this.dateCreate,
  });
  factory DiaryModel.fromDoc(dynamic doc) => DiaryModel(
        documentID: doc.id,
        nameAsset: doc['nameAsset'],
        idAsset: doc['idAsset'],
        idDepartment: doc['idDepartment'],
        originalPrice: doc['originalPrice'],
        usedTime: doc['usedTime'],
        qrCode: doc['qrCode'],
        starDate: doc['starDate'] ?? "",
        endDate: doc['endDate'] ?? "",
        depreciation: doc['depreciation'] ?? "",
        userName: doc['userName'],
        userEmail: doc['userEmail'],
        dateUpdate: doc['dateUpdate'],
        detail: doc['detail'],
        dateCreate: doc['dateCreate'],
      );
}
