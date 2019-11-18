import 'package:anjotcc/model/rota.dart';
import 'package:anjotcc/model/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Requisicao {
  String _id;
  String _status;
  Usuario _tutorado;
  Usuario _responsavel;
  Rota _rota;
  Requisicao(){
    Firestore db = Firestore.instance;
    DocumentReference df = db.collection("rota").document();
    this.setId = df.documentID;
  }
  String get getId => _id;
  String get getStatus => _status;
  Usuario get geTutorado => _tutorado;
  Usuario get getResponsavel => _responsavel;
  Rota get getRota => _rota;
  set setId(String id){
    _id = id;
  }
  set setStatus(String status){
    _status = status;
  }
  set setTutorado(Usuario tutorado){
    _tutorado = tutorado;
  }
  set setResponsavel(Usuario responsavel){
    _responsavel = responsavel;
  }
  set setRota(Rota rota){
    _rota = rota;
  }
  Map<String, dynamic> toMap(){
    
    Map<String, dynamic> tutorado = {
      "nome" : this._tutorado.nome,
      "email" : this._tutorado.email,
      "tipoUsuario" : this._tutorado.tipoUsuario,
      "_cep" : this._tutorado.cep,
      "_dataNascimento" : this._tutorado.dataNascimento,
      "_numeroCelular" : this._tutorado.celular,
      "id": this._tutorado.idUsuario,
      "latitude" :this._tutorado.latitude,
      "longitude": this._tutorado.longitude,
    };

    Map<String, dynamic> responsavel = {
      "nome" : this._responsavel.nome,
      "email" : this._responsavel.email,
      "tipoUsuario" : this._responsavel.tipoUsuario,
      "_cep" : this._responsavel.cep,
      "_dataNascimento" : this._responsavel.dataNascimento,
      "_numeroCelular" : this._responsavel.celular,
      "id": this._responsavel.idUsuario,
    };

    Map<String, dynamic> rota = {
      "rua": this._rota.rua,
      "numero": this._rota.numero,
      "bairro": this._rota.bairro,
      "cep": this._rota.cep,
      "latitude": this._rota.lat,
      "longitude": this._rota.long
    };

    Map<String, dynamic> dadosRequisicaoRota = {
      "id" : this.getId,
      "status" : this._status,
      "tutorado" : tutorado,
      "responsavel" : responsavel,
      "rota" : rota,
    };

    return dadosRequisicaoRota;

  }
}
