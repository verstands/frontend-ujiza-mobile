import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujiza/models/QuartierModel.dart';
import 'package:ujiza/models/pharmacieModel.dart';
import 'package:ujiza/screens/medicamentAll.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:ujiza/services/pharmacieservice.dart';
import 'package:ujiza/utils/customAppBar.dart';

class PharmacieAllList extends StatefulWidget {
  const PharmacieAllList({super.key});

  @override
  State<PharmacieAllList> createState() => _PharmacieAllListState();
}

class _PharmacieAllListState extends State<PharmacieAllList> {
  List<pharmacieModel> pharmacies = [];
  bool loading = true;

  String searchQuery = '';
  List<QuartierModel> quartierShared = [];
  String qid = '';

  void getqid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    qid = prefs.getString('qid')!;
  }

  String quartierInfo = '';

  Future<void> _loadSelectedQuarter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? quartierJson = prefs.getString('quartier');
    if (quartierJson != null) {
      Map<String, dynamic> quartierMap = jsonDecode(quartierJson);
      QuartierModel quartier = QuartierModel(
        id: quartierMap['id'],
        nom: quartierMap['nom'],
        commune: Commune(nom: quartierMap['communeNom']),
      );
      setState(() {
        quartierInfo = quartier.id.toString();
      });
    } else {
      setState(() {
        quartierInfo = 'Aucun quartier trouvé.';
      });
    }
  }

  Future<void> _fetchPharmacies() async {
    EasyLoading.show(status: 'Chargement des pharmacies...');

    ApiResponse response = await getPharmacieId(qid);
    if (response.erreur == null) {
      setState(() {
        pharmacies = response.data as List<pharmacieModel>;
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
    _fetchPharmacies();
    _loadSelectedQuarter();
    getqid();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer la liste de pharmacies selon la recherche
    final filteredPharmacies = pharmacies.where((pharmacie) {
      return (pharmacie.nom?.toLowerCase() ?? "").contains(searchQuery) ||
          (pharmacie.communeavenu?.toLowerCase() ?? "").contains(searchQuery) ||
          (pharmacie.commune?.toLowerCase() ?? "").contains(searchQuery);
    }).toList();

    return Scaffold(
      appBar: const CustomAppBar(title: "Pharmacies"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher...',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Quartier sélectionné: $qid',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: filteredPharmacies.isEmpty
                ? const Center(child: Text(""))
                : ListView.builder(
                    itemCount: filteredPharmacies.length,
                    itemBuilder: (context, index) {
                      final pharmacie = filteredPharmacies[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicamentsPage(
                                  nomPharmacie: pharmacie.nom!,
                                  id: pharmacie.id!),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.local_pharmacy,
                                    color: Color.fromARGB(255, 0, 93, 76),
                                    size: 40),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pharmacie.nom ?? 'Nom inconnu',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Avenue: ${pharmacie.communeavenu ?? "Inconnue"}',
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.apartment,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Commune: ${pharmacie.commune ?? "Inconnue"}',
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              'Téléphone: ${pharmacie.telephone ?? "Inconnu"}',
                                              style: TextStyle(
                                                  color: Colors.grey[700]),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
