import 'package:flutter/material.dart';
import 'package:ujiza/utils/customAppBar.dart';

class MedicamentDetailPage extends StatelessWidget {
  final Map<String, String> medicament;

  const MedicamentDetailPage({super.key, required this.medicament});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Détails du ${medicament['nom']}'),
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
                        medicament['nom']!,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.local_pharmacy, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Dosage : ${medicament['dosage']}mg',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.green),
                    const SizedBox(width: 10),
                    Text(
                      'Prix : ${medicament['prix']} CDF',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
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
                        'Description : ${medicament['description']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
