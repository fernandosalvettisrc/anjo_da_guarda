import 'package:anjo_guarda/screens/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anjo_guarda/repositories/user_repository.dart';
import 'package:anjo_guarda/bloc/login/bloc.dart';

class LoginScreen extends StatefulWidget {
  final UserRepository _userRepository;

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc;
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
  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    super.initState();
    _loginBloc = LoginBloc(
      userRepository: _userRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anjo da Guarda'),
        backgroundColor: Colors.teal,
      ),
      body: BlocProvider<LoginBloc>(
          bloc: _loginBloc,
          child: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: linearGradient,
            child: LoginForm(userRepository: _userRepository),
          )),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
