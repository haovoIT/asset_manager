import 'dart:io';

import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/asset_model.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfThongTinTSApi {
  static Future<File> generate(
      AssetsModel assets, String email, String name) async {
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
      margin: pw.EdgeInsets.all(30),
      build: (pw.Context context) => [
        buildHeader(assets, name, email),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildTitle(assets),
        buildAsset(assets),
        pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
        buildEnd(),
        //pw.Divider(),
      ],
      footer: (pw.Context context) => buildFooter(email),
    ));

    return PdfApi.saveDocument(name: "${assets.nameAsset}.pdf", pdf: pdf);
  }

  static pw.Widget buildHeader(AssetsModel assets, String name, String email) =>
      pw.Column(
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
                      "   Số 189 Nguyễn Oanh, Phường 10,\nQuận Gò Vấp, Thành phố Hồ Chí Minh",
                      style: pw.TextStyle(fontSize: 14)),
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
                  buildText(title: "Email: ", value: email)
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
          ),
          pw.Container(
              width: double.infinity,
              child: Text("-------******-------",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 20))),
          pw.SizedBox(height: 0.6 * PdfPageFormat.cm),
          pw.Text(
            'THÔNG TIN CHI TIẾT TÀI SẢN',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          pw.Container(
            height: 150,
            width: 150,
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: assets.qrCode ?? "",
            ),
          ),
          pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          pw.Text(
              "Mã QR quản lý tài sản, dùng để quét kiểm tra, kiểm kê tài sản định kỳ.",
              style:
                  pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildAsset(AssetsModel assets) {
    String _title = assets.nameAsset ?? "";
    String _subtilte = assets.departmentName ?? "";
    String _namsx = assets.yearOfManufacture != null
        ? DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(assets.yearOfManufacture!))
        : "";
    String _nuocsx = assets.producingCountry ?? "";
    String _nts = assets.assetGroupName ?? "";
    String _tt = assets.status ?? "";
    String _ng = assets.originalPrice ?? "";
    String _tg = assets.usedTime ?? "" + ' Tháng';
    String _sl = assets.amount ?? "";
    String _hd = assets.contractName ?? "";
    String _md = assets.purposeOfUsing ?? "";
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.center,
        children: <pw.Widget>[
          pw.Container(width: double.infinity),
          buildTexts(title: "Tên tài sản: ", value: _title),
          buildTexts(title: "Phòng Ban: ", value: _subtilte),
          buildTexts(title: "Năm Sản Xuất: ", value: _namsx),
          buildTexts(title: "Nước Sản Xuất: ", value: _nuocsx),
          buildTexts(title: "Nhóm Tài Sản: ", value: _nts),
          buildTexts(title: "Tình Trạng: ", value: _tt),
          buildTexts(title: "Nguyên Giá: ", value: _ng),
          buildTexts(title: "Thời Gian SD: ", value: _tg),
          buildTexts(title: "Số Lượng: ", value: _sl),
          buildTexts(title: "Hợp Đồng: ", value: _hd),
          buildTexts(title: "Mục Đích SD: ", value: _md),
          //buildTexts(title: , value: ),
        ]);
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
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
          pw.Divider(),
          pw.Text("Thông Tin Tài Sản - Email: " + email,
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

  static buildTexts({
    String? title,
    String? value,
  }) {
    return pw.Container(
      child: pw.Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          pw.Container(width: 40),
          pw.Text(title ?? "",
              style:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
          pw.Text(value ?? "", style: pw.TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
