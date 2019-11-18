class Rota {
  String _rua;
  String _numero;
  String _cidade;
  String _bairro;
  String _cep;
  double _latitude;
  double _longitude;

  Rota();

  String get rua => _rua;
  String get numero => _numero;
  String get cidade => _cidade;
  String get bairro => _bairro;
  String get cep => _cep;
  double get long => _longitude;

  double get lat => _latitude;

  set setLatitude(double lat) {
    _latitude = lat;
  }

  set setLongitude(double long) {
    _longitude = long;
  }
  set setRua(String rua) {
    _rua = rua;
  }
  
  set setNum(String nume) {
    _numero = nume;
  }
  set setCidade(String cidade) {
    _cidade = cidade;
  }
  set setBairro(String bairro) {
    _bairro = bairro;
  }
  set setCep(String cep) {
    _cep = cep;
  }
}
