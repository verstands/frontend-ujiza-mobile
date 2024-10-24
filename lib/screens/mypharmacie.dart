import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/RegistreModel.dart';
import 'package:medigo/models/countModel.dart';
import 'package:medigo/models/pharmacieModel.dart';
import 'package:medigo/models/produitPharModel.dart';
import 'package:medigo/screens/addmymedicament.dart';
import 'package:medigo/screens/mymedicament.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/pharmacieservice.dart';
import 'package:medigo/services/produitservice.dart';
import 'package:medigo/utils/MeuApp.dart';
import 'package:medigo/utils/customAppBar.dart';

class MyPharmacie extends StatefulWidget {
  const MyPharmacie({super.key});

  @override
  State<MyPharmacie> createState() => _MyPharmacieState();
}

class _MyPharmacieState extends State<MyPharmacie> {
  int totalMedications = 0;
  int totalPrice = 0;
  List<Medication> medications = [];
  pharmacieModel? pharmacie;
  bool loading = true;
  String? id;
  String? phar;

  @override
  void initState() {
    super.initState();
    _fetchCount();
    _fetchSomme();
    getUser();
    _fetchpharmacie();
  }

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentString = prefs.getString('agent_id');

    if (agentString != null) {
      setState(() {
        id = agentString;
      });
      _fetchCount();
      _fetchpharmacie();
      _fetchSomme();
    }
  }

  @override
  Future<void> _fetchCount() async {
    if (id != null && id != null) {
      ApiResponse response = await getCountmedicament(id!);

      if (response.erreur == null) {
        setState(() {
          totalMedications = response.data;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.erreur}')),
        );
      }
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('')),
      );
    }
    EasyLoading.dismiss();
  }

  @override
  Future<void> _fetchpharmacie() async {
    if (id != null && id != null) {
      EasyLoading.show(status: 'Chargement...');
      ApiResponse response = await getPharmacierIDUser(id!);

      if (response.erreur == null) {
        setState(() {
          pharmacie = response.data as pharmacieModel;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('pharmacie_id', pharmacie?.id ?? '');
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('')),
        );
      }
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ok')),
      );
    }
    EasyLoading.dismiss();
  }

  Future<void> _fetchSomme() async {
    if (id != null && id != null) {
      ApiResponse response = await getsommePrix(id!);

      if (response.erreur == null) {
        setState(() {
          totalPrice = response.data;
          loading = false;
        });
      } else {
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${response.erreur}')),
        );
      }
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('')),
      );
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tableau de bords",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      drawer: AppMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ma Pharmacie : ${pharmacie?.nom ?? ''}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildCard(
              title: 'Nombre de Médicaments',
              value: '$totalMedications',
              icon: Icons.medication,
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: 'Prix Total des Médicaments',
              value: '${totalPrice}.00 CDF',
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 20),
            id!.isNotEmpty
                ? Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Actions Rapides',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddMymedicament()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 93, 76),
                            ),
                            child: const Text(
                              'Ajouter un mediciament ',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Mymedicament()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 93, 76),
                            ),
                            child: const Text(
                              'Voir les médicaments',
                              style: TextStyle(
                                  color: Colors
                                      .white), // Couleur du texte en blanc
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title, required String value, required IconData icon}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: const Color.fromARGB(255, 0, 93, 76)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 93, 76),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Classe pour représenter un médicament
class Medication {
  final String name;
  final int quantity;
  final double price;

  Medication({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
