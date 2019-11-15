import 'dart:async';
import 'package:anjotcc/model/localizacao.dart';
import 'package:anjotcc/telas/emmanutencao.dart';
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
            .document(id)
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
            .document(id)
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("teste", style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.teal[900],
              ),
            ),
            ListTile(
              title: Text('Minhas rotas'),
              leading: Icon(
                Icons.place,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EmManutencao()));
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
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
             Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                child: Icon(Icons.warning, color: Colors.red, size: 40.0,),
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
