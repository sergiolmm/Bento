import 'package:flutter/material.dart';

class QuartaTela extends StatefulWidget {
  @override
  int vInt;
  String nome;

  QuartaTela({this.vInt, this.nome = "sergio"});

  _QuartaTelaState createState() => _QuartaTelaState();
}

class _QuartaTelaState extends State<QuartaTela> {
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
                  Navigator.pop(context);
                },
              )
            ],
          )),
    );
  }
}
