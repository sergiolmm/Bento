import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  String url = "http://www.slmm.com.br/ws/exe1/index2.php?tipo=json&id=";
  TextEditingController _editingController;
  String textDigitado = "";

  Image img1 = Image.asset('img/hommer.jpg', fit: BoxFit.fill);

  _getImageFromURL() async {
    String id = _editingController.text;
    print(url + id);
    http.Response response;
    response = await http.get(url + id); // espera a resposta
    print("Resposta" + response.statusCode.toString() + response.body);
    Map<String, dynamic> retorno = json.decode(response.body);
    print(retorno["id"]);
    String _imgStr = retorno["img_64"];
    Uint8List imgConv = base64Decode(_imgStr);
    setState(() {
      img1 = new Image.memory(imgConv);
    });
  }

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: "0");
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("get by rest"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(labelText: "Digite o id da imagem ex: 03"),
                style: TextStyle(fontSize: 20),
                controller: _editingController,
                /* onSubmitted: (newValue) {
                  setState(() {
                    textDigitado = newValue;
                    print(textDigitado);
                  });
                },*/
                autofocus: true),
            RaisedButton(
                child: Text(
                  "Mudar foto",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: _getImageFromURL),
            img1,
          ],
        ),
      ),
    );
  }
}
