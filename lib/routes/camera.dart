import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> _cameras;
  CameraController _cameraController;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    _getCameras().then((cameras) {
////      _cameras = cameras;
////      print('Cameras: ' + _cameras.length.toString());
////
////      _cameraController = CameraController(
////        _cameras.first,
////        ResolutionPreset.medium,
////        enableAudio: true,
////      );
////
////      _initializeControllerFuture = _cameraController.initialize();
////    });

    _initializeControllerFuture = _initializeCameras();
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
              // On error
              return Text('Could not initialize camera!');
            } else {
              // Otherwise, display a loading indicator.
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Recheck cameras
            await _initializeControllerFuture;

            // Construct image path
            final path = join(
                (await getTemporaryDirectory()).path, '${DateTime.now()}.png');

            // Try to capture
            await _cameraController.takePicture(path);
            Navigator.of(context).pop(path);
          } on Exception catch (e) {
            print('Failed to capture: ' + e.toString());
          }
        },
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

  _initializeCameras() async {
    _cameras = await _getCameras();
    print('Cameras: ' + _cameras.length.toString());

    _cameraController = CameraController(
      _cameras.first,
      ResolutionPreset.high,
      enableAudio: true,
    );

    return _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
