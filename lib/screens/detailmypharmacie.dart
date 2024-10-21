import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/pharmacieModel.dart';
import 'package:medigo/screens/AddMypharmacie.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/pharmacieservice.dart';
import 'package:medigo/utils/MeuApp.dart';

class DetailMypharmacie extends StatefulWidget {
  const DetailMypharmacie({super.key});

  @override
  State<DetailMypharmacie> createState() => _DetailMypharmacieState();
}

class _DetailMypharmacieState extends State<DetailMypharmacie> {
  // Informations par défaut
  String nomPharmacie = "Ma Pharmacie";
  String adresse = "123 Rue de la Santé, Kinshasa";
  String telephone = "+243 123 456 789";
  pharmacieModel? pharmacies;
  bool loading = true;
  String? id;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentString = prefs.getString('agent_id');

    if (agentString != null) {
      setState(() {
        id = agentString;
      });
      _fetchDetail();
    }
  }

  Future<void> _fetchDetail() async {
    if (id == null) {
      return;
    }

    EasyLoading.show(status: 'Chargement...');
    ApiResponse response = await getPharmacieUserID(id!);

    if (response.erreur == null) {
      setState(() {
        pharmacies = response.data as pharmacieModel; // Pas besoin de liste
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${response.erreur}')),
      );
    }

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _fetchDetail();
  }

  void _modifierInfos() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modifier les Informations',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nom de la Pharmacie',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 93, 76),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 0, 93, 76),
                      ),
                    ),
                    prefixIcon: const Icon(Icons.store,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      nomPharmacie = value;
                    });
                  },
                  controller:
                      TextEditingController(text: pharmacies!.nom ?? ""),
                ),
                const SizedBox(height: 16), // Ajoute un espace entre les champs
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 0, 93, 76),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 0, 93, 76),
                      ),
                    ),
                    prefixIcon: const Icon(Icons.location_on,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      adresse = value;
                    });
                  },
                  controller: TextEditingController(
                      text: pharmacies!.communeavenu ?? ""),
                ),
                const SizedBox(height: 16), // Ajoute un espace entre les champs
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 93, 76),
              ),
              child: const Text(
                'Sauvegarder',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nomPharmacie,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _modifierInfos,
            color: Colors.white,
          ),
        ],
      ),
      drawer: AppMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pharmacies == null
            ? ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddMyPharmacie()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Ajouter une Pharmacie',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Détails de la Pharmacie',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 93, 76),
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
                          Row(
                            children: [
                              const Icon(Icons.store,
                                  color: Color.fromARGB(255, 0, 93, 76)),
                              const SizedBox(width: 8),
                              Text(
                                'Nom de la Pharmacie:',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            pharmacies != null ? (pharmacies!.nom ?? "") : "",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color.fromARGB(255, 0, 93, 76)),
                              const SizedBox(width: 8),
                              Text(
                                'Adresse:',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pharmacies != null
                                ? "${pharmacies!.communeavenu ?? ''}, ${pharmacies!.qurtier?.nom ?? ''}"
                                : "Information non disponible",
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.phone,
                                  color: Color.fromARGB(255, 0, 93, 76)),
                              const SizedBox(width: 8),
                              Text(
                                'Téléphone:',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pharmacies != null
                                ? (pharmacies!.agents!.telephone ?? "")
                                : "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
