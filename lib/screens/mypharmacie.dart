import 'package:flutter/material.dart';
import 'package:ujiza/screens/mymedicament.dart';
import 'package:ujiza/utils/MeuApp.dart';
import 'package:ujiza/utils/customAppBar.dart';

class MyPharmacie extends StatefulWidget {
  const MyPharmacie({super.key});

  @override
  State<MyPharmacie> createState() => _MyPharmacieState();
}

class _MyPharmacieState extends State<MyPharmacie> {
  int totalMedications = 150; // Nombre total de médicaments
  double totalPrice = 1200.0; // Prix total des médicaments
  List<Medication> medications = []; // Liste de médicaments

  @override
  void initState() {
    super.initState();
    // Exemple de données de médicaments
    medications = [
      Medication(name: "Paracétamol", quantity: 30, price: 5.0),
      Medication(name: "Ibuprofène", quantity: 20, price: 7.5),
      Medication(name: "Aspirine", quantity: 50, price: 3.0),
      Medication(name: "Antihistaminique", quantity: 10, price: 12.0),
      Medication(name: "Amoxicilline", quantity: 15, price: 10.0),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tableau de bord",
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
            const Text(
              'Ma Pharmacie',
              style: TextStyle(
                fontSize: 24,
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
              value: '${totalPrice.toStringAsFixed(2)} €',
              icon: Icons.attach_money,
            ),
            const SizedBox(height: 20),
            Card(
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
                        // Action pour ajouter un médicament
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
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
                        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                      ),
                      child: const Text(
                        'Voir les médicaments',
                        style: TextStyle(
                            color: Colors.white), // Couleur du texte en blanc
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
