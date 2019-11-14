import 'package:anjotcc/telas/login.dart';
import 'package:anjotcc/telas/paineltutuorado.dart';
import 'package:flutter/material.dart';


import 'rotas.dart';

final ThemeData temaPadrao = ThemeData(
    primaryColor: Color(0xff37474f),
    accentColor: Color(0xff546e7a)
);

void main() => runApp(MaterialApp(
  title: "Anjo da guarda",
  home: PainelTutorado(),
  theme: temaPadrao,
  initialRoute: "/",
  onGenerateRoute: Rotas.gerarRotas,
  debugShowCheckedModeBanner: false,
));