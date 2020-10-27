import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  TextEditingController _editingController;

  Image imgRest = Image.asset('img/hommer.jpg', fit: BoxFit.fill);

  _getImageFromURL() async {
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
          title: Text("get image from rest"),
          backgroundColor: Colors.lightBlue,
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 20),
                decoration:
                    InputDecoration(labelText: "Digite o id da imagem?"),
                controller: _editingController,
                autofocus: true,
                onSubmitted: (newValue) {
                  print(newValue);
                },
              ),
              RaisedButton(
                child: Text("Click for img"),
                onPressed: _getImageFromURL,
              ),
              imgRest,
            ],
          ),
        ));
  }
}
