import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:medigo/screens/mypharmacie.dart';
import 'package:medigo/screens/updatemypharmacie.dart';
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
  String nomPharmacie = "Ma Pharmacie";
  String adresse = "123 Rue de la Santé, Kinshasa";
  String telephone = "+243 123 456 789";
  pharmacieModel? pharmacies;
  bool loading = true;
  String? id;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

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
        pharmacies = response.data as pharmacieModel;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
    EasyLoading.dismiss();
  }

  void _updatePharmacie() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      ApiResponse response = await UpdatePharmacieUser(
          _nameController.text, _addressController.text, pharmacies!.id!);
      setState(() {
        _isLoading = false;
      });

      if (response.erreur == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pharmacie modifiée avec succèssssssssssss')));

        await Future.delayed(const Duration(seconds: 1));
        _fetchDetail();
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
  void initState() {
    super.initState();
    getUser();
    _fetchDetail();
  }

  void _modifierInfos() {
    _nameController.text = pharmacies?.nom ?? "";
    _addressController.text = pharmacies?.communeavenu ?? "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modifier les Informations',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Le nom de la pharmacie est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'adresse est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                if (_formKey.currentState!.validate()) {
                  _updatePharmacie();
                  await _fetchDetail();
                  Navigator.of(context).pop();
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          nomPharmacie,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
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
                      builder: (context) => const AddMyPharmacie(),
                    ),
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
                  'Créer une pharmacie',
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
                                ? "${pharmacies!.communeavenu ?? ''}"
                                : "",
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
                          Row(
                            children: [
                              const Icon(Icons.flag,
                                  color: Color.fromARGB(255, 0, 93, 76)),
                              const SizedBox(width: 8),
                              Text(
                                'Pays:',
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
                                ? (pharmacies!.pays?.nom ?? "")
                                : "",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_city,
                                  color: Color.fromARGB(255, 0, 93, 76)),
                              const SizedBox(width: 8),
                              Text(
                                'Ville:',
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
                                ? (pharmacies!.villes?.nom ?? "")
                                : "",
                            style: const TextStyle(fontSize: 16),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.home,
                                  color: Color.fromARGB(255, 0, 93, 76)),
                              const SizedBox(width: 8),
                              Text(
                                'Quartier:',
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
                                ? (pharmacies!.qurtier?.nom ?? "")
                                : "",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateMyPharmacie(
                              medicament: {
                                'id': pharmacies!.id!,
                                'nom': pharmacies!.nom!,
                                'adresse': pharmacies!.communeavenu!
                              },
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        'Modifier',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
