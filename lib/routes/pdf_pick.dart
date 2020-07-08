import 'dart:io';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfPickPage extends StatefulWidget {
  PdfPickPage({Key key, this.file}) : super(key: key);

  final File file;

  @override
  _PdfPickPageState createState() => _PdfPickPageState();
}

class _PdfPickPageState extends State<PdfPickPage> {
  Future<void> _loadPdfFuture;
  PDFDocument _pdfDocument;

  @override
  void initState() {
    super.initState();

    _loadPdfFuture = _initializePDFFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Document'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _loadPdfFuture,
          builder: (context, snapshot) {
            print('PDF state: ' + snapshot.connectionState.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              // Display PDF preview
              return PDFViewer(document: _pdfDocument);
            } else if (snapshot.connectionState == ConnectionState.none) {
              // On error
              return Text('Could not load PDF!');
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
    print('Loading PDF...');
    _pdfDocument = await PDFDocument.fromFile(widget.file);
    if (_pdfDocument != null)
      print('PDF loaded - ' + _pdfDocument.count.toString());
    else
      print('Failed to load!');
  }
}
