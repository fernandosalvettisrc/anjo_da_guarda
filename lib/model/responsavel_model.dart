class ResponsavelModel {
  String id;
  String nome;
  String uf;
  String cpf;
  String dataNasc;
  String cep;
  String number;

  ResponsavelModel(
            {
              this.id,
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
    "uf": uf,
    "cpf": cpf,
    "dataNasc": dataNasc,
    "cep": cep,
    "number": number,
};

  
  
  factory ResponsavelModel.fromMap(String id, Map data) {
    data = data ?? { };
  
    return ResponsavelModel(
      cpf: data["cpf"] ?? "",
      dataNasc: data["dataNasc"] ?? "",
      id: id ?? "",
      nome: data["nome"] ?? "",
      uf: data["uf"] ?? "",
      cep: data["cep"] ?? "",
      number: data["number"] ?? "",
    );
  }
}