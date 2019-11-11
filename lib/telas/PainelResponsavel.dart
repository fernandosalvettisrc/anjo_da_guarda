import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class PainelResponsavel extends StatefulWidget {
  @override
  _PainelResponsavelState createState() => _PainelResponsavelState();
}

class _PainelResponsavelState extends State<PainelResponsavel> {
  List<String> itensMenu=[
    "configuraçoes","Deslogar"
  ];
  _deslogarUsuario() async{
FirebaseAuth auth=FirebaseAuth.instance;
await auth.signOut();
Navigator.pushReplacementNamed(context,"/");
  }
  _escolhaItemMenu(String escolha){
    switch(escolha){
      case "Deslogar":
      _deslogarUsuario();
      break;
       case "Configuraçao":
      //criar metodo
      break;
    }

  }
  @override
  Widget build(BuildContext context) {
    return    Scaffold(
      appBar: AppBar(
        title: Text("Painel Responsavel"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected:_escolhaItemMenu ,
            itemBuilder: (context){
              return itensMenu.map((String item){
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                ); 

              })
              .toList();

            },
          )
        ],
      ),
      body: Container(),
    );
}
}