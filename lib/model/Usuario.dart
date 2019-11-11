
class Usuario {

  String _idUsuario;
  String _nome;
  String _email;
  String _senha;
  String _tipoUsuario;
  String _datadeNascimento;
  String _cep;
  String _numeroCelular;
  Usuario();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "nome" : this.nome,
      "email" : this.email,
      "tipoUsuario" : this.tipoUsuario,
      "_cep" : this._cep,
      "_dataNascimento" : this._datadeNascimento,
      "_numeroCelular" : this._numeroCelular,
    };

    return map;

  }

  String verificaTipoUsuario(bool tipoUsuario){
    return tipoUsuario ? "tutorado" : "responsavel";
  }

  String get tipoUsuario => _tipoUsuario;

  set setTipoUsuario(String value) {
    _tipoUsuario = value;
  }

  String get senha => _senha;

  set setSenha(String value) {
    _senha = value;
  }

  String get email => _email;

  set setEmail(String value) {
    _email = value;
  }

  String get nome => _nome;

  set setNome(String value) {
    _nome = value;
  }

  String get idUsuario => _idUsuario;

  set setIdUsuario(String value) {
    _idUsuario = value;
  }
  String get cep => _cep;

  set setCep(String value){
    _cep = value;
  }
   String get dataNascimento => _datadeNascimento;

  set setdataNascimento(String value){
    _datadeNascimento = value;
  }
   String get celular => _numeroCelular;

  set setCelular(String value){
    _numeroCelular = value;
  }
}