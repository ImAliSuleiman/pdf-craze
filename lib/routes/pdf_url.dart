import 'dart:io';
import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfUrlPage extends StatefulWidget {
  PdfUrlPage({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _PdfUrlPageState createState() => _PdfUrlPageState();
}

class _PdfUrlPageState extends State<PdfUrlPage> {
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
    print('Loading PDF...');
    _pdfDocument = await PDFDocument.fromURL(widget.url);
    if (_pdfDocument != null)
      print('PDF loaded - ' + _pdfDocument.count.toString());
    else
      print('Failed to load!');
  }
}
