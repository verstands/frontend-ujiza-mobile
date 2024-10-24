import 'package:flutter/material.dart';
import 'package:medigo/screens/mymedicament.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/produitservice.dart';

class UpdateMyMedoc extends StatefulWidget {
  final Map<String, String> medicament;
  const UpdateMyMedoc({super.key, required this.medicament});

  @override
  State<UpdateMyMedoc> createState() => _UpdateMyMedocState();
}

class _UpdateMyMedocState extends State<UpdateMyMedoc> {
  late TextEditingController nomController;
  late TextEditingController dosageController;
  late TextEditingController prixController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    // Vérifier si les valeurs ne sont pas nulles
    nomController = TextEditingController(text: widget.medicament['nom'] ?? '');
    dosageController =
        TextEditingController(text: widget.medicament['dosage'] ?? '');
    prixController =
        TextEditingController(text: widget.medicament['prix'] ?? '');
    descriptionController =
        TextEditingController(text: widget.medicament['description'] ?? '');
  }

  @override
  void dispose() {
    // Libérer la mémoire lorsque les contrôleurs ne sont plus nécessaires
    nomController.dispose();
    dosageController.dispose();
    prixController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Modifier medicament ${widget.medicament['nom']}',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 24),
            SizedBox(
              width: double
                  .infinity, // Le bouton prend toute la largeur disponible
              child: ElevatedButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
