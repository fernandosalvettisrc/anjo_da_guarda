import 'package:anjo/telas/login/Login.dart';
import 'package:flutter/material.dart';


import 'Rotas.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a)
);

void main() => runApp(MaterialApp(
  title: "Anjo da guarda",
  home: Login(),
  theme: temaPadrao,
  initialRoute: "/",
  onGenerateRoute: Rotas.gerarRotas,
  debugShowCheckedModeBanner: false,
));
