import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medigo/models/PaysModel.dart';
import 'package:medigo/models/VilleModel.dart';
import 'package:medigo/services/paysservice.dart';
import 'package:medigo/services/villeservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/CommuneModel.dart';
import 'package:medigo/models/QuartierModel.dart';
import 'package:medigo/models/RegistreModel.dart';
import 'package:medigo/screens/detailmypharmacie.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/communeservice.dart';
import 'package:medigo/services/pharmacieservice.dart';
import 'package:medigo/services/quartierservice.dart';

class AddMyPharmacie extends StatefulWidget {
  const AddMyPharmacie({super.key});

  @override
  State<AddMyPharmacie> createState() => _AddMyPharmacieState();
}

class _AddMyPharmacieState extends State<AddMyPharmacie> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? selectedCountry;
  String? selectedCity;
  String? selectedCommune;
  String? selectedQuarter;
  bool loadingCountry = true;
  bool loadingCitie = true;
  bool loadingCommune = true;
  bool loadingQuartier = true;
  bool _isLoading = false;
  UserModel? user;
  String? id;

  List<PaysModel> countries = [];
  List<VilleModel> cities = [];
  List<CommuneModel> communes = [];
  List<QuartierModel> quartier = [];
  List<QuartierModel> quartierShared = [];

  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentString = prefs.getString('agent_id');

    if (agentString != null) {
      setState(() {
        id = agentString;
      });
    }
  }

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
    ApiResponse response = await getCommuneAll();
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
    getUser();
  }

  void _loginCreate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiResponse response = await CreatePharmacieService(
          _nameController.text,
          selectedCommune!,
          _addressController.text,
          selectedQuarter!,
          id,
          selectedCountry!,
          selectedCity!);
      setState(() {
        _isLoading = false;
      });

      if (response.erreur == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Votre pharmacie a été crée aevc success')));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => DetailMypharmacie()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.erreur}')));
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Creer ma pharmacie',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.local_pharmacy,
                        size: 80,
                        color: Color.fromARGB(255, 0, 93, 76),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom de la Pharmacies',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 93, 76)),
                    ),
                    prefixIcon: const Icon(Icons.store,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom de la pharmacie';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 93, 76)),
                    ),
                    prefixIcon: const Icon(Icons.location_on,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer l\'adresse';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

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
                          const Icon(Icons.public),
                          const SizedBox(width: 8),
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
                const SizedBox(height: 16.0),
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
                const SizedBox(height: 16.0),

                // Dropdown pour la sélection du quartier
                if (selectedCommune != null) ...[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Sélectionnez un quartier',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_pin,
                          color: Color.fromARGB(255, 0, 93, 76)),
                    ),
                    items: quartier.map((quarter) {
                      return DropdownMenuItem(
                        value: quarter.id,
                        child: Row(
                          children: [
                            const Icon(Icons.map, color: Colors.green),
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _loginCreate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 93, 76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    label: const Text(
                      'Creer ma pharmacie',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
