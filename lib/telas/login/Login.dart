import 'package:anjo/model/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  var linearGradient = const BoxDecoration(
    gradient: const LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: <Color>[
        const Color(0xFFFFFFFF),
        const Color(0xFFFFFFFF),
        const Color(0xFFFFFFFF),
        const Color(0xFF00897B),
        const Color(0xFF00796B),
        const Color(0XFF004D40),
      ],
    ),
  );
  String _mensagemErro = "";
  _validarCampos() {
    //Recuperar dados dos campos

    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    //validar campos
    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty && senha.length > 6) {
        Usuario usuario = Usuario();

        usuario.setEmail = email;
        usuario.setSenha = senha;

        _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha! digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o E-mail válido";
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Navigator.pushReplacementNamed(context, "/painelResponsavel");
    }).catchError((error) {
      _mensagemErro =
          "Erro ao autenticar o usuario, Verifique e tente novamente";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anjo da Guarda'),
        backgroundColor: Colors.teal[900],
      ),
      body: Container(
        decoration: linearGradient,
        child: Form(
          child: ListView(
              children: <Widget>[
                Image.asset(
                  'imagens/logo.png',
                  height: 200,
                  width: 200,
                ),
                TextFormField(
                  controller: _controllerEmail,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "E-mail",
                    icon: Icon(Icons.email),
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: _controllerSenha,
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Password',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.white,
                      child: Text(
                        "Entrar",
                        style: TextStyle(color: Colors.black,),
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                FlatButton(
                  child: (Text(
                    "Não tem conta? cadastre-se!",
                    style: TextStyle(color: Colors.white),
                  )),
                  onPressed: () {
                    Navigator.pushNamed(context, "/cadastro");
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }
}