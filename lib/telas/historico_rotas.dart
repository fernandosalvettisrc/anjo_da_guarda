import 'dart:async';

import 'package:anjotcc/util/firebaseuser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoricoDeRotas extends StatefulWidget {
  @override
  _HistoricoDeRotasState createState() => _HistoricoDeRotasState();
}

class _HistoricoDeRotasState extends State<HistoricoDeRotas> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  Firestore db = Firestore.instance;
  void _geraLista() async {
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    Stream<QuerySnapshot> _adicionarListenerRotas() {
      final stream = db
          .collection("rota")             
          .where("id", isEqualTo: firebaseUser.uid)
          .snapshots();
      stream.listen((dados) {
        _controller.add(dados);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mensagemCarregando = Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Carregando histórico de rotas"),
          CircularProgressIndicator()
        ],
      ),
    );
    var mensagemNaoPossuiRotas = Center(
      child: Container(
        child: Text("Você não definiu nenhuma rota"),
      ),
    );
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return mensagemCarregando;
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Text("Erro ao carregar o histórico de rotas");
              } else {
                QuerySnapshot querySnapshot = snapshot.data;
                if (querySnapshot.documents.length == 0) {
                  return mensagemNaoPossuiRotas;
                } else {
                  return ListView.separated(
                    separatorBuilder: (context, indice) => Divider(
                      height: 2.0,
                      color: Colors.grey,
                    ),
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {
                      List<DocumentSnapshot> rotas =
                          querySnapshot.documents.toList();
                      DocumentSnapshot item = rotas[indice];
                      String rua = item["rota"]["rua"];
                      String numero = item["rota"]["numero"];
                      String bairro = item["rota"]["bairro"];
                      return ListTile(title: Text("Rota: $rua, $numero, $bairro"),);
                    },
                  );
                }
              }
              break;
          }
        },
      ),
    );
  }
}
