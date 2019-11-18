import 'dart:async';
import 'package:anjotcc/model/localizacao.dart';
import 'package:anjotcc/telas/emmanutencao.dart';
import 'package:anjotcc/util/statusrequisicao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:anjotcc/util/firebaseuser.dart';
import 'package:flutter/cupertino.dart';

class PainelTutorado extends StatefulWidget {
  @override
  _PainelTutoradoState createState() => _PainelTutoradoState();
}

class _PainelTutoradoState extends State<PainelTutorado> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-29.817131, -51.153620));
  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Map<String, dynamic> _dadosRota;
  List<Marker> marcador = [];

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _pegarRota() async {
    Firestore db = Firestore.instance;
    String idRequisicao = _dadosRota["id"];
    db
        .collection("rota")
        .document(idRequisicao)
        .updateData({"status": StatusRequisicao.A_CAMINHO}).then((_) {
      String idResponsavel = _dadosRota["responsavel"]["id"];
      db
          .collection("rotaAtiva")
          .document(idResponsavel)
          .updateData({"status": StatusRequisicao.A_CAMINHO});
    });
  }

  _recuperaRota() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String id = usuarioLogado.uid;
    Firestore db = Firestore.instance;
    DocumentSnapshot idRespon = await db
        .collection("usuarios")
        .document(id)
        .collection("idResponsavel")
        .document(id)
        .get();
    Map<String, dynamic> dados = idRespon.data;
    String idResponsavel = dados["id"];
    DocumentSnapshot idRota =
        await db.collection("rotaAtiva").document(idResponsavel).get();
    Map<String, dynamic> dadosRotaAtiva = idRota.data;
    if (dadosRotaAtiva == null) {
      _adicionarListener();
    } else {
      String rotaId = dadosRotaAtiva["idRequisicao"];
      DocumentSnapshot documentSnapshot =
          await db.collection("rota").document(rotaId).get();
      _dadosRota = documentSnapshot.data;
    }
  }

  _statusAcaminho() {
    double latitudePassageiro = _dadosRota["tutorado"]["latitude"];
    double longitudePassageiro = _dadosRota["tutorado"]["longitude"];
    double latitudeDestino = _dadosRota["rota"]["latitude"];
    double longitudeDestino = _dadosRota["rota"]["longitude"];
    exibirMarcadores(LatLng(latitudePassageiro, longitudePassageiro),
        LatLng(latitudeDestino, longitudeDestino));
  }

  exibirMarcadores(LatLng latLng1, LatLng latLng2) {}
  _statusAguardando() {}
  _adicionarListener() async {
    Firestore db = Firestore.instance;
    String idRota = _dadosRota["id"];
    await db
        .collection("rota")
        .document(idRota)
        .snapshots()
        .listen((snapshots) {
      if (snapshots.data != null) {
        Map<String, dynamic> dados = snapshots.data;
        String status = dados["status"];
        switch (status) {
          case StatusRequisicao.AGUARDANDO:
            _statusAguardando();
            break;
          case StatusRequisicao.A_CAMINHO:
            _statusAcaminho();
            break;
          case StatusRequisicao.FINALIZADA:
            break;
        }
      }
    });
  }

  _exibirMarcador() {
    var geoLocator = Geolocator();
    var locationsOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    geoLocator
        .getPositionStream(locationsOptions)
        .listen((Position position) async {
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      await setState(() {
        marcador.add(Marker(
            markerId: MarkerId("tutorado"),
            infoWindow: InfoWindow(title: "Eu"),
            position: LatLng(position.latitude, position.longitude)));
        marcador.add(
          Marker(
            markerId: MarkerId("Destino"),
          ),
        );
      });
    });
  }

  _listenerLocalizacao() async {
    var geoLocator = Geolocator();
    var locationsOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    geoLocator
        .getPositionStream(locationsOptions)
        .listen((Position position) async {
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser usuarioLogado = await auth.currentUser();
      Localizacao localizacao = Localizacao();
      localizacao.setLatitude = position.latitude;
      localizacao.setLongitude = position.longitude;
      String id = usuarioLogado.uid;
      Firestore db = Firestore.instance;
      db
          .collection("usuarios")
          .document(id)
          .collection("localizacao")
          .document(id)
          .setData(localizacao.toMap());
      movimentarCamera(_cameraPosition);
    });
    _exibirMarcador();
  }

  movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    _listenerLocalizacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                'assets/logo.png',
                height: 200,
                width: 200,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            ListTile(
              title: Text('Chat'),
              leading: Icon(
                Icons.forum,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmManutencao()));
              },
            ),
            ListTile(
              title: Text('Visualizar dados do perfil'),
              leading: Icon(
                Icons.person,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmManutencao()));
              },
            ),
            ListTile(
              title: Text('Sair'),
              leading: Icon(
                Icons.clear,
                color: Colors.teal[900],
              ),
              onTap: () {
                _deslogarUsuario();
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: _cameraPosition,
              myLocationEnabled: false,
              myLocationButtonEnabled: true,
              markers: Set.from(marcador),
            ),
            Positioned(
              right: 0,
              left: 280,
              top: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  child: Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: RaisedButton(
                  child: Text("Verificar se há rota definida"),
                  onPressed: () {},
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
