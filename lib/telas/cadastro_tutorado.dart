import 'package:anjotcc/model/id.dart';
import 'package:flutter/material.dart';
import 'package:anjotcc/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masked_text/masked_text.dart';

class CadastroTutorado extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<CadastroTutorado> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerIdade = TextEditingController();
  TextEditingController _controllerCep = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _tipoUsuario = true;
  String _mensagemErro = "";
  bool _obscureText = true;
  Color corIcon = Colors.black;
  Color corIconSenha = Colors.black;
  bool _obscureTextSenha = true;
  _validarCampos() {
    //Recuperar dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String idade = _controllerIdade.text;
    String celular = _controllerCelular.text;
    String cep = _controllerCep.text;

    //validar campos
    if (int.parse(idade) <= 14 && _tipoUsuario == true) {
      if (nome.isNotEmpty) {
        if (email.isNotEmpty && email.contains("@")) {
          if (senha.isNotEmpty && senha.length > 6) {
            Usuario usuario = Usuario();
            usuario.setNome = nome;
            usuario.setEmail = email;
            usuario.setSenha = senha;
            usuario.setTipoUsuario = usuario.verificaTipoUsuario(_tipoUsuario);
            usuario.setdataNascimento = idade;
            usuario.setCep = cep;
            usuario.setCelular = celular;

            _cadastro();
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
      } else {
        setState(() {
          _mensagemErro = "Preencha o Nome";
        });
      }
    } else {
      setState(() {
        _mensagemErro =
            "Você não pode ser um tutorado, você possuí mais de 14 anos";
      });
    }
  }

  _cadastro() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    if (usuarioLogado != null) {
      String idUsuario = usuarioLogado.uid;
      String nome = _controllerNome.text;
      String email = _controllerEmail.text;
      String senha = _controllerSenha.text;
      String idade = _controllerIdade.text;
      String celular = _controllerCelular.text;
      String cep = _controllerCep.text;
      Usuario usuario = Usuario();
      usuario.setNome = nome;
      usuario.setEmail = email;
      usuario.setSenha = senha;
      usuario.setTipoUsuario = usuario.verificaTipoUsuario(_tipoUsuario);
      usuario.setdataNascimento = idade;
      usuario.setCep = cep;
      usuario.setCelular = celular;
      _cadastrarUsuario(usuario, idUsuario);
    }
  }

  _cadastrarUsuario(Usuario usuario, String id) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    Firestore db = Firestore.instance;
    Id idTuto = Id();
    Id idRespon = Id();
    idRespon.idEstrangeira = id;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      db
          .collection("usuarios")
          .document(firebaseUser.user.uid)
          .setData(usuario.toMap());
          db.collection("usuarios").document(firebaseUser.user.uid).collection("idResponsavel").document(firebaseUser.user.uid).setData(idRespon.toMap());
      //redireciona para o painel, de acordo com o tipoUsuario
      idTuto.idEstrangeira = firebaseUser.user.uid;
      db
          .collection("usuarios")
          .document(id)
          .collection("idTutorado")
          .document(id).setData(idTuto.toMap());
      switch (usuario.tipoUsuario) {
        case "responsavel":
          Navigator.pushNamedAndRemoveUntil(
              context, "/painelResponsavel", (_) => false);
          break;
        case "tutorado":
          Navigator.pushNamedAndRemoveUntil(
              context, "/painelTutorado", (_) => false);
          break;
      }
    }).catchError((error) {
      _mensagemErro = "Erro ao cadastrar o usuario, o e-mail já esta em uso";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro do tutorado"),
        backgroundColor: Colors.teal[900],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerNome,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Nome completo",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.teal[900]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.mail, color: Colors.teal[900]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerSenha,
                    obscureText: _obscureTextSenha,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefix: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: corIconSenha,
                        ),
                        onPressed: () {
                          setState(() {
                            if (corIconSenha == Colors.black) {
                              _obscureTextSenha = false;
                            } else {
                              _obscureTextSenha = true;
                            }
                            if (corIconSenha == Colors.black) {
                              corIconSenha = Colors.teal[900];
                            } else {
                              corIconSenha = Colors.black;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaskedTextField(
                    maskedTextFieldController: _controllerCep,
                    mask: "xxxxx-xxx",
                    maxLength: 9,
                    keyboardType: TextInputType.number,
                    inputDecoration: InputDecoration(
                        labelText: "CEP",
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        prefixIcon:
                            Icon(Icons.keyboard, color: Colors.teal[900])),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerIdade,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Idade",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.teal[900]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaskedTextField(
                    maskedTextFieldController: _controllerCelular,
                    keyboardType: TextInputType.number,
                    mask: "(xx)xxxxx-xxxx",
                    maxLength: 14,
                    inputDecoration: InputDecoration(
                      labelText: "Celular",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon: Icon(Icons.mail, color: Colors.teal[900]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      color: Colors.teal[600],
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
