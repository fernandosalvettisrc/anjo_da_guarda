import 'package:anjotcc/telas/cadastro_responsavel.dart';
import 'package:anjotcc/telas/login.dart';
import 'package:anjotcc/telas/painelresponsavel.dart';
import 'package:anjotcc/telas/paineltutuorado.dart';
import 'package:flutter/material.dart';
class Rotas {

  static Route<dynamic> gerarRotas(RouteSettings settings){

    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => PainelTutorado()
        );
      case "/cadastro" :
        return MaterialPageRoute(
            builder: (_) => CadastroResponsavel()
        );
      case "/painelResponsavel" :
        return MaterialPageRoute(
            builder: (_) => PainelResponsavel()
        );
      case "/painelTutorado" :
        return MaterialPageRoute(
            builder: (_) => PainelTutorado()
        );
      default:
        _erroRota();
    }

  }

  static Route<dynamic> _erroRota(){

    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(title: Text("Tela não encontrada!"),),
            body: Center(
              child: Text("Tela não encontrada!"),
            ),
          );
        }
    );

  }

}