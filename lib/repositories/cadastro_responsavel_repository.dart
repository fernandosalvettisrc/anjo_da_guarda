import 'package:anjotcc/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CadastrarResponsavelRepository {
  cadastrarUsuario(Usuario usuario, context) {
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
              "/painelTutorado",
                  (_) => false
          );
          break;
      }
      //redireciona para o painel, de acordo com o tipoUsuario
    });
  }
}
