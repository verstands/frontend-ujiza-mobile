import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujiza/screens/SearchPharcmacieAll.dart';
import 'package:ujiza/screens/about.dart';
import 'package:ujiza/screens/contact.dart';
import 'package:ujiza/screens/localisation.dart';
import 'package:ujiza/screens/pharmaciieAllList.dart';
import 'package:ujiza/screens/private.dart';

class AppMenu extends StatefulWidget {
  @override
  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  String qid = ''; // Initialisation de qid

  @override
  void initState() {
    super.initState();
    // Charger qid dès que le widget est créé
    getqid();
  }

  // Fonction pour récupérer l'ID depuis les SharedPreferences
  Future<void> getqid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      qid = prefs.getString('qid') ?? ''; // Stocke l'ID dans l'état local
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 93, 76),
            ),
            child: Text(
              'Ujiza',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_pharmacy), // Pharmacie
            title: const Text('Pharmacie'),
            onTap: () {
              if (qid.isNotEmpty) {
                // Vérifie si l'ID a été récupéré
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchPharmacieAll(id: qid),
                  ),
                );
              } else {
                // Si l'ID n'est pas encore récupéré, afficher un message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('ID non disponible pour l\'instant')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.contacts), // Icône pour Nos contacts
            title: const Text('Nos contacts'),
            onTap: () {
              Navigator.pop(context); // Fermer le menu
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ContactsPage()), // Redirection vers la page Nos contacts
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on), // Icône pour Localisation
            title: const Text('Localisation'),
            onTap: () {
              Navigator.pop(context); // Fermer le menu
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LocalisationPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info_outline), // A propos
            title: Text('À propos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip), // Confidentialité
            title: Text('Confidentialité'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
