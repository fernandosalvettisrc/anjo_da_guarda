import 'dart:async';

import 'package:anjotcc/model/usuario.dart';
import 'package:anjotcc/telas/cadastro_tutorado.dart';
import 'package:anjotcc/telas/criarrota.dart';
import 'package:anjotcc/telas/emmanutencao.dart';
import 'package:anjotcc/telas/historico_rotas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PainelResponsavel extends StatefulWidget {
  Usuario usuario;
  @override
  _PainelResponsavelState createState() => _PainelResponsavelState();
}

class _PainelResponsavelState extends State<PainelResponsavel> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-29.817131, -51.153620));
  List<Marker> marcador = [];

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _pegaDados() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuario = usuarioLogado.uid;
    Firestore bd = Firestore.instance;
    //pega id do Filho
    DocumentSnapshot snapshot = await bd
        .collection("usuarios")
        .document(idUsuario)
        .collection("idTutorado")
        .document(idUsuario)
        .get();
    Map<String, dynamic> dados = snapshot.data;
    String idFilho = dados["id"];
    //pega localização do filho
    if (dados != null) {
      DocumentSnapshot snapshotFilho = await bd
          .collection("usuarios")
          .document(idFilho)
          .collection("localizacao")
          .document(idFilho)
          .get();
      Map<String, dynamic> dadosFilho = snapshotFilho.data;
      double lat = dadosFilho["latitude"];
      double long = dadosFilho["longitude"];
      _pegaLocalizacao(lat, long);
      _exibirMarcador(lat, long);
    }
  }

  _exibirMarcador(double lat, double long) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    String idUsuario = usuarioLogado.uid;
    Firestore bd = Firestore.instance;
    //pega id do Filho
    DocumentSnapshot snapshot = await bd
        .collection("usuarios")
        .document(idUsuario)
        .collection("idTutorado")
        .document(idUsuario)
        .get();
    Map<String, dynamic> dados = snapshot.data;
    String idFilho = dados["id"];
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

  movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    _pegaDados();
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
              title: Text('Definir rota'),
              leading: Icon(
                Icons.place,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CriarRota()));
              },
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
              title: Text('Cadastrar Tutorado'),
              leading: Icon(
                Icons.person_add,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CadastroTutorado()));
              },
            ),
            ListTile(
              title: Text('Visualizar dados do perfil'),
              leading: Icon(
                Icons.person,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmManutencao()));
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
            myLocationButtonEnabled: false,
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
                  Icons.gps_fixed,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _pegaDados();
                },
                color: Colors.white,
              ),
            ),
          )
        ],
      )),
    );
  }
}
