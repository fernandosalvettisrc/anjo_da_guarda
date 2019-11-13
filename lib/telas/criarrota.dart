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
  List<String> itensMenu = ["configuraçoes", "Deslogar"];
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-29.817131, -51.153620));
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recuperaUltimaloc() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      if (position != null) {
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        movimentarCamera(_cameraPosition);
      }
    });
  }

  _listenerLocalizacao() async {
    var geoLocator = Geolocator();
    var locationsOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    geoLocator.getPositionStream(locationsOptions).listen((Position position) {
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 19,
      );
      movimentarCamera(_cameraPosition);
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
        backgroundColor: Colors.teal[900],
        title: Text("Definir rota"),
      ),
      body: Container(
          child: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _cameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
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
                  decoration: InputDecoration(
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
                ),
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
                child: Text("Definir rota", style: TextStyle(color: Colors.white),),
                onPressed: () {},
                color: Colors.teal[600],
              ),
            ),
          )
        ],
      )),
    );
  }
}
