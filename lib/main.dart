import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_craze/routes/camera.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _imagePath == null
            ? Text('No document to preview')
            : Image.file(File(_imagePath)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoCamera,
        tooltip: 'Add Document',
        child: Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
