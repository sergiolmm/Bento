import 'package:flutter/material.dart';
// importa as classes http que serão necessárias

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class principal extends StatefulWidget {
  @override
  _principalState createState() => _principalState();
}

class _principalState extends State<principal> {
  // precisa definir o tipo de retorno do Futere no nosso caso um Map
  Future<Map> _recuperaDados() async {
    String URL = "https://www.slmm.com.br/ws/exe1/index2.php?ra=12345";

    // realiza um consulta http do tipo get no servidor
    http.Response response = await http.get(URL);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperaDados(), //  dados que voce vai receber
      builder: (context, snapshot) {
        String resultado;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            print("Conexão none");
            break;
          case ConnectionState.waiting:
            print("Conexão esperando");
            resultado = "Carregando";
            break;
          case ConnectionState.active:
            print("Conexão ativo");
            break;
          case ConnectionState.done:
            // aqui podemos fazer verificação
            if (snapshot.hasError) {
              resultado = "Erro no operação";
            } else {
              String resposta = snapshot.data["response"];
              String ra = snapshot.data["dados"]["ra"];
              resultado = resposta + " " + ra;
            }
            print("Conexão done");
            //resultado = "Finalizado";
            break;
        }
        return Center(
          child: Text(resultado),
        );
      }, // no builder ha dois parametros context e snapshot (dados recebidos)
      // ha metodos que indicam se houve erro , indicam o estado da conexão onde podemor
      // colocar por exemplo uma animação
    );
  }
}
