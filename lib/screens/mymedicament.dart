import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/produitPharModel.dart';
import 'package:medigo/screens/addmymedicament.dart';
import 'package:medigo/screens/detailMedoc.dart';
import 'package:medigo/screens/detailmyprotui.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/produitservice.dart';
import 'package:medigo/utils/MeuApp.dart';

class Mymedicament extends StatefulWidget {
  const Mymedicament({super.key});

  @override
  State<Mymedicament> createState() => _MymedicamentState();
}

class _MymedicamentState extends State<Mymedicament> {
  List<ProduitPharModel> medicaments = [];
  bool loading = true;
  String? id;

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentString = prefs.getString('agent_id');

    if (agentString != null) {
      setState(() {
        id = agentString;
      });
      _fetchMedicament();
    }
  }

  Future<void> _fetchMedicament() async {
    EasyLoading.show(status: 'Chargement des produits...');

    ApiResponse response = await getMyProduit(id!);
    if (response.erreur == null) {
      setState(() {
        medicaments = response.data as List<ProduitPharModel>;
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
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    getUser();
    _fetchMedicament();
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mes produits',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddMymedicament()),
              );
            },
          ),
        ],
      ),
      drawer: AppMenu(),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un médicament...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 0, 93, 76)),
              ),
            ),
          ),
          // Liste des médicaments
          Expanded(
            child: ListView.builder(
              itemCount: medicaments.where((medicament) {
                return medicament.nom!.toLowerCase().contains(searchQuery);
              }).length,
              itemBuilder: (context, index) {
                final medicament = medicaments.where((medicament) {
                  return medicament.nom!.toLowerCase().contains(searchQuery);
                }).toList()[index];

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services,
                        color: Colors.green, size: 40),
                    title: Text(
                      medicament.nom!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dosage: ${medicament.dosage}mg'),
                        Text('Prix: ${medicament.prix} CDF',
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Rediriger vers la page de détail du médicament
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyMedicamentDetailPage(
                              medicament: {
                                'id': medicament.id!,
                                'nom': medicament.nom!,
                                'dosage': medicament.dosage!,
                                'prix': medicament.prix.toString()!,
                                'description': medicament.description!,
                                'pharmacie': medicament.pharmacie!.nom!,
                                'commune': medicament.pharmacie!.commune!.nom!,
                                'telephone':
                                    medicament.pharmacie!.agents!.telephone!,
                              },
                            ),
                          ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
