import 'package:anjotcc/model/requisicao_rota.dart';
import 'package:anjotcc/model/rota.dart';
import 'package:anjotcc/util/firebaseuser.dart';
import 'package:anjotcc/util/statusrequisicao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:anjotcc/model/usuario.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class CriarRota extends StatefulWidget {
  @override
  _CriarRotaState createState() => _CriarRotaState();
}

class _CriarRotaState extends State<CriarRota> {
  TextEditingController destino = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> marcador = [];
  String _idRequisicao;
  bool _exibirCaixa = true;
  String textBt = "Definir rota";
  Color _btColor = Colors.teal[600];
  Function function;
  Position localTutorado;
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-29.817131, -51.153620));
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _pegaDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuario = usuarioLogado.uid;
    Firestore bd = Firestore.instance;
    //pega id do Filho
    DocumentSnapshot snapshot =
        await bd.collection("usuarios").document(idUsuario).get();
    Map<String, dynamic> dados = snapshot.data;
    String idFilho = dados["idconecta"];
    //pega localização do filho
    if (dados != null) {
      DocumentSnapshot documentSnapshotFilho =
          await bd.collection("usuarios").document(idFilho).get();
      Map<String, dynamic> dados = documentSnapshotFilho.data;
      double lat = dados["latitude"];
      double long = dados["longitude"];
      if (lat != 0.0 && long != 0.0) {
        _pegaLocalizacao(lat, long);
        _exibirMarcador(lat, long);
      }
    } else {
      String nome = dados["nome"];
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                  "$nome ainda não fez um primeiro login no app, não é possível pegar a sua localização atual"),
              contentPadding: EdgeInsets.all(10),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cadastrar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    }
  }

  _exibirMarcador(double lat, double long) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuario = usuarioLogado.uid;
    Firestore bd = Firestore.instance;
    //pega id do Filho
    DocumentSnapshot snapshot =
        await bd.collection("usuarios").document(idUsuario).get();
    Map<String, dynamic> dados = snapshot.data;
    String idFilho = dados["idconecta"];
    //pega localização do filho
    if (dados != null) {
      DocumentSnapshot snapshotFilho =
          await bd.collection("usuarios").document(idFilho).get();
      Map<String, dynamic> dadosFilho = snapshotFilho.data;
      String nome = dadosFilho["nome"];
      setState(() {
        marcador.add(Marker(
            markerId: MarkerId("tutorado"),
            infoWindow: InfoWindow(title: nome),
            position: LatLng(lat, long)));
      });
    }
  }

  _pegaLocalizacao(double lat, double long) async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _cameraPosition = CameraPosition(target: LatLng(lat, long), zoom: 19);
        movimentarCamera(_cameraPosition);
      }
    });
  }

  _alterarBotao(String texto, Color cor, Function f) {
    setState(() {
      _btColor = cor;
      textBt = texto;
      function = f;
    });
  }

  _statusRotaNaoDefinida() {
    _exibirCaixa = true;
    _alterarBotao("Definir rota", Colors.teal[600], () {
      _definirRota();
    });
  }

  _statusAguardando() {
    _exibirCaixa = false;
    _alterarBotao("Cancelar rota", Colors.red, () {
      _cancelarRota();
    });
  }

  _cancelarRota() async {
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    Firestore db = Firestore.instance;
    db
        .collection("rota")
        .document(_idRequisicao)
        .updateData({"status": StatusRequisicao.CANCELADA}).then((_) {
      db.collection("rotaAtiva").document(firebaseUser.uid).delete();
    });
  }

  _salvarRota(Rota rota) async {
    Firestore db = Firestore.instance;
    Requisicao requisicao = Requisicao();
    requisicao.setRota = rota;
    Usuario responsavel = await UsuarioFirebase.getResponsavel();
    Usuario tutorado = await UsuarioFirebase.getTutorado();
    DocumentSnapshot snapshotFilho =
        await db.collection("usuarios").document(tutorado.idUsuario).get();
    Map<String, dynamic> dadosFilho = snapshotFilho.data;
    double lat = dadosFilho["latitude"];
    double long = dadosFilho["longitude"];
    requisicao.setResponsavel = responsavel;
    requisicao.setTutorado = tutorado;
    tutorado.latitude = lat;
    tutorado.longitude = long;
    requisicao.setStatus = StatusRequisicao.AGUARDANDO;
    db
        .collection("rota")
        .document(requisicao.getId)
        .setData(requisicao.toMap());
    Map<String, dynamic> dadosRotaAtiva = {};
    dadosRotaAtiva["idRequisicao"] = requisicao.getId;
    dadosRotaAtiva["idResponsavel"] = responsavel.idUsuario;
    dadosRotaAtiva["idTutorado"] = tutorado.idUsuario;
    dadosRotaAtiva["status"] = StatusRequisicao.A_CAMINHO;
    db
        .collection("rotaAtiva")
        .document(responsavel.idUsuario)
        .setData(dadosRotaAtiva);
    _statusAguardando();
  }

  _definirRota() async {
    String destinoTutorado = destino.text;
    if (destinoTutorado.isNotEmpty) {
      List<Placemark> listEndereco =
          await Geolocator().placemarkFromAddress(destinoTutorado);
      if (listEndereco != null && listEndereco.length > 0) {
        Placemark endereco = listEndereco[0];
        Rota rota = Rota();
        rota.setCidade = endereco.administrativeArea;
        rota.setCep = endereco.postalCode;
        rota.setBairro = endereco.subLocality;
        rota.setRua = endereco.thoroughfare;
        rota.setNum = endereco.subThoroughfare;
        rota.setLatitude = endereco.position.latitude;
        rota.setLongitude = endereco.position.longitude;
        String confirmaEndereco;
        confirmaEndereco = "\n Rua: " + rota.rua + ", " + rota.numero;
        confirmaEndereco += "\n Bairro: " + rota.bairro;
        confirmaEndereco += "\n Cep: " + rota.cep;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Você deseja definir esta rota?"),
                content: Text(confirmaEndereco),
                contentPadding: EdgeInsets.all(10),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirmar"),
                    onPressed: () {
                      Navigator.pop(context);
                      _salvarRota(rota);
                    },
                  ),
                  FlatButton(
                    child: Text("Cancelar"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              );
            });
      }
    }
  }

  _adicionarListenerRequisicaoAtiva() async {
    FirebaseUser firebaseUser = await UsuarioFirebase.getUsuarioAtual();
    Firestore db = Firestore.instance;
    await db
        .collection("rotaAtiva")
        .document(firebaseUser.uid)
        .snapshots()
        .listen((snapshot) {
      Map<String, dynamic> dados = snapshot.data;
      if (snapshot.data != null) {
        String status = dados["status"];
        _idRequisicao = dados["idRequisicao"];
        switch (status) {
          case StatusRequisicao.AGUARDANDO:
            _statusAguardando();
            break;
          case StatusRequisicao.A_CAMINHO:
            break;
          case StatusRequisicao.FINALIZADA:
            break;
        }
      } else {
        _statusRotaNaoDefinida();
      }
    });
  }

  movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    _pegaDados();
    _adicionarListenerRequisicaoAtiva();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text("Definir rota"),
      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _cameraPosition,
            myLocationEnabled: false,
            markers: Set.from(marcador),
            myLocationButtonEnabled: false,
          ),
          Visibility(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          fillColor: Colors.grey[100].withOpacity(0.8),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.place,
                            color: Colors.teal[900],
                          ),
                          labelText: "Local de partida do seu tutorado",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 55,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: TextFormField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey[100].withOpacity(0.8),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.map,
                            color: Colors.teal[900],
                          ),
                          labelText: "Digite o destino do tutorado",
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(25.0),
                            borderSide: new BorderSide(color: Colors.black),
                          ),
                        ),
                        controller: destino,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            visible: _exibirCaixa,
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                child: Text(
                  textBt,
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  function();
                },
                color: _btColor,
              ),
            ),
          )
        ],
      )),
    );
  }
}
