import 'package:flutter/material.dart';
// importa as classes http que serão necessárias

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:servicoavancado2/postDados.dart';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  // precisa definir o tipo de retorno do Futere no nosso caso um Map
  String URLbase = "https://www.slmm.com.br/ws/exe1/index2.php?ra=12346";

  // neste exemplo vamos retornar uma lista de objetos
  // o qual é criado em outro arquivo
  Future<List<PostDados>> _recuperaDados() async {
    // realiza um consulta http do tipo get no servidor
    //List<PostDados> lista = List();

    http.Response response = await http.get(URLbase);
    var dadosJson = json.decode(response.body);

    //print(dadosJson);
    List<PostDados> postagem = List();

    var ra = dadosJson["dados"]["ra"];
    print(ra);

    for (var postDados in dadosJson["dados"]["images"]) {
      //  print("---------------------");
      //  print(postDados);
      PostDados p = PostDados(postDados["id"], postDados["lat"],
          postDados["lgt"], postDados["img_64"]);
      postagem.add(p);
    }
    //print(postagem.toString());
    return postagem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("lista"),
      ),
      body: FutureBuilder<List<PostDados>>(
        future: _recuperaDados(), //  dados que voce vai receber
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print("Conexão none");
              break;
            case ConnectionState.waiting:
              print("Conexão esperando");
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.active:
              print("Conexão ativo");
              break;
            case ConnectionState.done:
              // aqui podemos fazer verificação
              if (snapshot.hasError) {
                print("Erro na operação");
              } else {
                print("ok");
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      List<PostDados> lista = snapshot.data;
                      PostDados dados = lista[index];
                      Uint8List imgConv = base64Decode(dados.img_64);
                      return ListTile(
                        title: Text(dados.id.toString()),
                        subtitle: Text(dados.lat),
                        leading: Image.memory(imgConv),
                        onTap: () {
                          print("tocou " + dados.id.toString());
                        },
                        //Image.memory(imgConv),
                      );
                    });
              }
              print("Conexão done");
              //resultado = "Finalizado";
              break;
          }
          return Center(
            child: Text("nao ok"),
          );
        }, // no builder ha dois parametros context e snapshot (dados recebidos)
        // ha metodos que indicam se houve erro , indicam o estado da conexão onde podemor
        // colocar por exemplo uma animação
      ),
    );
  }
}
