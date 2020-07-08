import 'dart:io';
import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFPage extends StatefulWidget {
  PDFPage({Key key, this.image}) : super(key: key);

  final File image;

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  Future<void> _createPdfFuture;
  PdfDocument _pdfConversion;
  var _docPath;
  PDFDocument _pdfDocument;

  @override
  void initState() {
    super.initState();

    _createPdfFuture = _initializePDFFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Document'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _createPdfFuture,
          builder: (context, snapshot) {
            print('PDF state: ' + snapshot.connectionState.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              // Display PDF preview
              return PDFViewer(document: _pdfDocument);
            } else if (snapshot.connectionState == ConnectionState.none) {
              // On error
              return Text('Could not convert to PDF!');
            } else {
              // Otherwise, display a loading indicator.
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  _initializePDFFuture() async {
    // _pdfConversion = PdfDocument(pageMode: PdfPageMode.none);

    final pw.Document pdfConversion = pw.Document(title: 'Test Document');

    // final PdfImage pdfImage = await PdfImage.file(pdfDocument, bytes: null);
    Uint8List imageBytes = await widget.image.readAsBytes();
    final PdfImage pdfImage =
        PdfImage.file(pdfConversion.document, bytes: imageBytes);

    pdfConversion.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Image(pdfImage),
          ); // Center
        }));

    final String dir = (await getTemporaryDirectory()).path;
    final String path = '$dir/test.pdf';
    final File pdfFile = File(path);
    await pdfFile.writeAsBytes(pdfConversion.save());

    _docPath = path;
    print('Document saved: ' + path);

    print('Loading PDF...');
    File savedFile = File(_docPath);
    _pdfDocument = await PDFDocument.fromFile(savedFile);
    var docSize = savedFile.lengthSync() / 1024 / 1024;
    print('PDF loaded - ' + docSize.toString() + ' MB');
  }
}
