import 'package:flutter/material.dart';
import 'package:medigo/utils/MeuApp.dart';
import 'package:medigo/utils/app_open_ad.dart';
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
              child: const Text(
                'Modifier',
                style: TextStyle(color: Color.fromARGB(255, 0, 93, 76)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Médicament supprimé !')),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Oui'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
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
                        overflow: TextOverflow
                            .ellipsis, // Ajoute une ellipsis si le texte est trop long
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
                      // Assure que le texte s'adapte à la largeur disponible
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
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text('Modifier',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
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
      ),
    );
  }
}
