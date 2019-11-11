import 'package:anjo/telas/cadastro/Cadastro.dart';
import 'package:anjo/telas/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:anjo/telas/PainelTutorado.dart';
import 'package:anjo/telas/PainelResponsavel.dart';

class Rotas {
  static Route<dynamic> gerarRotas(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Login());
      case "/cadastro":
        return MaterialPageRoute(builder: (_) => Cadastro());
      case "/painelResponsavel":
        return MaterialPageRoute(builder: (_) => PainelResponsavel());
      case "/painelTutorado":
        return MaterialPageRoute(builder: (_) => PainelTutorado());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada!"),
        ),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
