import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujiza/screens/SearchPharcmacieAll.dart';
import 'package:ujiza/screens/about.dart';
import 'package:ujiza/screens/contact.dart';
import 'package:ujiza/screens/detailmypharmacie.dart';
import 'package:ujiza/screens/localisation.dart';
import 'package:ujiza/screens/login.dart';
import 'package:ujiza/screens/mymedicament.dart';
import 'package:ujiza/screens/myprofile.dart';
import 'package:ujiza/screens/pharmaciieAllList.dart';
import 'package:ujiza/screens/private.dart';
import 'package:ujiza/screens/registrer.dart';

class AppMenu extends StatefulWidget {
  @override
  _AppMenuState createState() => _AppMenuState();
}

class _AppMenuState extends State<AppMenu> {
  String token = '';
  String qid = '';

  @override
  void initState() {
    super.initState();
    getToken();
    getqid();
  }

  Future<void> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    setState(() {
      token = '';
      qid = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Déconnecté avec succès')),
    );
  }

  Future<void> getqid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      qid = prefs.getString('qid') ?? '';
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

          // Si le token est vide, afficher ces options
          if (token.isEmpty) ...[
            ListTile(
              leading: Icon(Icons.local_pharmacy),
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
                    SnackBar(
                        content: Text('ID non disponible pour l\'instant')),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Nos contacts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Localisation'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocalisationPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('À propos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Confidentialité'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacyPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Pharmacie',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.login),
              title: const Text('Se connecter'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: const Text('S\'inscrire'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
            ),
          ] else ...[
            ListTile(
              leading: Icon(Icons.local_pharmacy), // Icône pour Pharmacie
              title: const Text('Pharmacie'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetailMypharmacie()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: const Text('Produits'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Mymedicament()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                // Action pour Profil
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Myprofile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: const Text('Se déconnecter'),
              onTap: () {
                logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocalisationPage()),
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}
