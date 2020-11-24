import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dadosRest.dart';

class detalhe extends StatefulWidget {
  int _id;

  detalhe(this._id);

  @override
  _detalheState createState() => _detalheState();
}

class _detalheState extends State<detalhe> {
  Image imgRest;

  Future<List<DadosRest>> _recuperaDados() async {
    String URL = "http://www.slmm.com.br/ws/exe1/index2.php?tipo=json&id=" +
        widget._id.toString();
    http.Response response = await http.get(URL);
    Map<String, dynamic> retorno = json.decode(response.body);

    String imgBruta = retorno["img_64"];
    List<DadosRest> dados = List();
    DadosRest dRest = DadosRest(0, "0", "0", imgBruta);
    dados.add(dRest);

    return dados;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("get image from rest"),
          backgroundColor: Colors.lightBlue,
        ),
        body: FutureBuilder<List<DadosRest>>(
          future: _recuperaDados(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print("none");
                break;
              case ConnectionState.waiting:
                print("esperando");
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.active:
                print("ativo");
                break;
              case ConnectionState.done:
                print("done");
                List<DadosRest> lista = snapshot.data;
                DadosRest dados = lista[0];
                Uint8List imgConv = base64Decode(dados.img_64);

                // return Image.memory(imgConv);

                return Container(
                    padding: EdgeInsets.all(30),
                    child: Column(children: [
                      Text("Image ID -> ${widget._id}"),
                      RaisedButton(
                          child: Text("Voltar"),
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Image.memory(imgConv, height: 380, fit: BoxFit.fill)
                    ]));
                break;
            }
            return Center(child: Text("nao oll"));
          },
        ));
  }
}
