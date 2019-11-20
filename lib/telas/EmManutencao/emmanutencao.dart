import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmManutencao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: (Text(
          "Em Manutenção!",
          style: TextStyle(color: Colors.white),
        )),
        elevation: 0.0,
        backgroundColor: const Color(0XFF004D40),
      ),
      body: new Center(child: new Icon(Icons.build),)
    );
  }
}