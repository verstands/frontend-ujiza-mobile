import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ujiza/screens/home.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  void _test() {
    Timer(
        const Duration(seconds: 7),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home())));
  }

  void initState() {
    super.initState();
    _test();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(12),
                child: const Image(
                  image: AssetImage('assets/logo/a.jpeg'),
                )),
          ],
        ),
      ),
    );
  }
}
