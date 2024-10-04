import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ujiza/models/produitPharModel.dart';
import 'package:ujiza/screens/detailMedoc.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:ujiza/services/produitservice.dart';
import 'package:ujiza/utils/customAppBar.dart';

class MedicamentsPage extends StatefulWidget {
  final String nomPharmacie;
  final String id;

  const MedicamentsPage(
      {super.key, required this.nomPharmacie, required this.id});

  @override
  _MedicamentsPageState createState() => _MedicamentsPageState();
}

class _MedicamentsPageState extends State<MedicamentsPage> {
  List<ProduitPharModel> medicaments = [];
  bool loading = true;

  Future<void> _fetchPharmacies() async {
    EasyLoading.show(status: 'Chargement des produits...');

    ApiResponse response = await getProduitListsByPharmacie(widget.id);
    if (response.erreur == null) {
      setState(() {
        medicaments = response.data as List<ProduitPharModel>;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${response.erreur}')),
      );
    }
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    _fetchPharmacies();
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Médicaments - ${widget.nomPharmacie}'),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Rechercher un médicament...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 0, 93, 76)),
              ),
            ),
          ),
          // Liste des médicaments
          Expanded(
            child: ListView.builder(
              itemCount: medicaments.where((medicament) {
                return medicament.nom!.toLowerCase().contains(searchQuery);
              }).length,
              itemBuilder: (context, index) {
                final medicament = medicaments.where((medicament) {
                  return medicament.nom!.toLowerCase().contains(searchQuery);
                }).toList()[index];

                return Card(
                  elevation: 3,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services,
                        color: Colors.green, size: 40),
                    title: Text(
                      medicament.nom!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dosage: ${medicament.dosage}mg'),
                        Text('Prix: ${medicament.prix} CDF',
                            style: const TextStyle(color: Colors.green)),
                      ],
                    ),
                    trailing:
                        const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Rediriger vers la page de détail du médicament
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicamentDetailPage(
                              medicament: {
                                'id': medicament.id!,
                                'nom': medicament.nom!,
                                'dosage': medicament.dosage!,
                                'prix': medicament.prix!,
                                'description': medicament.desciption!
                              },
                            ),
                          ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
