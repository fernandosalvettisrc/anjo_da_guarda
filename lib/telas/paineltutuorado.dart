import 'package:flutter/material.dart';
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
      
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
        children: <Widget>[ Container(child: ConstrainedBox(
    constraints: BoxConstraints.expand(),
    child: FlatButton(onPressed: null,
        child: Image.asset('assets/botao_alerta.png'))
        )),
         Container(child: ConstrainedBox(
    constraints: BoxConstraints.expand(),
    child: FlatButton(onPressed: null,
        child: Image.asset('assets/rota.png'))
        ))],
        
        
          ),
          Row(
        children: <Widget>[ Container(child: ConstrainedBox(
    constraints: BoxConstraints.expand(),
    child: FlatButton(onPressed: null,
        child: Image.asset('assets/mapa.png'))
        )),
         Container(child: ConstrainedBox(
    constraints: BoxConstraints.expand(),
    child: FlatButton(onPressed: null,
        child: Image.asset('assets/chat.png'))
        ))],
        
        
          ),
        ],
      )
      );
    
  }
}