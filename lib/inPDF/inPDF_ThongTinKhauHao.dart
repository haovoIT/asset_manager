import 'dart:io';

import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:assets_manager/models/diary_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfThongTinKHApi {
  static Future<File> generate(
      AssetsModel assets,
      List<DiaryModel> list,
      String khauHao,
      String luyKe,
      String conLai,
      String email,
      String name) async {
    final myThem = ThemeData.withFont(
      base: Font.ttf(
          await rootBundle.load("assets/font/Tinos/Tinos-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/font/Tinos/Tinos-Bold.ttf")),
      italic:
          Font.ttf(await rootBundle.load("assets/font/Tinos/Tinos-Italic.ttf")),
      boldItalic: Font.ttf(
          await rootBundle.load("assets/font/Tinos/Tinos-BoldItalic.ttf")),
    );

    final pdf = pw.Document(theme: myThem);
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.only(top: 20, bottom: 10, left: 30, right: 30),
      build: (pw.Context context) => [
        buildHeader(name, email),
        pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildTitle(assets),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildColumnName("I. THÔNG TIN TÀI SẢN:"),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableFull(assets, list),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildColumnName(
            "II. DANH SÁCH THÔNG TIN THAY ĐỔI NÂNG CẤP, ĐỊNH GIÁ TÀI SẢN:"),
        pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              buildColumnValueStart("Số lần thay đổi: "),
              buildColumnValueEnd("${list.length + 1}"),
            ]),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTable(list, 0),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildColumnName(
            "III. THÔNG TIN MỨC KHẤU KHAO, LŨY KẾ, GIÁ TRỊ CÒN LẠI CỦA TÀI SẢN:"),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTableKH(khauHao, luyKe, conLai),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildEnd(),
        pw.Divider(),
      ],
      footer: (pw.Context context) => buildFooter(email),
    ));

    return PdfApi.saveDocument(
        name:
            "Khau_Hao_${assets.nameAsset}_${DateFormat("yyyy_MM_dd_HH_mm_ss").format(DateTime.now())}.pdf",
        pdf: pdf);
  }

  static pw.Widget buildHeader(String name, String email) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("TRƯỜNG ĐẠI HỌC TRẦN ĐẠI NGHĨA",
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 16)),
                  pw.Text(
                      " Số 189 Nguyễn Oanh, Phường 10, Quận Gò Vấp, Thành phố Hồ Chí Minh",
                      style: pw.TextStyle(fontSize: 14),
                      textAlign: pw.TextAlign.center),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  buildText(
                      title: "Ngày in: ",
                      value: DateFormat('dd/MM/yyyy').format(DateTime.now())),
                  buildText(title: "Người Lập: ", value: name),
                  buildText(title: "Email: ", value: email),
                ],
              )
            ],
          ),
        ],
      );

  static pw.Widget buildTitle(AssetsModel assets) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: [
          pw.Container(
              width: double.infinity,
              child: Text("-------******-------",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 20))),
          pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
          pw.Text(
            'THÔNG TIN KHẤU HAO TÀI SẢN',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          pw.Container(
            height: 150,
            width: 150,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: assets.qrCode ?? "",
            ),
          ),
          pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
          pw.Text(
              "Mã QR quản lý tài sản, dùng để quét kiểm tra, kiểm kê tài sản định kỳ.",
              style:
                  pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
          pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildTableKH(String khauHao, String luyKe, String conLai) =>
      pw.Column(children: <Widget>[
        pw.Container(
          child: Table(
            defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            defaultColumnWidth: pw.FixedColumnWidth(120.0),
            border: pw.TableBorder.all(style: BorderStyle.solid, width: 2),
            children: [
              pw.TableRow(children: [
                pw.Column(children: [
                  pw.Text('Mức Khấu Hao Hàng Tháng',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))
                ]),
                pw.Column(children: [
                  pw.Text('Khấu Hao Lũy Kế',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))
                ]),
                pw.Column(children: [
                  pw.Text('Giá Trị Còn Lại',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold))
                ]),
              ]),
              pw.TableRow(children: [
                pw.Column(children: [
                  pw.Text('$khauHao', style: pw.TextStyle(fontSize: 14.0))
                ]),
                pw.Column(children: [
                  pw.Text('$luyKe', style: pw.TextStyle(fontSize: 14.0))
                ]),
                pw.Column(children: [
                  pw.Text('$conLai', style: pw.TextStyle(fontSize: 14.0))
                ]),
              ]),
            ],
          ),
        ),
      ]);

  static pw.Widget buildTableFull(AssetsModel assets, List<DiaryModel> list) {
    String _title = assets.nameAsset ?? "";
    String _ng = list[list.length - 1].originalPrice ?? "";
    String _tg = list[list.length - 1].usedTime ?? "" + ' Tháng';
    String _subtilte = assets.departmentName ?? "";
    String _namsx = assets.yearOfManufacture != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(assets.yearOfManufacture!))
        : "";
    String _nuocsx = assets.producingCountry ?? "";
    String _nts = assets.assetGroupName ?? "";
    String _tt = assets.status ?? "";
    String _sl = assets.amount ?? "";
    String _hd = assets.contractName ?? "";
    String _md = assets.purposeOfUsing ?? "";
    String _ngayBD = list[list.length - 1].starDate != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(list[list.length - 1].starDate!))
        : "";
    String _ngayKT = list[list.length - 1].endDate != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(list[list.length - 1].endDate!))
        : "";

    return pw.Column(children: <Widget>[
      pw.Container(
        child: Table(
          defaultVerticalAlignment: pw.TableCellVerticalAlignment.top,
          defaultColumnWidth: pw.FixedColumnWidth(150.0),
          border: pw.TableBorder.all(style: BorderStyle.dotted, width: 1),
          columnWidths: {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(children: [
              buildColumnName('1. Tên tài sản: '),
              buildColumnValueStart(_title),
            ]),
            pw.TableRow(children: [
              buildColumnName('2. Phòng Ban: '),
              buildColumnValueStart(_subtilte),
            ]),
            pw.TableRow(children: [
              buildColumnName('3. Nguyên Giá: '),
              buildColumnValueEnd(_ng),
            ]),
            pw.TableRow(children: [
              buildColumnName('4. Số Lượng: '),
              buildColumnValueEnd(_sl),
            ]),
            pw.TableRow(children: [
              buildColumnName('5. Thời Gian SD: '),
              buildColumnValueEnd(_tg),
            ]),
            pw.TableRow(children: [
              buildColumnName('6. Ngày Bắt Đầu: '),
              buildColumnValueEnd(_ngayBD),
            ]),
            pw.TableRow(children: [
              buildColumnName('7. Ngày Kết Thúc: '),
              buildColumnValueEnd(_ngayKT),
            ]),
            pw.TableRow(children: [
              buildColumnName('8. Nhóm Tài Sản: '),
              buildColumnValueStart(_nts),
            ]),
            pw.TableRow(children: [
              buildColumnName('9. Tình Trạng: '),
              buildColumnValueStart(_tt),
            ]),
            pw.TableRow(children: [
              buildColumnName('10. Hợp Đồng: '),
              buildColumnValueStart(_hd),
            ]),
            pw.TableRow(children: [
              buildColumnName('11. Năm Sản Xuất: '),
              buildColumnValueEnd(_namsx),
            ]),
            pw.TableRow(children: [
              buildColumnName('12. Nước Sản Xuất: '),
              buildColumnValueStart(_nuocsx),
            ]),
            pw.TableRow(children: [
              buildColumnName('13. Mục Đích Sử Dụng: '),
              buildColumnValueStart(_md),
            ]),
          ],
        ),
      ),
      pw.SizedBox(height: 5.0)
    ]);
  }

  static pw.Widget buildTable(List<DiaryModel> list, int index) {
    final headers = [
      'STT',
      'Ngày Thay Đổi',
      'Lý Do',
      'Nguyên Giá',
      'TGSD (Tháng)',
      'Khấu Hao',
    ];
    final data = list.map((item) {
      return [
        index = index + 1,
        item.dateUpdate != null
            ? DateFormat('dd/MM/yyyy').format(DateTime.parse(item.dateUpdate!))
            : "",
        item.detail,
        item.originalPrice,
        item.usedTime ?? "" + " Tháng",
        item.depreciation,
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
        1: Alignment.centerRight,
        2: Alignment.centerLeft,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static pw.Widget buildEnd() => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text("TRƯỞNG PHÒNG",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text("CÁN BỘ QUẢN LÝ",
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ]);

  static pw.Widget buildFooter(String email) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Divider(),
          pw.Text("Khấu Hao Tài Sản - Email: " + email,
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
          pw.SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

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
  static buildColumnValueEnd(String value) => pw.Container(
      padding: pw.EdgeInsets.all(5.0),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [Text('$value', style: pw.TextStyle(fontSize: 12))]));

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

  int month(DateTime start, DateTime now) {
    int sum = now.month - start.month + (now.year - start.year) * 12;
    if (now.day < start.day) {
      sum -= 1;
    }
    return sum;
  }
}
