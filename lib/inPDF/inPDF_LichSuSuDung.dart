import 'dart:io';

import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/history_asset_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfLSSDApi {
  static Future<File> generate(
      List<HistoryAssetModel> list, String email, String name) async {
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
      margin: pw.EdgeInsets.all(14),
      build: (pw.Context context) => [
        buildHeader(name, email),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTitle(
            list[0].nameAsset ?? "",
            list[0].dateUpdate != null
                ? DateFormat('dd/MM/yyyy')
                    .format(DateTime.parse(list[0].dateUpdate!))
                : ""),
        buildTable(list, 0),
        buildEnd(list.length.toString()),
        pw.SizedBox(height: 1 * PdfPageFormat.cm),
        //pw.Divider(),
      ],
      //footer: (pw.Context context) => buildFooter(name,email),
    ));

    return PdfApi.saveDocument(name: "Lich_Su_Su_Dung.pdf", pdf: pdf);
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
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
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

  static pw.Widget buildTitle(String name, String start) => pw.Column(
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
            'Lịch Sử Sử Dụng Tài Sản',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            'Tài Sản: $name - Từ ngày $start đến ngày ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
            style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildTable(List<HistoryAssetModel> list, int index) {
    final headers = [
      'STT',
      'Tên Tài Sản',
      'Phòng Ban',
      'Năm Sản Xuất ',
      'Nước SX',
      'Nhóm Tài Sản',
      'Tình Trạng',
      'Nguyên  Giá ',
      'TGSD (Tháng)',
      'Số Lượng',
      'Hợp Đồng',
      'Mục Đích SD',
      'Tên TK CN',
      'Email Cập Nhật',
      'Thời Gian CN'
    ];
    final data = list.map((item) {
      return [
        index = index + 1,
        item.nameAsset,
        item.departmentName,
        item.yearOfManufacture != null
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(item.yearOfManufacture!))
            : "",
        item.producingCountry,
        item.assetGroupName,
        item.status,
        item.originalPrice,
        item.usedTime,
        item.amount,
        item.contractName,
        item.purposeOfUsing,
        item.userName,
        item.userEmail,
        item.dateUpdate != null
            ? DateFormat('HH:mm:ss \n dd/MM/yyyy')
                .format(DateTime.parse(item.dateUpdate!))
            : "",
      ];
    }).toList();
    return Table.fromTextArray(
      headers: headers,
      data: data,
      cellStyle: TextStyle(fontSize: 8),
      border: TableBorder.all(),
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
      headerAlignment: Alignment.topCenter,
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerLeft,
        5: Alignment.centerLeft,
        6: Alignment.centerLeft,
        7: Alignment.centerRight,
        8: Alignment.centerRight,
        9: Alignment.centerRight,
        10: Alignment.centerRight,
        11: Alignment.centerRight,
        12: Alignment.centerLeft,
        13: Alignment.centerLeft,
        14: Alignment.centerLeft,
        15: Alignment.centerLeft,
        16: Alignment.centerRight,
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
                  pw.Text("Tổng Cộng: $number lần cập nhật",
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
