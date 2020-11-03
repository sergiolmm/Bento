import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class principal extends StatefulWidget {
  final CameraDescription camera;

// cria um novo construtor para passar a camera como parametro
  const principal({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    ); // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Image img = Image.asset(
    'img/camera.jpg',
    width: 250,
    height: 200,
    fit: BoxFit.fill,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: Column(children: [
          RaisedButton(
              child: Icon(Icons.camera_alt),
              onPressed: () async {
                print("Clicou");
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.
                  await _initializeControllerFuture;

                  // Construct the path where the image should be saved using the
                  // pattern package.
                  final path = join(
                    // Store the picture in the temp directory.
                    // Find the temp directory using the `path_provider` plugin.
                    (await getTemporaryDirectory()).path,
                    '${DateTime.now()}.jpg',
                  );

                  // Attempt to take a picture and log where it's been saved.
                  await _controller.takePicture(path);
                  //  Navigator.pop(context, path);
                  // If the picture was taken, display it on a new screen.
                  setState(() {
                    img = Image.file(
                      File(path),
                      width: 250,
                      height: 200,
                      fit: BoxFit.fill,
                    );
                  });
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              }),
          Center(
            child: img,
          )
        ]));
  }
}