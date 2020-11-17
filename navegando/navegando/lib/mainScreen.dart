import 'package:flutter/material.dart';
import 'package:navegando/QuintaTela.dart';
import 'package:navegando/SecondScreen.dart';
import 'package:navegando/TerceiraScreen.dart';
import 'package:navegando/quartaTela.dart';
import 'package:navegando/Classe1.dart';

class mainScreen extends StatefulWidget {
  @override
  _mainState createState() => _mainState();
}

String nome = "Alo";

class _mainState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navegando"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(children: <Widget>[
          Text("Navegando entre telas"),
          RaisedButton(
            child: Text("Mudar de tela"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SecondScreen()));
            },
          ),
          RaisedButton(
            child: Text("Mudar de tela 3"),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TerceiraScreen(10)));
            },
          ),
          RaisedButton(
            child: Text("Mudar de tela 4"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuartaTela(vInt: 20, nome: "Juan")));
            },
          ),
          Text(nome),
          RaisedButton(
            child: Text("Mudar para 5 e esperar retorno"),
            onPressed: () {
              _Retorno(context);
            },
          )
        ]),
      ),
    );
  }

  void _Retorno(BuildContext context) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => QuintaTela(
        nome: "Sergio",
        vInt: 40,
      ),
    ),
  ).then((value) {
    if (value != null) {
      print(value);
      Classe1 cla = value as Classe1;
      print(cla.getNome);
      setState(() {
        nome = cla.getNome + "\n\n" + value.getTudo();
      });
    }
  });
}
}


