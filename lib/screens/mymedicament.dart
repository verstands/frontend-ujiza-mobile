import 'package:flutter/material.dart';
import 'package:ujiza/screens/addmymedicament.dart';

class Mymedicament extends StatefulWidget {
  const Mymedicament({super.key});

  @override
  State<Mymedicament> createState() => _MymedicamentState();
}

class _MymedicamentState extends State<Mymedicament> {
  // Liste des médicaments
  List<Medication> medications = [
    Medication(name: "Paracétamol", quantity: 30, price: 5.0),
    Medication(name: "Ibuprofène", quantity: 20, price: 7.5),
    Medication(name: "Aspirine", quantity: 50, price: 3.0),
    Medication(name: "Antihistaminique", quantity: 10, price: 12.0),
    Medication(name: "Amoxicilline", quantity: 15, price: 10.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes médicaments",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
        actions: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddMymedicament()),
                );
              },
              icon: const Icon(Icons.add),
              iconSize: 30,
              color: Color.fromARGB(255, 0, 93, 76),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(medication.name),
              subtitle: Text(
                  'Quantité: ${medication.quantity} - Prix: ${medication.price.toStringAsFixed(2)} €'),
            ),
          );
        },
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
