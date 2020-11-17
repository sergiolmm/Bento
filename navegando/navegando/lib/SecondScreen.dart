import 'package:flutter/material.dart';


class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Segunda tela"),
      backgroundColor: Colors.blueAccent,),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(children: [
          Text("Segunda tela"),
          
        ],)
      ),
      
    );
  }
}