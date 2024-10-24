import 'package:flutter/material.dart';
import 'package:medigo/screens/mymedicament.dart';
import 'package:medigo/screens/mypharmacie.dart';
import 'package:medigo/screens/updatemymedoc.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/produitservice.dart';
import 'package:medigo/utils/MeuApp.dart';
import 'package:medigo/utils/app_open_ad.dart';
import 'package:medigo/utils/banniere.dart';
import 'package:medigo/utils/customAppBar.dart';

class MyMedicamentDetailPage extends StatefulWidget {
  final Map<String, String> medicament;

  const MyMedicamentDetailPage({super.key, required this.medicament});

  @override
  _MyMedicamentDetailPageState createState() => _MyMedicamentDetailPageState();
}

class _MyMedicamentDetailPageState extends State<MyMedicamentDetailPage> {
  late final AppOpenAdManager _appOpenAdManager;

  @override
  void initState() {
    super.initState();
    _appOpenAdManager = AppOpenAdManager();
    _appOpenAdManager.loadAd();
  }

  @override
  void dispose() {
    _appOpenAdManager.dispose();
    super.dispose();
  }

  Future<void> _deletemedoc() async {
    ApiResponse response = await DeleteProduitUser(widget.medicament['id']!);
    if (response.erreur == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Médicament supprimé avec succès !')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Mymedicament(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
  }

  void _showEditDialog() {
    final TextEditingController nomController =
        TextEditingController(text: widget.medicament['nom']);
    final TextEditingController dosageController =
        TextEditingController(text: widget.medicament['dosage']);
    final TextEditingController prixController =
        TextEditingController(text: widget.medicament['prix']);
    final TextEditingController descriptionController =
        TextEditingController(text: widget.medicament['description']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Modifier Médicament',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomController,
                  decoration: InputDecoration(
                    labelText: 'Nom',
                    prefixIcon: const Icon(Icons.medical_services),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dosageController,
                  decoration: InputDecoration(
                    labelText: 'Dosage (mg)',
                    prefixIcon: const Icon(Icons.fitness_center),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: prixController,
                  decoration: InputDecoration(
                    labelText: 'Prix (CDF)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
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
                if (nomController.text.isNotEmpty &&
                    dosageController.text.isNotEmpty &&
                    prixController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  ApiResponse response = await UpdateProduitUser(
                    nomController.text,
                    dosageController.text,
                    prixController.text,
                    descriptionController.text,
                    widget.medicament['id']!,
                  );

                  if (response.erreur == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Médicament modifié avec succès')),
                    );
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${response.erreur}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Veuillez remplir tous les champs.')),
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation de Suppression'),
          content:
              const Text('Êtes-vous sûr de vouloir supprimer ce médicament ?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Fermer le dialog

                // Appeler la méthode de suppression et attendre sa réponse
                await _deletemedoc();
              },
              child: const Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialog
              },
              child: const Text('Non'),
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
          'Détails du ${widget.medicament['nom']}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      drawer: AppMenu(),
      body: SingleChildScrollView(
        // Ajout du SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 50,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.medicament['nom']!,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.local_pharmacy, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Dosage : ${widget.medicament['dosage']}mg',
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Prix : ${widget.medicament['prix']} CDF',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.description, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Description : ${widget.medicament['description']}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Icon(Icons.store, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Pharmacie : ${widget.medicament['pharmacie']}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.location_city, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Commune : ${widget.medicament['commune']}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Téléphone : ${widget.medicament['telephone']}',
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateMyMedoc(
                                  medicament: {
                                    'id': widget.medicament['id'].toString(),
                                    'nom': widget.medicament['nom'].toString(),
                                    'dosage':
                                        widget.medicament['dosage'].toString(),
                                    'prix':
                                        widget.medicament['prix'].toString(),
                                    'description': widget
                                        .medicament['description']
                                        .toString(),
                                    'pharmacie': widget.medicament['pharmacie']
                                        .toString(),
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.white),
                          label: const Text(
                            'Modifier',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 0, 93, 76),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _showDeleteConfirmationDialog,
                          icon: const Icon(Icons.delete, color: Colors.white),
                          label: const Text('Supprimer',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            BannierePub(),
          ],
        ),
      ),
    );
  }
}
