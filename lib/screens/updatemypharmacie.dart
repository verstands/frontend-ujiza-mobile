import 'package:flutter/material.dart';
import 'package:medigo/screens/detailmypharmacie.dart';
import 'package:medigo/screens/mymedicament.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/pharmacieservice.dart';

class UpdateMyPharmacie extends StatefulWidget {
  final Map<String, String> medicament;
  const UpdateMyPharmacie({super.key, required this.medicament});

  @override
  State<UpdateMyPharmacie> createState() => _UpdateMyPharmacieState();
}

class _UpdateMyPharmacieState extends State<UpdateMyPharmacie> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.medicament['nom'] ?? '';
    _addressController.text = widget.medicament['adresse'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier  ma pharmacie',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 93, 76),
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
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 93, 76),
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
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          ApiResponse response = await UpdatePharmacieUser(
                            _nameController.text,
                            _addressController.text,
                            widget.medicament['id'].toString(),
                          );

                          setState(() {
                            _isLoading = false;
                          });

                          if (response.erreur == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailMypharmacie(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${response.erreur}')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Modifier',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
