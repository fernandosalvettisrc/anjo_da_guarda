import 'dart:async';

import 'package:anjotcc/model/mensagem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Firestore db = Firestore.instance;

  String _nome;
  String _idEstrangeira;
  String _idUser;
  TextEditingController _controllerMensagem = TextEditingController();
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController scrollController = ScrollController();

  _enviarMensagem() async {
    String txtmensagem = _controllerMensagem.text;
    if (txtmensagem.isNotEmpty) {
      Mensagem mensagem = Mensagem();
      mensagem.setMensagem = txtmensagem;
      mensagem.setIdUsuario = _idUser;
      salvarMensagem(_idUser, _idEstrangeira, mensagem);
      salvarMensagem(_idEstrangeira, _idUser, mensagem);
    } else {}
  }

  salvarMensagem(
      String idRemetente, String idDestinatario, Mensagem msg) async {
    await db
        .collection("mensagens")
        .document(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());
    _controllerMensagem.clear();
  }

  _pegaDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    _idUser = usuarioLogado.uid;
    Firestore bd = Firestore.instance;
    //pega id do Filho
    DocumentSnapshot snapshot =
        await bd.collection("usuarios").document(_idUser).get();
    Map<String, dynamic> dados = snapshot.data;
    _idEstrangeira = dados["idconecta"];
    _adicionarListenerMensagem();
    //pega localização do filho
    if (_idEstrangeira != null) {
      DocumentSnapshot documentSnapshotFilho =
          await bd.collection("usuarios").document(_idEstrangeira).get();
      Map<String, dynamic> dadosFilho = documentSnapshotFilho.data;
      setState(() {
        _nome = dadosFilho["nome"];
        _idUser = usuarioLogado.uid;
        _idEstrangeira = dados["idconecta"];
      });
    } else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "$_nome ainda não fez um primeiro login no app, não é possível pegar a sua localização atual"),
              contentPadding: EdgeInsets.all(10),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cadastrar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  Stream<QuerySnapshot> _adicionarListenerMensagem() {
    final stream = db
        .collection("mensagens")
        .document(_idUser)
        .collection(_idEstrangeira)
        .snapshots();
    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(seconds: 1), (){
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    });
  }

  @override
  void initState() {
    _pegaDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: TextField(
                controller: _controllerMensagem,
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    hintText: "Digite aqui...",
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                      borderSide: new BorderSide(),
                    ),
                    fillColor: Colors.white.withOpacity(1.0),
                    filled: true),
              ),
            ),
          ),
          FloatingActionButton(
            backgroundColor: Colors.teal[600],
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: _enviarMensagem,
          )
        ],
      ),
    );
    var stream = StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando mensagens"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            if (snapshot.hasError) {
              return Expanded(
                child: Text("Erro ao carregar Mensagens!"),
              );
            } else {
              return Expanded(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {
                      //recupera mensagem
                      List<DocumentSnapshot> mensagens =
                          querySnapshot.documents.toList();
                      DocumentSnapshot item = mensagens[indice];

                      double larguraContainer =
                          MediaQuery.of(context).size.width * 0.8;

                      //Define cores e alinhamentos
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Color(0xffd2ffa5);
                      if (_idUser != item["idUsuario"]) {
                        alinhamento = Alignment.centerLeft;
                        cor = Colors.white;
                      }

                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: larguraContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(
                              item["mensagem"],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }

            break;
        }
      },
    );
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        title: Text("$_nome"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              stream,
              caixaMensagem,
            ],
          ),
        )),
      ),
    );
  }
}
