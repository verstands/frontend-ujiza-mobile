import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/CommuneModel.dart';
import 'package:medigo/models/PaysModel.dart';
import 'package:medigo/models/QuartierModel.dart';
import 'package:medigo/models/VilleModel.dart';
import 'package:medigo/screens/SearchPharcmacieAll.dart';
import 'package:medigo/screens/home.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/communeservice.dart';
import 'package:medigo/services/paysservice.dart';
import 'package:medigo/services/quartierservice.dart';
import 'package:medigo/services/villeservice.dart';
import 'package:medigo/utils/customAppBar.dart';

class LocalisationPage extends StatefulWidget {
  const LocalisationPage({super.key});

  @override
  _LocalisationPageState createState() => _LocalisationPageState();
}

class _LocalisationPageState extends State<LocalisationPage> {
  String? selectedCountry;
  String? selectedCity;
  String? selectedCommune;
  String? selectedQuarter;

  List<PaysModel> countries = [];
  List<VilleModel> cities = [];
  List<CommuneModel> communes = [];
  List<QuartierModel> quartier = [];
  List<QuartierModel> quartierShared = [];
  bool loadingCountry = true;
  bool loadingCitie = true;
  bool loadingCommune = true;
  bool loadingQuartier = true;

  Future<void> _fetchPays() async {
    EasyLoading.show(status: 'Chargement des pays...');
    ApiResponse response = await getPaysLists();
    if (response.erreur == null) {
      setState(() {
        countries = response.data as List<PaysModel>;
        loadingCountry = false;
        print(countries);
      });
    } else {
      setState(() {
        loadingCountry = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
    EasyLoading.dismiss();
  }

  Future<void> _fetchVille(String idpays) async {
    EasyLoading.show(status: 'Chargement des villes...');
    ApiResponse response = await getVilleByCountry(idpays);
    if (response.erreur == null) {
      setState(() {
        cities = response.data as List<VilleModel>;
        loadingCitie = false;
      });
    } else {
      setState(() {
        loadingCitie = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
    EasyLoading.dismiss();
  }

  Future<void> _fetchCommune(String idville) async {
    EasyLoading.show(status: 'Chargement des communes...');
    ApiResponse response = await getCommuneByVille(idville);
    if (response.erreur == null) {
      setState(() {
        communes = response.data as List<CommuneModel>;
        loadingCommune = false;
      });
    } else {
      setState(() {
        loadingCommune = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
    EasyLoading.dismiss();
  }

  Future<void> _fetchQuartier(String idcommune) async {
    EasyLoading.show(status: 'Chargement des quartier...');
    ApiResponse response = await getQuartierCommune(idcommune);
    if (response.erreur == null) {
      setState(() {
        quartier = response.data as List<QuartierModel>;
        loadingQuartier = false;
      });
    } else {
      setState(() {
        loadingQuartier = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
    EasyLoading.dismiss();
  }

  Future<void> _saveSelectedQuarter(QuartierModel quartier) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> quartierMap = {
      'id': quartier.id,
      'nom': quartier.nom,
      'communeNom': quartier.commune?.nom,
    };
    String quartierJson = jsonEncode(quartierMap);
    await prefs.setString('quartier', quartierJson);
    await prefs.setString('qid', quartier.id.toString());
    print("Quartier enregistré dans SharedPreferences: ${quartier.nom}");
  }

  @override
  void initState() {
    super.initState();
    _fetchPays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Localisation"),
      body: SingleChildScrollView(
        // Ajout du SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Icon(
                Icons.location_on,
                size: 100,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sélectionnez un pays',
                  border: OutlineInputBorder(),
                ),
                items: countries.map((country) {
                  return DropdownMenuItem(
                    value: country.id,
                    child: Row(
                      children: [
                        const Icon(Icons.public), // Icône pour le pays
                        const SizedBox(
                            width: 8), // Espacement entre l'icône et le texte
                        Text(country.nom ?? 'Nom non disponible'),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    selectedCity = null;
                    selectedCommune = null;
                    selectedQuarter = null;

                    if (value != null) {
                      _fetchVille(value);
                    }
                  });
                },
                value: selectedCountry,
              ),
              const SizedBox(height: 16),
              if (selectedCountry != null) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez une ville',
                    border: OutlineInputBorder(),
                  ),
                  items: cities.map((city) {
                    return DropdownMenuItem(
                      value: city.id,
                      child: Row(
                        children: [
                          const Icon(
                              Icons.location_city), // Icône pour la ville
                          const SizedBox(width: 8),
                          Text(city.nom ?? 'Nom non disponible'),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                      selectedCommune = null;
                      selectedQuarter = null;
                      if (value != null) {
                        _fetchCommune(value);
                      }
                    });
                  },
                  value: selectedCity,
                ),
                const SizedBox(height: 16),
              ],
              if (selectedCity != null) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez une commune',
                    border: OutlineInputBorder(),
                  ),
                  items: communes.map((commune) {
                    return DropdownMenuItem(
                      value: commune.id,
                      child: Row(
                        children: [
                          const Icon(Icons.business), // Icône pour la commune
                          const SizedBox(width: 8),
                          Text(commune.nom ?? ''),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommune = value;
                      selectedQuarter = null;
                      if (value != null) {
                        _fetchQuartier(value);
                      }
                    });
                  },
                  value: selectedCommune,
                ),
                const SizedBox(height: 16),
              ],
              if (selectedCommune != null) ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez un quartier',
                    border: OutlineInputBorder(),
                  ),
                  items: quartier.map((quarter) {
                    return DropdownMenuItem(
                      value: quarter.id,
                      child: Row(
                        children: [
                          const Icon(Icons.home), // Icône pour le quartier
                          const SizedBox(width: 8),
                          Text(quarter.nom ?? ''),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedQuarter = value;
                    });
                  },
                  value: selectedQuarter,
                ),
                const SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: () async {
                  if (selectedQuarter != null) {
                    QuartierModel? quartierSelectionne = quartier.firstWhere(
                      (q) => q.id == selectedQuarter,
                      orElse: () =>
                          QuartierModel(id: '', nom: '', idCommune: ''),
                    );
                    if (quartierSelectionne != null) {
                      await _saveSelectedQuarter(quartierSelectionne);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }
                  } else {
                    // Si aucun quartier n'est sélectionné, afficher une alerte
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Veuillez sélectionner un quartier'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Afficher les pharmacies',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
