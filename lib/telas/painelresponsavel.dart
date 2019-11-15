import 'dart:async';

import 'package:anjotcc/model/usuario.dart';
import 'package:anjotcc/telas/cadastro_tutorado.dart';
import 'package:anjotcc/telas/criarrota.dart';
import 'package:anjotcc/telas/emmanutencao.dart';
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
  Completer <GoogleMapController> _controller = Completer();
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

  // _recuperaUltimaloc() async {
  //   Position position = await Geolocator()
  //       .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);

  //   setState(() {
  //     if (position != null) {
  //       _cameraPosition = CameraPosition(
  //         target: LatLng(position.latitude, position.longitude),
  //         zoom: 19,
  //       );
  //       movimentarCamera(_cameraPosition);
  //     }
  //   });
  // }

/*   //_listenerLocalizacao() async{
    var geoLocator = Geolocator();
    var locationsOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    geoLocator.getPositionStream(locationsOptions).listen((Position position){
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 19,
        );
        movimentarCamera(_cameraPosition);
        
    });
  } */

  movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
  /*   _recuperaUltimaloc();
    _listenerLocalizacao(); */
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
              title: Text('Definir rota'),
              leading: Icon(
                Icons.place,
                color: Colors.teal[900],
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CriarRota()));
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
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _cameraPosition,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
