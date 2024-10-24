import 'package:flutter/material.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/userservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/utils/MeuApp.dart'; // Assurez-vous que ce chemin est correct

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  String? nom;
  String? prenom;
  String? id;
  String? email;
  String adresse = "456 Rue de la Liberté, Kinshasa";
  String? telephone;
  bool _isLoading = false;

  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getNom();
    getPrenom();
    getEmail();
    getTelephone();
    getid();
  }

  Future<void> getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('agent_id');
    });
  }

  Future<void> getNom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('agent_nom');
      nomController.text = nom ?? '';
    });
  }

  Future<void> getPrenom() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prenom = prefs.getString('agent_prenom');
      prenomController.text = prenom ?? '';
    });
  }

  Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('agent_email');
      emailController.text = email ?? '';
    });
  }

  Future<void> getTelephone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      telephone = prefs.getString('agent_telephone');
      telephoneController.text = telephone ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mon Profil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      drawer: AppMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                '$prenom  $nom',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 93, 76),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '$email',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.phone,
                            color: Color.fromARGB(255, 0, 93, 76)),
                        const SizedBox(width: 8),
                        const Text('Téléphone:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(telephone ?? 'Non renseigné',
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _modifierProfil,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Modifier le Profil',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _modifierProfil() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modifier le Profil',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              // Ajoutez cette ligne
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: prenomController,
                    decoration: InputDecoration(
                      labelText: 'Prenom',
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: telephoneController,
                    decoration: InputDecoration(
                      labelText: 'Téléphone',
                      prefixIcon: const Icon(Icons.phone),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('agent_nom', nomController.text);
                await prefs.setString('agent_email', emailController.text);
                await prefs.setString('agent_prenom', prenomController.text);
                await prefs.setString(
                    'agent_telephone', telephoneController.text);

                Navigator.of(context).pop();
                setState(() {
                  nom = nomController.text;
                  email = emailController.text;
                  telephone = telephoneController.text;
                  prenom = prenomController.text;
                });

                ApiResponse response = await UpdateUser(
                  nomController.text,
                  prenomController.text,
                  emailController.text,
                  telephoneController.text,
                  id!,
                );

                setState(() {
                  _isLoading = false;
                });

                if (response.erreur == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Myprofile(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Profil mis à jour avec succès!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${response.erreur}')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 93, 76),
              ),
              child: const Text(
                'Modifier',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
