import 'package:flutter/material.dart';
import 'package:medigo/utils/customAppBar.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> contacts = [
      {
        'nom': 'Service Client',
        'telephone': '0123456789',
        'email': 'client@pharmacie.com',
      },
      {
        'nom': 'Support Technique',
        'telephone': '0987654321',
        'email': 'support@pharmacie.com',
      },
      {
        'nom': 'Assistance Pharmaceutique',
        'telephone': '0112233445',
        'email': 'assistance@pharmacie.com',
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: "Nos contacts"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.contact_phone, color: Colors.green),
                title: Text(contact['nom']!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Téléphone : ${contact['telephone']}'),
                    Text('Email : ${contact['email']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
