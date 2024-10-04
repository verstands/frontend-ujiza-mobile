import 'package:flutter/material.dart';
import 'package:ujiza/screens/about.dart';
import 'package:ujiza/screens/contact.dart';
import 'package:ujiza/screens/localisation.dart';
import 'package:ujiza/screens/pharmaciieAllList.dart';
import 'package:ujiza/screens/private.dart';

class AppMenu extends StatelessWidget {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PharmacieAllList()),
              );
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
