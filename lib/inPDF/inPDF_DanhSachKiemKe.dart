import 'dart:io';
import 'package:assets_manager/inPDF/pdf_api.dart';
import 'package:assets_manager/models/kehoachkiemke.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';

class PdfDanhSachKHKKApi{
  static Future<File> generate(
      List<KeHoachKiemKe> list, String email, String name) async {
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
        margin: pw.EdgeInsets.fromLTRB(30, 20, 30, 20),
        build: (pw.Context context) => [
          buildHeader(name,email),
          pw.SizedBox(height: 0.3 * PdfPageFormat.cm),
          buildTitle(),
          build(list, 0),
          buildEnd(list.length.toString()),
          pw.SizedBox(height: 1 * PdfPageFormat.cm),
        ]));

    return PdfApi.saveDocument(
        name: "Danh_Sach_Ke_Hoach_Kiem_Ke.pdf", pdf: pdf);
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
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16)),
              pw.Text("   Số 189 Nguyễn Oanh, Phường 10,\nQuận Gò Vấp, Thành phố Hồ Chí Minh",style: pw.TextStyle(fontSize: 14)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              buildText(
                  title: "Ngày Lập: ",
                  value: DateFormat('dd/MM/yyyy')
                      .format(DateTime.now())),
              buildText(title: "Người Lập: ", value: name),
              buildText(title: "Email: ", value: email)
            ],
          ),
        ],
      ),
    ],
  );

  static pw.Widget buildTitle() => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    mainAxisAlignment: pw.MainAxisAlignment.center,
    children: [
      pw.Container(
        width:  double.infinity,
      ),
      pw.Container(
          width:  double.infinity,
          child: Text("-------******-------",textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 20))
      ),
      pw.SizedBox(height: 0.6 * PdfPageFormat.cm),
      pw.Text(
        'Danh Sách Kế Hoạch Kiểm Kê',
        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
      ),
      pw.SizedBox(height: 0.8 * PdfPageFormat.cm),

    ],
  );


  static pw.Widget build(List<KeHoachKiemKe> list, int index) {
    String _ngayKK = list[index].Ngay_KK !=null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(list[index].Ngay_KK!)):"";
    return ListView.builder(
        itemBuilder: (Context context, int index) {
          return pw.Padding(
              padding: pw.EdgeInsets.all(10.0),
              child: pw.Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildColumnName('${index+1}.Ngày Kiểm Kê: '),
                      buildColumnValueStart(_ngayKK),
                    ]
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildColumnName('   Người Kiểm Kê: '),
                        buildColumnValueStart(list[index].Name??""),
                      ]
                  ),
                  buildTable(list[index].list??[], 0)
                ]
              ));
        },
        itemCount: list.length);
  }

  static pw.Widget buildTable(List<String> list, int index) {

    return ListView.builder(
        itemBuilder: (Context context, int index) {
          return buildTableFull(list[index], 0) ;
        },
        itemCount: list.length);
  }

  static pw.Widget buildTableFull(String data,int index) {
    String _title = data.substring(0,26);
    String _subtilte = data.substring(29,data.length);
    return pw.Container(
      child: Table(
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.full,
        defaultColumnWidth: pw.FixedColumnWidth(150.0),
        border: pw.TableBorder.all(style: BorderStyle.solid, width: 1),
        children: [
          pw.TableRow(children: [
            pw.BarcodeWidget(
              width: 60,
              height: 60,
              barcode: pw.Barcode.qrCode(),
              data: _title,
              padding: EdgeInsets.all(10.0),
            ),
            pw.Container(
                padding: pw.EdgeInsets.all(5.0),
                child: buildColumnValueStart('$_subtilte')),
          ]),
        ],
      ),
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
              pw.Text ("Tổng Cộng: $number lần kiểm kê.",style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontStyle:  pw.FontStyle.italic)),
              pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
              pw.Text("TP.Hồ Chí Minh, ngày      tháng "+DateFormat.M().format(DateTime.now())+" năm "+DateFormat.y().format(DateTime.now()), style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              pw.Text("Người Lập", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ]
        ),

      ]
  );

  static buildColumnValueStart(String value) => pw.Container(
      padding: pw.EdgeInsets.all(5.0),
      child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [Text('$value', style: pw.TextStyle(fontSize: 12))]));

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

  static buildSimpleText({
    String? title,
    String? value,
  }) {
    final style = pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(title??"", style: style),
        pw.SizedBox(width: 2 * PdfPageFormat.mm),
        pw.Text(value??""),
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
          pw.Expanded(child: pw.Text(title??"", style: style)),
          pw.Text(value??"", style: unite ? style : null),
        ],
      ),
    );
  }
}