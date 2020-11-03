import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:tekepicture/foto.dart';
import 'package:tekepicture/foto2.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

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
                    io.File(path),
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

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  var location = new Location();
  LocationData _locationData;

  String coordenadas = "Sem valor";
  String lat = "";
  String lgt = "";
  String _path;

  bool readyToPost = false;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  void serviceStaus() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  void obterPermissao() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted != PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future _obterLocalizacao() async {
    _locationData = await location.getLocation();
    return _locationData;
  }

  void _takeFoto() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => foto(camera: camera)));

    setState(() {
      print(result);
      _path = result;
      img = Image.file(
        io.File(result),
        width: 250,
        height: 200,
        fit: BoxFit.fill,
      );
      readyToPost = true;
    });
  }

  void _takeFoto2() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => foto2(camera: camera)));

    setState(() {
      print(result);
      _path = result;
      img = Image.file(
        io.File(result),
        width: 250,
        height: 200,
        fit: BoxFit.fill,
      );
      readyToPost = true;
    });
  }

  Image img = Image.asset(
    'img/camera.jpg',
    width: 250,
    height: 200,
    fit: BoxFit.fill,
  );

  _postJsonToUrl() async {
    final String url = "https://www.slmm.com.br/ws/exe1/index2.php";

    /*
    Uri myUri = Uri.parse(_path);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });*/

    Uint8List m = io.File(_path).readAsBytesSync();
    String img64 = base64Encode(m);

    Map<String, dynamic> jsonData = {
      'ra': '12346',
      'nome': 'Hans Solo',
      'lat': lat,
      'lgt': lgt,
      'img': img64
    };
// '/9j/2wBDAAICAgICAgICAgICAgICAwQDAgIDBAUEBAQEBAUGBQUFBQUFBgYHBwgHBwYJCQoKCQkMDAwMDAwMDAwMDAwMDAz/2wBDAQMDAwUEBQkGBgkNCwkLDQ8ODg4ODw8MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAKAA8DAREAAhEBAxEB/8QAFgABAQEAAAAAAAAAAAAAAAAACQMH/8QAIhAAAQUAAgICAwAAAAAAAAAAAwECBAUGERITFAAHCBYx/8QAGAEAAwEBAAAAAAAAAAAAAAAAAQIEAAP/xAAaEQEAAgMBAAAAAAAAAAAAAAAAARECAwQx/9oADAMBAAIRAxEAPwBO8c3BwM9miy8PU6iCehr5mktGVIrGVXT5cYJUYTqIh5HseRSdWI8geWuciAIPx0xoC2Q/kPKzsf681FxU5uvwsys9E+VBGgirp0yOaWAJp7yCawiNRCeP1+UcNHI+Q3sQLR9Y5gsaMf7A3lbFHCrttroEMPbwxI1lKENnZVcvVjCIicqqr8vxIn+363SSY1dotRor6v7qX0bGaeUHu1j+rvGV7m8pz/ePjT4z/9k='
    String jsonD = jsonEncode(jsonData);
    print(jsonD);
    /*  ra, nome , lat, lgt,img */
    Map<String, String> headers2 = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    http.Response response;
    response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonD,
    );
    print(url);
    print(response.headers);
    print(response.body);
    print('feito');
    //Map<String, dynamic> retorno = json.decode(response.body);
    //print(retorno["id"]);
  }

  @override
  void initState() {
    super.initState();

    serviceStaus();
    if (_permissionGranted == PermissionStatus.denied) {
      obterPermissao();
    }
    _obterLocalizacao().then((value) {
      setState(() {
        lat = _locationData.latitude.toString();
        lgt = _locationData.longitude.toString();
        coordenadas = _locationData.latitude.toString() +
            "\n" +
            _locationData.longitude.toString();
      });
    });
    location.changeSettings(interval: 300);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        lat = _locationData.latitude.toString();
        lgt = _locationData.longitude.toString();
        coordenadas = currentLocation.latitude.toString() +
            " - " +
            currentLocation.longitude.toString();
        print(currentLocation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(children: [
        Text(
          coordenadas,
          style: TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal),
        ),
        RaisedButton(
            child: Icon(Icons.camera_alt),
            onPressed: () {
              _takeFoto2();
            }),
        RaisedButton(
            child: Icon(Icons.camera_alt),
            onPressed: () {
              _takeFoto();
            }),
        Center(child: img
            /*
          Image.asset('img/camera.jpg',
              width: 250, height: 200, fit: BoxFit.fill),
              */
            ),
        RaisedButton(
            child: Icon(Icons.airport_shuttle),
            onPressed: () {
              if (readyToPost) {
                _postJsonToUrl();
              }
            }),
      ]),
    );
  }
}
