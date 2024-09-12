import 'dart:io';

import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfDSTaiSanApi {
  static Future<File> generate(List<AssetsModel> list, String email,
      String name, String tinhtrang) async {
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
      orientation: pw.PageOrientation.landscape,
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(20),
      build: (pw.Context context) => [
        buildHeader(name, email),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTitle(tinhtrang, list[0].departmentName ?? ""),
        tinhtrang == "Biến Cố" ? buildTableBC(list, 0) : buildTable(list, 0),
        //pw.SizedBox(height: 0.75 * PdfPageFormat.cm),
        buildEnd(list.length.toString())
        //pw.Divider(),
      ],
      //footer: (pw.Context context) => buildFooter(name,email),
    ));

    return PdfApi.saveDocument(
        name: "Danh_Sach_Tai_San_$tinhtrang.pdf", pdf: pdf);
  }

  static pw.Widget buildHeader(String name, String email) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text("TRƯỜNG ĐẠI HỌC TRẦN ĐẠI NGHĨA",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 18)),
                  pw.Text(
                      "   Số 189 Nguyễn Oanh, Phường 10,\nQuận Gò Vấp, Thành phố Hồ Chí Minh",
                      style: pw.TextStyle(fontSize: 14)),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  buildText(
                      title: "Ngày Lập: ",
                      value: DateFormat('dd/MM/yyyy').format(DateTime.now())),
                  buildText(title: "Người Lập: ", value: name),
                  buildText(title: "Email: ", value: email)
                ],
              ),
            ],
          ),
        ],
      );

  static pw.Widget buildTitle(String tinhtrang, String pb) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Container(
            width: double.infinity,
          ),
          pw.Container(
              width: double.infinity,
              child: Text("-------******-------",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 20))),
          pw.SizedBox(height: 0.6 * PdfPageFormat.cm),
          pw.Text(
            'Danh Sách Tài Sản $tinhtrang',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Phòng Ban: ' + pb,
            style: pw.TextStyle(fontSize: 16, fontStyle: pw.FontStyle.italic),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildTable(List<AssetsModel> list, int index) {
    final headers = [
      'STT',
      'Tên Tài Sản',
      'Năm SX',
      'Nước SX',
      'Nhóm TS',
      'Nguyên Giá',
      'TGSD (Tháng)',
      'Số Lượng',
      'Ghi Chú'
    ];
    final data = list.map((item) {
      return [
        index = index + 1,
        item.nameAsset,
        item.yearOfManufacture != null
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(item.yearOfManufacture!))
            : "",
        item.producingCountry,
        item.assetGroupName,
        item.originalPrice,
        item.usedTime ?? "" + " Tháng",
        item.amount,
        item.purposeOfUsing
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder.all(),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      headerAlignment: Alignment.topCenter,
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellStyle: pw.TextStyle(fontSize: 8),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerLeft,
        4: Alignment.centerLeft,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerLeft
      },
    );
  }

  static pw.Widget buildTableBC(List<AssetsModel> list, int index) {
    final headers = [
      'STT',
      'Tên Tài Sản',
      'Tình Trạng',
      'Năm SX',
      'Nước SX',
      'Nhóm TS',
      'Nguyên Giá',
      'TGSD (Tháng)',
      'Số Lượng',
      'Ghi Chú'
    ];
    final data = list.map((item) {
      return [
        index = index + 1,
        item.nameAsset,
        item.status,
        item.yearOfManufacture != null
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(item.yearOfManufacture!))
            : "",
        item.producingCountry,
        item.assetGroupName,
        item.originalPrice,
        item.usedTime ?? "" + " Tháng",
        item.amount,
        item.purposeOfUsing
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: TableBorder.all(),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      headerAlignment: Alignment.topCenter,
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellStyle: pw.TextStyle(fontSize: 8),
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
        9: Alignment.centerLeft
      },
    );
  }

  static pw.Widget buildEnd(String number) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text("Tổng Cộng: $number",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontStyle: pw.FontStyle.italic)),
                  pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
                  pw.Text(
                      "TP.Hồ Chí Minh, ngày      tháng " +
                          DateFormat.M().format(DateTime.now()) +
                          " năm " +
                          DateFormat.y().format(DateTime.now()) +
                          "   ",
                      style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
                  pw.Text("Người Lập",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
          ]);

  static pw.Widget buildFooter(String name, String email) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Divider(),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          pw.Text("Người lập:  " + name + ",  Email: " + email,
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static buildSimpleText({
    String? title,
    String? value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title ?? "", style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value ?? ""),
      ],
    );
  }

  static buildText({
    String? title,
    String? value,
    double width = 240,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title ?? "", style: style)),
          pw.Text(value ?? "", style: unite ? style : null),
        ],
      ),
    );
  }
}
