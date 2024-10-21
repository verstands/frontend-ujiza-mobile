import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/screens/mymedicament.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/produitservice.dart';

class AddMymedicament extends StatefulWidget {
  const AddMymedicament({super.key});

  @override
  State<AddMymedicament> createState() => _AddMymedicamentState();
}

class _AddMymedicamentState extends State<AddMymedicament> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _dosage = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String? id;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // Récupération de l'ID de la pharmacie
  void getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? agentString = prefs.getString('pharmacie_id');

    if (agentString != null) {
      setState(() {
        id = agentString;
      });
    }
  }

  void _loginCreate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Vérification et conversion du prix
      double? price;
      try {
        price = double.parse(_price.text);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez entrer un prix valide')));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Appel à l'API
      ApiResponse response = await CreateMymediment(
          _name.text,
          _dosage.text,
          price.toString(), // Conversion du prix en chaîne de caractères
          _description.text,
          id!);

      setState(() {
        _isLoading = false;
      });

      if (response.erreur == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Votre médicament a été ajouté avec succès')));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Mymedicament()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.erreur}')));
      }
    }
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                    child: const Icon(
                      Icons.medication,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Champ pour le nom du médicament
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(
                    labelText: 'Nom de médicament',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 93, 76)),
                    ),
                    prefixIcon: const Icon(Icons.medication,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le nom du médicament';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

                // Champ pour le dosage
                // Champ pour le dosage
                TextFormField(
                  controller: _dosage,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Dosage (mg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 93, 76)),
                    ),
                    prefixIcon: const Icon(Icons.numbers,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer le dosage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),

// Champ pour le prix
                TextFormField(
                  controller: _price,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Prix',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 0, 93, 76)),
                    ),
                    prefixIcon: const Icon(Icons.attach_money,
                        color: Color.fromARGB(255, 0, 93, 76)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prix';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Champ pour la description
                TextFormField(
                  controller: _description,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 0, 93, 76),
                      ),
                    ),
                    prefixIcon: const Icon(
                      Icons.description,
                      color: Color.fromARGB(255, 0, 93, 76),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Bouton pour ajouter le médicament
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _loginCreate,
                    icon: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 93, 76),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    label: const Text(
                      'Ajouter un médicament',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
