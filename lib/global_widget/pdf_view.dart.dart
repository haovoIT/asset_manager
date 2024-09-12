import 'package:assets_manager/component/index.dart';
import 'package:assets_manager/global_widget/appbar_custom.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';

class PDFCustomView extends StatefulWidget {
  const PDFCustomView({Key? key, required this.titleText, required this.path})
      : super(key: key);
  final titleText;
  final path;

  @override
  State<PDFCustomView> createState() => _PDFCustomViewState();
}

class _PDFCustomViewState extends State<PDFCustomView> {
  int pages = 0;

  int currentPage = 1;
  late PdfController pdfController;

  @override
  void initState() {
    pdfController = PdfController(
      document: PdfDocument.openFile(widget.path),
    );
    super.initState();
  }

  void shareRequest() async {
    final box = context.findRenderObject() as RenderBox?;
    final listXFile = <XFile>[];
    listXFile.add(new XFile(widget.path));
    await Share.shareXFiles(listXFile,
        subject: AssetString.TITLE,
        text: widget.titleText,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: widget.titleText,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: PdfView(
          controller: pdfController,
          scrollDirection: Axis.vertical,
          builders: PdfViewBuilders<DefaultBuilderOptions>(
            options: const DefaultBuilderOptions(),
            documentLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            pageLoaderBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
          ),
          onDocumentLoaded: (document) {
            setState(() {
              pages = document.pagesCount;
            });
          },
          onPageChanged: (page) {
            setState(() {
              currentPage = page;
            });
          },
          onDocumentError: (val) {
            Alert.showError(
              title: CommonString.ERROR,
              message: CommonString.ERROR_MESSAGE,
              buttonText: CommonString.CANCEL,
              context: context,
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.all(4.0),
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.main,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "$currentPage/$pages",
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      shareRequest();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
