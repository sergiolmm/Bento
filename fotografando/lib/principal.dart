import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:io' as io;
import 'package:fotografando/foto.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';



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

//post da informação
  _PostDataToRestAPI() async {
    String id = _editingController.text;
    String url = "http://www.slmm.com.br/ws/exe1/index2.php?tipo=json&id=" + id;
    http.Response response;
    response = await http.get(url);
    print('Resposta' + response.statusCode.toString());
    Map<String, dynamic> retorno = json.decode(response.body);

    String imgBruta = retorno["img_64"];
    Uint8List imagemConv = base64Decode(imgBruta);
    setState(() {
      imgRest = new Image.memory(imagemConv);
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
