
class Id {
  String idEstrangeira;
  Id();

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "id" : this.idEstrangeira,
    };

    return map;

  }

  String get id => idEstrangeira;

  set setSenha(String id) {
    idEstrangeira = id;
  }
}