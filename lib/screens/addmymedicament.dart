import 'package:flutter/material.dart';

class AddMymedicament extends StatefulWidget {
  const AddMymedicament({super.key});

  @override
  State<AddMymedicament> createState() => _AddMymedicamentState();
}

class _AddMymedicamentState extends State<AddMymedicament> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _dosage = '';
  String _price = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajouter un Médicament',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Prendre toute la largeur
            children: [
              // Champ Nom du Médicament
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nom du Médicament',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.medication),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du médicament';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Champ Dosage
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Dosage (mg)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.health_and_safety),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le dosage';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _dosage = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Champ Prix
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prix',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le prix';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _price = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Bouton Ajouter le Médicament
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Logique pour soumettre le formulaire ici
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Médicament ajouté !')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                  padding: const EdgeInsets.symmetric(
                      vertical: 15), // Espacement vertical
                ),
                child: const Text(
                  'Ajouter le Médicament',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
