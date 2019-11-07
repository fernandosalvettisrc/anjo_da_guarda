import 'package:anjo_guarda/model/responsavel_model.dart';
import 'package:anjo_guarda/screens/register/register_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anjo_guarda/bloc/authentication/bloc.dart';
import 'package:anjo_guarda/bloc/register/bloc.dart';
import 'package:masked_text/masked_text.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _passwordVerifyController =
      TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  int selectTipoUsuario = 0;
  RegisterBloc _registerBloc;
  bool _obscureText = true;
  Color corIcon = Colors.black;
  Color corIconSenha = Colors.black;
  bool _obscureTextSenha = true;
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _cpfController.addListener(_onCPFChanged);
    _dataController.addListener(_onDataChanged);
    _dataController.addListener(_onUFChanged);
    _ufController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _nomeController.addListener(_onNameChanged);
    _numeroController.addListener(_onNumberChanged);
    _passwordVerifyController.addListener(_onPasswordVerifyChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _registerBloc,
      listener: (BuildContext context, RegisterState state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cadastrando...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn());
          Navigator.of(context).pop();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Falha no cadastro'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder(
        bloc: _registerBloc,
        builder: (BuildContext context, RegisterState state) {
          return Form(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nomeController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.teal[900]),
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Nome",
                    ),
                    autocorrect: false,
                    autovalidate: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: Colors.teal[900]),
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "Email"),
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Email inválido' : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureTextSenha,
                    autocorrect: false,
                    autovalidate: true,
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(color: Colors.grey),
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
                        labelText: "Senha"),
                    validator: (_) {
                      return !state.isPasswordValid
                          ? "Conteúdo inválido!"
                          : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordVerifyController,
                    obscureText: _obscureText,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isPasswordVerifyValid
                          ? "Senhas não conferem!"
                          : null;
                    },
                    decoration: InputDecoration(
                      labelText: "Digite sua senha novamente",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefix: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: corIcon,
                        ),
                        onPressed: () {
                          setState(() {
                            if (corIcon == Colors.black) {
                              _obscureText = false;
                            } else {
                              _obscureText = true;
                            }
                            if (corIcon == Colors.black) {
                              corIcon = Colors.teal[900];
                            } else {
                              corIcon = Colors.black;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    value: selectTipoUsuario,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.teal[900],
                    ),
                    style: TextStyle(color: Colors.black),
                    underline: Container(),
                    onChanged: (value) {
                      setState(() {
                        selectTipoUsuario = value;
                      });
                    },
                    items: tipoUsuario,
                  ),
                ),
                MaskedTextField(
                  maskedTextFieldController: _cpfController,
                  mask: "xxx.xxx.xxx-xx",
                  maxLength: 14,
                  keyboardType: TextInputType.number,
                  inputDecoration: InputDecoration(
                      labelText: "CPF",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(),
                      ),
                      prefixIcon:
                          Icon(Icons.keyboard, color: Colors.teal[900])),
                ),
                MaskedTextField(
                  maskedTextFieldController: _cepController,
                  mask: "xxxxx-xxx",
                  maxLength: 9,
                  keyboardType: TextInputType.number,
                  inputDecoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "CEP",
                    prefixIcon: Icon(
                      Icons.place,
                      color: Colors.teal[900],
                    ),
                  ),
                ),
                MaskedTextField(
                  maskedTextFieldController: _dataController,
                  mask: "xx/xx/xxxx",
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  inputDecoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "Data de nascimento",
                    prefixIcon:
                        Icon(Icons.calendar_today, color: Colors.teal[900]),
                  ),
                ),
                MaskedTextField(
                  maskedTextFieldController: _numeroController,
                  mask: "(xx) xxxxx-xxxx",
                  maxLength: 15,
                  keyboardType: TextInputType.number,
                  inputDecoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    labelText: "Celular",
                    prefixIcon:
                        Icon(Icons.phone_android, color: Colors.teal[900]),
                  ),
                ),
                RegisterButton(
                  onPressed:
                      isRegisterButtonEnabled(state) ? _onFormSubmitted : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    _registerBloc.dispatch(
      NomeChanged(nome: _nomeController.text),
    );
  }

  void _onNumberChanged() {
    _registerBloc.dispatch(
      NumberChanged(number: _numeroController.text),
    );
  }

  void _onEmailChanged() {
    _registerBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onCPFChanged() {
    _registerBloc.dispatch(
      CPFChanged(cpf: _cpfController.text),
    );
  }

  void _onDataChanged() {
    _registerBloc.dispatch(
      DataChanged(data: _dataController.text),
    );
  }

  void _onPasswordVerifyChanged() {
    _registerBloc.dispatch(
      PasswordVerifyChanged(
          password: _passwordController.text,
          passwordVerify: _passwordVerifyController.text),
    );
  }

  void _onUFChanged() {
    _registerBloc.dispatch(
      UFChanged(uf: _ufController.text.toUpperCase()),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      Submitted(
          email: _emailController.text,
          password: _passwordController.text,
          novoUsuario: UsuarioModel(
            nome: _nomeController.text,
            cep: _cepController.text,
            cpf: _cpfController.text,
            dataNasc: _dataController.text,
            uf: "RS",
            number: _numeroController.text,
          )),
    );
  }

  final List<DropdownMenuItem> tipoUsuario = [
    DropdownMenuItem(
        value: 0,
        child: Container(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("Tipo de usuário"))),
    DropdownMenuItem(
        value: 1,
        child: Container(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("Responsável"))),
    DropdownMenuItem(
        value: 2,
        child: Container(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("Tutorado"))),
  ];
}
