import 'package:anjotcc/model/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioFirebase {
  static Future<FirebaseUser> getUsuarioAtual() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return await firebaseAuth.currentUser();
  }

  static Future<Usuario> getResponsavel() async {
    FirebaseUser firebaseUser = await getUsuarioAtual();
    String idUsuario = firebaseUser.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").document(idUsuario).get();
    Map dados = snapshot.data;
    String tipoUsuario = dados["tipoUsuario"];
    String email = dados["email"];
    String nome = dados["nome"];
    String idade = dados["_dataNascimento"];
    String cep = dados["_cep"];
    String numeroCelular = dados["_numeroCelular"];
    Usuario usuario = Usuario();
    usuario.setIdUsuario = idUsuario;
    usuario.setTipoUsuario = tipoUsuario;
    usuario.setEmail = email;
    usuario.setNome = nome;
    usuario.setdataNascimento = idade;
    usuario.setCep = cep;
    usuario.setCelular = numeroCelular;
    return usuario;
  }
  static Future<Usuario> getTutorado() async {
    FirebaseUser firebaseUser = await getUsuarioAtual();
    String idUsuario = firebaseUser.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await db
        .collection("usuarios")
        .document(idUsuario)
        .collection("idTutorado")
        .document(idUsuario)
        .get();
    Map<String, dynamic> pegaIdFilho = snapshot.data;
    String idFilho = pegaIdFilho["id"];
    DocumentSnapshot snapshotFilho =
          await db.collection("usuarios").document(idFilho).get();
      Map<String, dynamic> dados = snapshotFilho.data;
    String tipoUsuario = dados["tipoUsuario"];
    String email = dados["email"];
    String nome = dados["nome"];
    String idade = dados["_dataNascimento"];
    String cep = dados["_cep"];
    String numeroCelular = dados["_numeroCelular"];
    Usuario usuario = Usuario();
    usuario.setIdUsuario = idFilho;
    usuario.setTipoUsuario = tipoUsuario;
    usuario.setEmail = email;
    usuario.setNome = nome;
    usuario.setdataNascimento = idade;
    usuario.setCep = cep;
    usuario.setCelular = numeroCelular;
    return usuario;
  }
}
