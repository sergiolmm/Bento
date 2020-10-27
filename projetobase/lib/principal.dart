import 'package:flutter/material.dart';

TextStyle estilo1 = new TextStyle(
    backgroundColor: Colors.cyan,
    fontSize: 50,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    color: Colors.red);
TextStyle estilo2 = new TextStyle(
    backgroundColor: Colors.yellowAccent,
    fontSize: 40,
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    color: Colors.pink);

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  @override
  String str1 = "ALO Mundo";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Projeto Base"),
        backgroundColor: Colors.blue[100],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Corpo",
              style: TextStyle(
                  backgroundColor: Colors.cyan,
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Colors.red),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("texto 1"),
                RaisedButton(
                  child: Text("Outro Btn"),
                  onPressed: (){
                    setState(() {
                      str1 = "Clicou noutro botao";
                    });
                  },
                ),
                FlatButton(
                  child: Text("clique"),
                  hoverColor: Colors.red,
                  onPressed: () {
                    setState(() {
                      str1 = "Voce clicou";
                    });
                  },
                ),
                Text("texto 3"),
              ],
            ),
            
            Text("Corpo", style: estilo1),
            Text(str1, style: estilo2),
          ],
        ),
      ),
    );
  }
}
