class UsuarioModel {
  String id;
  String nome;
  String uf;
  String cpf;
  String dataNasc;
  String cep;
  String number;
  bool tipoUsuario;

  UsuarioModel(
            {
              this.id,
              this.tipoUsuario,
              this.nome,
              this.uf,
              this.cpf,
              this.dataNasc,
              this.cep,
              this.number
            }
          );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "tipoUsuario": tipoUsuario,
    "uf": uf,
    "cpf": cpf,
    "dataNasc": dataNasc,
    "cep": cep,
    "number": number,
};

  
  
  factory UsuarioModel.fromMap(String id, Map data) {
    data = data ?? { };
  
    return UsuarioModel(
      cpf: data["cpf"] ?? "",
      dataNasc: data["dataNasc"] ?? "",
      id: id ?? "",
      nome: data["nome"] ?? "",
      uf: data["uf"] ?? "",
      cep: data["cep"] ?? "",
      number: data["number"] ?? "",
      tipoUsuario: data["tipoUsuario"] ?? true,
    );
  }
}