import 'dart:async';
import 'package:anjotcc/model/localizacao.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class PainelTutorado extends StatefulWidget {
  @override
  _PainelTutoradoState createState() => _PainelTutoradoState();
}

class _PainelTutoradoState extends State<PainelTutorado> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-29.817131, -51.153620));
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  _recuperaUltimaloc() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    movimentarCamera(_cameraPosition);
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser usuarioLogado = await auth.currentUser();
    Localizacao localizacao = Localizacao();
    localizacao.setLatitude = position.latitude;
    localizacao.setLongitude = position.longitude;
    String id = usuarioLogado.uid;
    Firestore db = Firestore.instance;
    setState(() {
      if (position != null) {
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        movimentarCamera(_cameraPosition);
        db
            .collection("usuarios")
            .document(id)
            .collection("localizacao")
            .document()
            .setData(localizacao.toMap());
      }
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
      movimentarCamera(_cameraPosition);
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser usuarioLogado = await auth.currentUser();
      if (usuarioLogado != null) {
        Localizacao localizacao = Localizacao();
        localizacao.setLatitude = position.latitude;
        localizacao.setLongitude = position.longitude;
        String id = usuarioLogado.uid;
        Firestore db = Firestore.instance;
        db
            .collection("usuarios")
            .document(id)
            .collection("localizacao")
            .document()
            .setData(localizacao.toMap());
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
    _recuperaUltimaloc();
    _listenerLocalizacao();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("painel tutorado"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  label: Text("Alerta"),
                  icon: Icon(Icons.warning, color: Colors.red),
                ),
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  icon: Icon(
                    Icons.map,
                    color: Colors.teal[900],
                  ),
                  label: Text("Minhas rotas"),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  label: Text("Minha localização"),
                  icon: Icon(
                    Icons.place,
                    color: Colors.teal[900],
                  ),
                ),
                FlatButton.icon(
                  onPressed: () => {},
                  color: Colors.white,
                  padding: EdgeInsets.all(10.0),
                  label: Text("Chat"),
                  icon: Icon(
                    Icons.forum,
                    color: Colors.teal[900],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
