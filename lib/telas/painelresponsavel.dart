import 'package:anjotcc/model/usuario.dart';
import 'package:anjotcc/telas/cadastro_tutorado.dart';
import 'package:anjotcc/telas/emmanutencao.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class PainelResponsavel extends StatefulWidget {
  Usuario usuario;
  @override
  _PainelResponsavelState createState() => _PainelResponsavelState();
}

class _PainelResponsavelState extends State<PainelResponsavel> {
  List<String> itensMenu = ["configuraçoes", "Deslogar"];
  GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900],
        title: Text("Painel Responsavel"),
        actions: <Widget>[
        ],
      ),
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
              title: Text('Chat'),
              leading: Icon(Icons.forum, color: Colors.teal[900],),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => EmManutencao()));
              },
            ),
             ListTile(
              title: Text('Cadastrar Tutorado'),
              leading: Icon(Icons.person_add, color: Colors.teal[900],),
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => CadastroTutorado()));
              },
            ),
             ListTile(
              title: Text('Sair'),
              leading: Icon(Icons.clear, color: Colors.teal[900],),
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
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
