import 'package:anjotcc/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class CadastrarTutoradoRepository {
  
    cadastrarUsuario(Usuario usuario, String id, context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      db
          .collection("usuarios")
          .document(firebaseUser.user.uid)
          .setData(usuario.toMap());
      String idFilho = firebaseUser.user.uid;
      db
          .collection("usuarios")
          .document(id).updateData({"idconecta" : idFilho});
          switch( usuario.tipoUsuario ){
        case "responsavel" :
          Navigator.pushNamedAndRemoveUntil(
              context,
              "/painelResponsavel",
              (_) => false
          );
          break;
        case "tutorado" :
          Navigator.pushNamedAndRemoveUntil(
              context,
              "/painelResponsavel",
                  (_) => false
          );
          break;
      }
    }).catchError((error) {

    });
  }
}