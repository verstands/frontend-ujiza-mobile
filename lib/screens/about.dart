import 'package:flutter/material.dart';
import 'package:ujiza/utils/customAppBar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "À propos"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenue dans notre application',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 93, 76),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Cette application vous permet de trouver facilement les pharmacies de votre région. '
                  'Vous pouvez consulter la liste des pharmacies, afficher leurs médicaments et obtenir '
                  'des informations détaillées sur chaque produit.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Développée par : Rabbi Kikwele',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 8),
                Text(
                  'Contact : rabby@gmail.com',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
