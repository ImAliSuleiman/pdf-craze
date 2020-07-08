import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CameraPage> {
  List<CameraDescription> _cameras;
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCameras().then((cameras) {
      _cameras = cameras;
      print('Cameras: ' + _cameras.length.toString());

      _cameraController = CameraController(
        _cameras.first,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      _initializeControllerFuture = _cameraController.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Document'),
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            print('Camera state: ' + snapshot.connectionState.toString());
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the camera preview.
              return CameraPreview(_cameraController);
            } else if (snapshot.connectionState == ConnectionState.none) {
              // Otherwise, display a loading indicator.
              return Text('Could not initialize camera!');
            } else {
              // Otherwise, display a loading indicator.
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Take Picture',
        child: Icon(Icons.camera),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _getCameras() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    // _cameras = await availableCameras();
    return await availableCameras();

    // Get a specific camera from the list of available cameras.
    // final firstCamera = cameras.first;
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
