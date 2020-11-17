import 'package:flutter/material.dart';

class TerceiraScreen extends StatefulWidget {
  int vInt;
  String nome;

  TerceiraScreen(this.vInt);
  //TerceiraScreen({this.nome = "Sergio"});

  @override
  _TerceiraScreenState createState() => _TerceiraScreenState();
}

class _TerceiraScreenState extends State<TerceiraScreen> {
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
              Text("Terceira tela -> ${widget.vInt} "),
            ],
          )),
    );
  }
}
