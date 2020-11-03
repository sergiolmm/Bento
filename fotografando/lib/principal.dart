import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:io' as io;
import 'package:fotografando/foto.dart';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  var location = new Location();
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;

  Image img =
      Image.asset('img/camera.jpg', width: 250, height: 200, fit: BoxFit.fill);

  void serviceStatus() async {
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

  void _takeFoto() async {
    final camaras = await availableCameras();
    final camera = camaras.first;
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => foto(camera: camera)));

    setState(() {
      print(result);
      img = Image.file(io.File(result),
          width: 250, height: 200, fit: BoxFit.fill);
    });
  }

  @override
  void initState() {
    super.initState();
    serviceStatus();
    if (_permissionGranted == PermissionStatus.denied) {
      obterPermissao();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          RaisedButton(
            child: Icon(Icons.camera),
            onPressed: () {
              // tirar a foto
              _takeFoto();
            },
          ),
          Center(
            child: img,
          )
        ],
      ),
    );
  }
}
