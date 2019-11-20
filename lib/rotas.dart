
import 'package:anjotcc/telas/Cadastro/cadastro_responsavel.dart';
import 'package:anjotcc/telas/Home/painelresponsavel.dart';
import 'package:anjotcc/telas/Home/paineltutuorado.dart';
import 'package:anjotcc/telas/Login/login.dart';
import 'package:flutter/material.dart';
class Rotas {

  static Route<dynamic> gerarRotas(RouteSettings settings){

    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => Login()
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