import 'package:flutter/material.dart';
import 'package:ujiza/utils/customAppBar.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Confidentialité"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Ajouté pour permettre le défilement
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Politique de Confidentialité',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 93, 76),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Votre confidentialité est importante pour nous. '
                    'Cette politique explique comment nous collectons, utilisons et protégeons vos données personnelles lors de l\'utilisation de notre application.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '1. Collecte de données\n'
                    'Nous collectons des informations personnelles lorsque vous vous inscrivez ou utilisez notre application, y compris votre nom, votre adresse e-mail et votre localisation.\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '2. Utilisation des données\n'
                    'Nous utilisons vos données pour améliorer nos services, vous fournir des mises à jour et répondre à vos demandes.\n',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    '3. Protection des données\n'
                    'Nous prenons des mesures raisonnables pour protéger vos informations contre l\'accès non autorisé, l\'utilisation ou la divulgation.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Pour toute question concernant cette politique, veuillez nous contacter à contact@monreseauhabitat.com.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
