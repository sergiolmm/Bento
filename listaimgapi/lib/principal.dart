import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:listaimgapi/dados.dart';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  String Url = "http://www.slmm.com.br/DS403?ra=12345";

  Future<List<DadosDS403>> _recuperaDados() async {
    // conexao com internet
    http.Response response = await http.get(Url);
    var dadosJson = json.decode(response.body);

    List<DadosDS403> dados = List();
    for (var dadosDS403 in dadosJson) {
      DadosDS403 dadosDS = DadosDS403(
          dadosDS403["id"], dadosDS403["descricao"], dadosDS403["foto"]);
      dados.add(dadosDS);
    }
    return dados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Api rest"),
      ),
      body: FutureBuilder<List<DadosDS403>>(
        future: _recuperaDados(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print("None");
              break;
            case ConnectionState.waiting:
              print("esperando");
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.active:
              print("ativo ");
              break;
            case ConnectionState.done:
              print("Feito");
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    List<DadosDS403> lista = snapshot.data;
                    DadosDS403 dados = lista[index];
                    Uint8List imgConv = base64Decode(dados.foto);
                    return ListTile(
                        title: Text("id =" + dados.id.toString()),
                        subtitle: Text(dados.descricao),
                        trailing: Image.memory(imgConv),
                        onTap: () {
                          print("tocou no " + dados.id.toString());
                        });
                  });
              break;
          }
        },
      ),
    );
  }
}
