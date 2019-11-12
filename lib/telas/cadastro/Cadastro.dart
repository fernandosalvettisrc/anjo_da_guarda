import 'package:flutter/material.dart';
import 'package:anjo/model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masked_text/masked_text.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerIdade = TextEditingController();
  TextEditingController _controllerCep = TextEditingController();
  TextEditingController _controllerCelular = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  bool _tipoUsuario = false;
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
      if (int.parse(idade) >= 18 && _tipoUsuario == false || int.parse(idade) <= 14 && _tipoUsuario == true)  {
        if (nome.isNotEmpty) {
          if (email.isNotEmpty && email.contains("@")) {
            if (senha.isNotEmpty && senha.length > 6) {
              
              
              Usuario usuario = Usuario();
              usuario.setNome = nome;
              usuario.setEmail = email;
              usuario.setSenha = senha;
              usuario.setTipoUsuario =
                  usuario.verificaTipoUsuario(_tipoUsuario);
              usuario.setdataNascimento = idade;
              usuario.setCep = cep;
              usuario.setCelular = celular;

              _cadastrarUsuario(usuario);
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
          _mensagemErro = "Você não pode selecionar este tipo de usuário";
        });
      }
  }

  _cadastrarUsuario(Usuario usuario) {
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

      //redireciona para o painel, de acordo com o tipoUsuario
      switch (usuario.tipoUsuario) {
        case "responsavel":
          Navigator.pushNamedAndRemoveUntil(
              context, "/painelResponsavel", (_) => false);
              setState(() {
                _mensagemErro = "sou responsavel";
              });
          break;
        case "tutorado":
          Navigator.pushNamedAndRemoveUntil(
              context, "/painelTutorado", (_) => false);
              setState(() {
                _mensagemErro = "sou tutorado";
              });
          break;
      }
    }).catchError((error) {
      _mensagemErro =
          "Erro ao cadastrar o usuario, o e-mail já esta em uso";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Responsavel"),
                      Switch(
                          value: _tipoUsuario,
                          onChanged: (bool valor) {
                            setState(() {
                              _tipoUsuario = valor;
                            });
                          }),
                      Text("Tutorado"),
                    ],
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