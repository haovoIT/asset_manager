
class KeHoachKiemKe{
  String? documentID;
  String? Ma_pb;
  String? Ngay_KK;
  String? Name;
  String? Email;
  List<String>? list;

  KeHoachKiemKe({
   this.documentID,
   this.Ma_pb,
   this.Ngay_KK,
   this.Name,
   this.Email,
   this.list
});

  factory KeHoachKiemKe.fromDoc(dynamic doc) => KeHoachKiemKe(
    documentID: doc.id,
    Ma_pb: doc['Ma_pb'],
    Ngay_KK: doc['Ngay_KK'],
    Name: doc['Name'],
    Email: doc['Email'],
    list: doc['listAsset'].cast<String>()
  );
}