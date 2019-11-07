import 'package:anjo_guarda/model/responsavel_model.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RegisterEvent extends Equatable {
  RegisterEvent([List props = const []]) : super(props);
}

class CPFChanged extends RegisterEvent {
  final String cpf;

  CPFChanged({@required this.cpf}) : super([cpf]);

  @override
  String toString() => 'CPFChanged { cpf :$cpf }';
}

class UFChanged extends RegisterEvent {
  final String uf;

  UFChanged({@required this.uf}) : super([uf]);

  @override
  String toString() => 'UFChanged { uf :$uf }';
}
class NumberChanged extends RegisterEvent {
  final String number;

  NumberChanged({@required this.number}) : super([number]);

  @override
  String toString() => 'DataChanged { data :$number }';
}

class NomeChanged extends RegisterEvent {
  final String nome;

  NomeChanged({@required this.nome}) : super([nome]);

  @override
  String toString() => 'DataChanged { data :$nome }';
}

class DataChanged extends RegisterEvent {
  final String data;

  DataChanged({@required this.data}) : super([data]);

  @override
  String toString() => 'DataChanged { data :$data }';
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email}) : super([email]);

  @override
  String toString() => 'EmailChanged { email :$email }';
}

class PasswordVerifyChanged extends RegisterEvent {
  final String password;
  final String passwordVerify;

  PasswordVerifyChanged({@required this.password, @required this.passwordVerify}) : super([password, passwordVerify]);

  @override
  String toString() => 'PasswordVerifyChanged { passwordVerify: $passwordVerify }';
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password}) : super([password]);

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final UsuarioModel novoUsuario;
  Submitted({@required this.email, @required this.password, @required this.novoUsuario})
      : super([email, password, novoUsuario]);

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }
}