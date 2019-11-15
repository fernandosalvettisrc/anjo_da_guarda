import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PainelTutorado extends StatefulWidget {
  @override
  _PainelTutoradoState createState() => _PainelTutoradoState();
}

class _PainelTutoradoState extends State<PainelTutorado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("painel tutorado"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  label: Text("Alerta"),
                  icon: Icon(Icons.warning, color: Colors.red),
                ),
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  icon: Icon(
                    Icons.map,
                    color: Colors.teal[900],
                  ),
                  label: Text("Minhas rotas"),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  label: Text("Minha localização"),
                  icon: Icon(
                    Icons.place,
                    color: Colors.teal[900],
                  ),
                ),
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  label: Text("Chat"),
                  icon: Icon(
                    Icons.forum,
                    color: Colors.teal[900],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
