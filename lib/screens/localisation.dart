import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ujiza/models/CommuneModel.dart';
import 'package:ujiza/models/PaysModel.dart';
import 'package:ujiza/models/QuartierModel.dart';
import 'package:ujiza/models/VilleModel.dart';
import 'package:ujiza/screens/SearchPharcmacieAll.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:ujiza/services/communeservice.dart';
import 'package:ujiza/services/paysservice.dart';
import 'package:ujiza/services/quartierservice.dart';
import 'package:ujiza/services/villeservice.dart';
import 'package:ujiza/utils/customAppBar.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchPays();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Localisation"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.location_on,
              size: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Sélectionnez un pays',
                border: OutlineInputBorder(),
              ),
              items: countries.map((country) {
                return DropdownMenuItem(
                  value: country.id,
                  child: Text(country.nom ??
                      'Nom non disponible'), // Vérifier si nom est nul
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                  selectedCity =
                      null; // Reset city and commune when country changes
                  selectedCommune = null;
                  selectedQuarter = null;

                  if (value != null) {
                    _fetchVille(
                        value); // Appeler la fonction avec la valeur non nulle
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
                    child: Text(city.nom ??
                        'Nom non disponible'), // Vérifier si nom est nul
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCity = value;
                    selectedCommune =
                        null; // Reset commune and quarter when city changes
                    selectedQuarter = null;
                    if (value != null) {
                      _fetchCommune(
                          value); // Appeler la fonction avec la valeur non nulle
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
                    child: Text(commune.nom ?? ''),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCommune = value;
                    selectedQuarter = null;
                    if (value != null) {
                      _fetchQuartier(
                          value); // Appeler la fonction avec la valeur non nulle
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
                    child: Text(quarter.nom ?? ''),
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
              onPressed: () {
                // Action pour afficher les pharmacies selon la sélection
                if (selectedQuarter != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SearchPharmacieAll(id: selectedQuarter!)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez sélectionner un quartier'),
                      duration: Duration(seconds: 2), // Durée de l'affichage
                    ),
                  );
                }
              },
              child: const Text(
                'Afficher les pharmacies',
                style: TextStyle(
                  fontSize: 16, // Taille du texte
                  fontWeight: FontWeight.bold, // Gras
                  color: Colors.white, // Couleur du texte
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color.fromARGB(255, 0, 93, 76), // Couleur de fond
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 12), // Espacement
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Bordures arrondies
                ),
                elevation: 5, // Ombre pour un effet de profondeur
              ),
            ),
          ],
        ),
      ),
    );
  }
}
