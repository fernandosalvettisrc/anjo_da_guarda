class Mensagem{
  String _idUsuario;
  String _mensagem;
  Mensagem();
  String get idUsuario => _idUsuario;
  String get mensagem => _mensagem;
  set setMensagem(String msg) {
    _mensagem = msg;
  }
   set setIdUsuario(String id) {
    _idUsuario = id;
  }
   Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "idUsuario" : this.idUsuario,
      "mensagem" : this.mensagem,
    };

    return map;

  }
}