import 'package:flutter/material.dart';
import 'package:navegando/Classe1.dart';

class QuintaTela extends StatefulWidget {
  @override
  int vInt;
  String nome;

  QuintaTela({this.vInt, this.nome = "sergio"});

  _QuintaTelaState createState() => _QuintaTelaState();
}

class _QuintaTelaState extends State<QuintaTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tela Com parametro"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Text("Quarta tela -> ${widget.vInt} -- ${widget.nome} "),
              RaisedButton(
                child: Text("Voltar"),
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Classe1 classe1 = Classe1("Sergio", DateTime(2020, 17, 11));

                  Navigator.pop(context, classe1);
                  
                },
              )
            ],
          )),
    );
  }
}
