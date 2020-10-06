import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Center(
        child: Text(
          'Loading....',
          style: TextStyle(
              fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
