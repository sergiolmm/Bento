import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:trabalhandofuture/dadosRest.dart';
import 'package:trabalhandofuture/detalhe.dart';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  String URL = "https://www.slmm.com.br/ws/exe1/index2.php?ra=12346";

  Future<List<DadosRest>> _recuperaDados() async {
    http.Response response = await http.get(URL);
    var dadosJson = json.decode(response.body);

    List<DadosRest> dados = List();

    for (var dadosRest in dadosJson["dados"]["images"]) {
      DadosRest dRest = DadosRest(
        dadosRest["id"],
        dadosRest["lat"],
        dadosRest["lgt"],
        dadosRest["img_64"],
      );
      dados.add(dRest);
    }
    return dados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dados via Rest"),
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
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List<DadosRest> lista = snapshot.data;
                      DadosRest dados = lista[index];
                      Uint8List imgConv = base64Decode(dados.img_64);
                      var lat;
                      if (dados.lat.length > 6) {
                        lat = dados.lat.substring(0, 6);
                      } else {
                        lat = dados.lat;
                      }

                      return ListTile(
                        title: Text(dados.id.toString()),
                        subtitle: Text("Lat " + lat + " lgt " + dados.lgt),
                        trailing: Image.memory(imgConv),
                        leading: Image.memory(imgConv),
                        onTap: () {
                          print("tocou no item " + dados.id.toString());
                          Navigator.push(context,
                             MaterialPageRoute(builder: (context) => detalhe(dados.id)));
                        },
                      );
                    });
                break;
            }
            return Center(child: Text("nao oll"));
          },
        )
        );
  }
}
