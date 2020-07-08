import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_craze/routes/camera.dart';
import 'package:pdf_craze/routes/pdf.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Craze',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'PDF Craze'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _imagePath;

  void _gotoCamera() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return CameraPage();
      }),
    ).then((imagePath) {
      print('Returned path: ' + imagePath.toString());

      if (imagePath != null)
        setState(() {
          _imagePath = imagePath;
        });
    });
  }

  _gotoPDF() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return PDFPage(image: File(_imagePath));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: _imagePath == null
            ? Center(child: Text('No document to preview'))
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.file(
                    File(_imagePath),
                    width: 80,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  IconButton(
                    icon: Icon(Icons.print, color: Colors.red),
                    onPressed: () => _gotoPDF(),
                  ),
                  SizedBox(width: 16),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoCamera,
        tooltip: 'Add Document',
        child: Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
