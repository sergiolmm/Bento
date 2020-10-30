// github/sergiolmmm

// aqui temos 3 opções de listView com imagem e sem
// os items comentados são da primeira versao
// irei gerar 3 exemplos de como fazer isso funcioanar corretamente.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

List _itens = [];
void _carregarLista() {
  _itens = []; // evita problemas do hot reload
  for (int i = 0; i < 10; i++) {
    Map<String, dynamic> item = Map();
    item["id"] = "Bento ${i}";
    item["lat"] = "Lista no flutter ${i}";
    _itens.add(item);
  }
}

class _homeState extends State<home> {
  List _itens2 = [];
  bool obteve = false;
  void _getImageFromUrl() async {
    print("entrei");

    if ((_itens2.isEmpty)) {
      String url = "http://www.slmm.com.br/ws/exe1/index2.php?ra=12345";

      http.Response response;
      response = await http.get(url);
      print("resposta = ${response.statusCode}");
      Map<String, dynamic> retorno = json.decode(response.body);
      //print(retorno);
      print(retorno["success"]);

      Map<String, dynamic> retorno2 = retorno["dados"];
      // print(retorno2);
      print(retorno2["img_qtd"]);
      //print(retorno2["images"]);

      for (int i = 0; i < retorno2["img_qtd"]; i++) {
        _itens2.add(retorno2["images"][i]);
      }
      print("ok");
      setState(() {
        print("obteve dados da url...");
        obteve = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _carregarLista();
    _getImageFromUrl();
    return Scaffold(
        appBar: AppBar(
          title: Text("Listas"),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: new ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              children: List.generate(_itens2.length, (index) {
                Map<String, dynamic> item = Map();
                item = _itens2[index];
                String _imgStr = item["img_64"];
                Uint8List imgConv = base64Decode(_imgStr);
                Image img = Image.memory(imgConv,
                    width: 80, height: 50, fit: BoxFit.fill);
                return SelecaoCard(
                    img: img,
                    item: index,
                    onTap: () {
                      print("tocou ${index}");
                    });
                /*
                return Row(
                  
                  children: [
                    new Container(
                      padding: EdgeInsets.all(8.0),
                      child:Text("Valor DDD ${index}"),
                    ),
                    new Container(
                      padding: EdgeInsets.all(10.0),
                      child: Image.memory(imgConv,
                        width: 100, height: 50, fit: BoxFit.fill),
                    )
                ]);
                */
              }),
            )));
    /*
           ListView.builder(
              itemCount: obteve ? _itens2.length : _itens.length, //obteve ?
              itemBuilder: (context, indice) {
                print("alo -> $indice");
                Map<String, dynamic> item = Map();
                if (obteve) {
                  item = _itens2[indice];
                } else {
                  item = _itens[indice];
                }
                return ListTile(
                  title: Text("${item["id"]}"), // _itens[indice]["id"]),
                  subtitle: Text(item["lat"] + "   " + item["lgt"]),
                  onTap: () {
                    print("onTap");
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("Selecionado ${item["id"]}"),
                              titlePadding: EdgeInsets.all(10),
                              titleTextStyle: TextStyle(
                                  fontSize: 30, color: Colors.blueGrey[300]),
                              content: Text(
                                  "Voce selecionou a opção ${indice} \n O que quer fazer?"),
                              contentPadding: EdgeInsets.all(10),
                              contentTextStyle: TextStyle(
                                  fontSize: 15, color: Colors.deepOrange[300]),
                              backgroundColor: Colors.blue[50],
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("sim"),
                                  onPressed: () {
                                    print("Sim");
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("não"),
                                  onPressed: () {
                                    print("nao");
                                    Navigator.pop(context);
                                  },
                                ),
                              ]);
                        });
                  },
                  onLongPress: () {
                    print("onLongPress");
                  },
                );
              })
             
      ),
      */
    //);
  }
/*
  ListView lvImg = new ListView(
    shrinkWrap: true,
    padding: EdgeInsets.all(20),
    children: List.generate(5, (index) {
      
        item = _itens2[indice];
      String _imgStr = retorno["img_64"];
      Uint8List imgConv = base64Decode(_imgStr);
      return Center(
        child: Text("Valor ${index}"),
        
      );
    }),
  );
  */
}

class SelecaoCard extends StatelessWidget {
  const SelecaoCard({Key key, this.img, this.onTap, @required this.item})
      : super(key: key);

  final Image img;

  final VoidCallback onTap;

  final int item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: Colors.white,
          child: Row(children: [
            new Container(
              padding: EdgeInsets.all(8.0),
              child: Text("Valor novo ${item}"),
            ),
            new Container(padding: EdgeInsets.all(10.0), child: img),
            new Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  child: Text("clique"),
                  onPressed: () {
                    print("botão ${item} acionado");
                    mostra(context);
                  },
                ))
          ])),
    );
  }
}

dynamic mostra(dynamic context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Atenção"),
            titlePadding: EdgeInsets.all(10),
            titleTextStyle:
                TextStyle(fontSize: 30, color: Colors.blueGrey[300]),
            content: Text("Deseja continuar \n O que quer fazer?"),
            contentPadding: EdgeInsets.all(10),
            contentTextStyle:
                TextStyle(fontSize: 15, color: Colors.deepOrange[300]),
            backgroundColor: Colors.blue[50],
            actions: <Widget>[
              FlatButton(
                child: Text("sim"),
                onPressed: () {
                  print("Sim");
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("não"),
                onPressed: () {
                  print("nao");
                  Navigator.pop(context);
                },
              ),
            ]);
      });
}
