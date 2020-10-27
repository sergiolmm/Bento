import 'package:flutter/material.dart';
import 'package:location/location.dart';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

String lblMsg1 = "Uso do GPS";
String MsgCoordenada = "Sem Valor";
String MsgCoordenadaAtualizada = "Sem valor";

class _principalState extends State<principal> {
  var location = new Location();
  LocationData _locationData;

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

  @override
  void initState() {
    super.initState();
    location.changeSettings(interval: 300);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        MsgCoordenadaAtualizada = currentLocation.latitude.toString() +
            "\n" +
            currentLocation.longitude.toString();
        print(currentLocation);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geo localização"),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(lblMsg1),
            RaisedButton(
              child: Text("Cliqk aqui para coordenada"),
              padding: EdgeInsets.all(10),
              onPressed: () {
                serviceStaus();
                if (_permissionGranted == PermissionStatus.denied) {
                  obterPermissao();
                } else {
                  _obterLocalizacao().then((value) {
                    setState(() {
                      MsgCoordenada = _locationData.latitude.toString() +
                          "\n" +
                          _locationData.longitude.toString();
                    });
                  });
                }
              },
            ),
            Text(MsgCoordenada),
            Text("Coordenadas Atualizadas"),
            Text(MsgCoordenadaAtualizada,
                style: TextStyle(color: Colors.red, fontSize: 30))
          ],
        ),
      ),
    );
  }
}
