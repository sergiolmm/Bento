import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: true, home: home2()));
}

class home1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      color: Colors.blue[100],
      child: Column(
        children: [
          Text(
            "Alo Mundo",
            style: TextStyle(fontSize: 30, color: Colors.amberAccent),
          ),
          Text(
            "Estou abaixo",
            style: estilo1,
          )
        ],
      ),
    );
  }
}

TextStyle estilo1 =
    TextStyle(fontSize: 35, color: Colors.blue, fontStyle: FontStyle.italic);

class home2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Informatica",
            style: estilo1,
          ),
          backgroundColor: Colors.amberAccent,
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          color: Colors.blue[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Alo Mundo",
                style: TextStyle(fontSize: 30, color: Colors.amberAccent),
              ),
              Text(
                "Estou abaixo",
                style: estilo1,
              ),
              Row(
                children: [
                  Text("alo"),
                  Text(" Bem")
                  
                ],
              )
            ],
          ),
        ));
  }
}
