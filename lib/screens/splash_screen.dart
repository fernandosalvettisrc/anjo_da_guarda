
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: 
      Image.asset('assets/logo.png', height: 300, width: 200,)
      ),
    );
  }
}