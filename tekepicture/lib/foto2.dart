import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class foto2 extends StatefulWidget {
  final CameraDescription camera;

// cria um novo construtor para passar a camera como parametro
  const foto2({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  _foto2State createState() => _foto2State();
}

class _foto2State extends State<foto2> {
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
      ResolutionPreset.high, //medium,
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

                Navigator.pop(context, path);
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            }),
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            var size = MediaQuery.of(context).size.width;
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              /*        return ClipRect(
                  child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                        width: 400,
                        height: 400 / _controller.value.aspectRatio,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: CameraPreview(_controller),
                        ))),
              ));
*/
              return Transform.scale(
                scale: 0.85,
                child: Container(
                  width: size,
                  height: size,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: OverflowBox(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Container(
                          width: size,
                          height: size / _controller.value.aspectRatio,
                          child: CameraPreview(
                            _controller,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );

              //CameraPreview(_controller);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Center(
          child: img,
        ),
      ]),
    );
  }
}
