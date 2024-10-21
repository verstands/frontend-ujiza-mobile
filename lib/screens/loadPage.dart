import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/screens/home.dart';
import 'package:medigo/screens/localisation.dart';
import 'package:medigo/screens/mypharmacie.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id = prefs.getString('quartier');
    final String? token = prefs.getString('token');

    // Définir une durée d'attente
    await Future.delayed(const Duration(seconds: 3));

    // Rediriger selon la présence des informations
    if (id != null && token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else if (token != null && id == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyPharmacie()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LocalisationPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                child: const Image(
                  image: AssetImage('assets/logo/logomedigo.png'),
                ),
              ),
              const SizedBox(height: 20), // Espacement
            ],
          ),
        ),
      ),
    );
  }
}
