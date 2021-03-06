import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_craze/routes/camera.dart';
import 'package:pdf_craze/routes/pdf_camera.dart';
import 'package:pdf_craze/routes/pdf_pick.dart';
import 'package:pdf_craze/routes/pdf_url.dart';

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
  var _url =
      'https://docs.conda.io/projects/conda/en/4.6.0/_downloads/52a95608c49671267e40c689e0bc00ca/conda-cheatsheet.pdf';
  var _pickedFile;

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
          var imageSize = File(_imagePath).lengthSync() / 1024 / 1024;
          print('Image captured - ' + imageSize.toString() + ' MB');
        });
    });
  }

  _gotoPDFCamera() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return PdfCameraPage(image: File(_imagePath));
      }),
    );
  }

  _gotoPDFUrl() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return PdfUrlPage(url: _url);
      }),
    );
  }

  _gotoPDFPick() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return PdfPickPage(file: _pickedFile);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.link, color: Colors.white),
            onPressed: () => _gotoPDFUrl(),
          ),
        ],
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
                    onPressed: () => _gotoPDFCamera(),
                  ),
                  SizedBox(width: 16),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showActionSheet,
        tooltip: 'Add Document',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _showActionSheet() async {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            // title: Text('Title'),
            message: Text('Choose method to add a document.'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text('Capture with camera'),
                isDefaultAction: false,
                onPressed: () {
                  Navigator.of(context).pop();
                  _gotoCamera();
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Pick a file',
                ),
                isDefaultAction: false,
                onPressed: () async {
                  Navigator.of(context).pop();
                  _pickedFile = null;
                  _pickedFile = await FilePicker.getFile(
                      type: FileType.custom, allowedExtensions: ['pdf']);
                  if (_pickedFile != null) _gotoPDFPick();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
              ),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          );
        });
  }
}
