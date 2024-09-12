import 'dart:io';

import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfPhieuKiemKeApi {
  static Future<File> generate(
      List<AssetsModel> list, String email, String name) async {
    final myThem = ThemeData.withFont(
      base: Font.ttf(
          await rootBundle.load("assets/Open_Sans/OpenSans-Regular.ttf")),
      bold:
          Font.ttf(await rootBundle.load("assets/Open_Sans/OpenSans-Bold.ttf")),
      italic: Font.ttf(
          await rootBundle.load("assets/Open_Sans/OpenSans-Italic.ttf")),
      boldItalic: Font.ttf(
          await rootBundle.load("assets/Open_Sans/OpenSans-BoldItalic.ttf")),
    );

    final pdf = pw.Document(theme: myThem);
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.fromLTRB(50, 20, 50, 20),
        build: (pw.Context context) => [
              build(list, name, 0),
            ]));

    return PdfApi.saveDocuments(
        name: "Phieu_Kiem_Ke_${DateTime.now()}.pdf",
        pdf: pdf,
        maPB: list[0].qrCode ?? "");
  }

  static pw.Widget build(List<AssetsModel> list, String name, int index) {
    return ListView.builder(
        itemBuilder: (Context context, int index) {
          return pw.Padding(
              padding: pw.EdgeInsets.all(10.0),
              child: buildTableFull(list[index], name));
        },
        itemCount: list.length);
  }

  static pw.Widget buildTableFull(AssetsModel assets, String name) {
    String _title = assets.nameAsset ?? "";
    String _subtilte = assets.departmentName ?? "";
    String _ngayKK = DateFormat('dd/MM/yyyy').format(DateTime.now());
    return pw.Column(children: <Widget>[
      pw.Container(
        child: Table(
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
          defaultColumnWidth: pw.FixedColumnWidth(150.0),
          border: pw.TableBorder.all(style: BorderStyle.solid, width: 1),
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(children: [
              pw.BarcodeWidget(
                width: 60,
                height: 60,
                barcode: pw.Barcode.qrCode(),
                data: assets.qrCode ?? "",
                padding: EdgeInsets.all(10.0),
              ),
              pw.Container(
                  padding: pw.EdgeInsets.all(5.0),
                  child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        Text('ĐẠI HỌC TRẦN ĐẠI NGHĨA',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold))
                      ])),
            ]),
            pw.TableRow(children: [
              buildColumnName('Tên tài sản: '),
              buildColumnValueStart(
                  _title + "  ,Số Lượng:...../${assets.amount}"),
            ]),
            pw.TableRow(children: [
              buildColumnName('Phòng Ban: '),
              buildColumnValueStart(_subtilte),
            ]),
            pw.TableRow(children: [
              buildColumnName('Ngày Kiểm Kê: '),
              buildColumnValueStart(_ngayKK),
            ]),
            pw.TableRow(children: [
              buildColumnName('Người Kiểm Kê: '),
              buildColumnValueStart(name),
            ]),
          ],
        ),
      ),
      pw.SizedBox(height: 5.0)
    ]);
  }

  static buildColumnName(String name) => pw.Container(
      padding: pw.EdgeInsets.all(5.0),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            Text('$name',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))
          ]));
  static buildColumnValueStart(String value) => pw.Container(
      padding: pw.EdgeInsets.all(5.0),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [Text('$value', style: pw.TextStyle(fontSize: 12))]));
}
