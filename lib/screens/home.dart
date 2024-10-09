import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujiza/models/QuartierModel.dart';
import 'package:ujiza/models/produitPharModel.dart';
import 'package:ujiza/screens/SearchPharcmacieAll.dart';
import 'package:ujiza/screens/detailMedoc.dart';
import 'package:ujiza/screens/pharmaciieAllList.dart';
import 'package:ujiza/services/api_response.dart';
import 'package:ujiza/services/produitservice.dart';
import 'package:ujiza/utils/AdService.dart';
import 'package:ujiza/utils/MeuApp.dart';
import 'package:ujiza/utils/banniere.dart';
import 'package:ujiza/utils/customAppBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true; // Variable pour gérer l'état de chargement
  String quartierInfo = ''; // Initialisation de quartierInfo
  String qid = ''; // Initialisation de quartierInfo

  @override
  void initState() {
    super.initState();
    _loadSelectedQuarter();
  }

  // Fonction qui charge le quartier depuis SharedPreferences
  Future<void> _loadSelectedQuarter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? quartierJson = prefs.getString('quartier');

    // Si les données sont présentes
    if (quartierJson != null) {
      Map<String, dynamic> quartierMap = jsonDecode(quartierJson);
      QuartierModel quartier = QuartierModel(
        id: quartierMap['id'],
        nom: quartierMap['nom'],
        commune: Commune(nom: quartierMap['communeNom']),
      );

      setState(() {
        quartierInfo = '${quartier.nom}, ${quartier.commune?.nom}';
        qid = '${quartier.id}';
        isLoading = false; // Changer l'état une fois les données chargées
      });
    } else {
      setState(() {
        quartierInfo = 'Aucun quartier trouvé.';
        isLoading = false; // Changer l'état si aucun quartier n'est trouvé
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
        title: Text(
          isLoading
              ? 'Chargement...'
              : quartierInfo, // Affichage de 'Chargement...' tant que les données ne sont pas disponibles
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchPharmacieAll(id: qid)),
              );
            },
            icon: const Icon(Icons.shop_two),
            iconSize: 40,
            color: Colors.white,
          ),
        ],
      ),
      drawer: AppMenu(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centrer verticalement
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centrer horizontalement
            children: [
              BannierePub(),
              Image.asset('assets/logo/ujizalogo.png'),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher produits...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 0, 93, 76),
                  ),
                ),
                onTap: () {
                  // Naviguer vers la page de suggestions
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SuggestionsPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SuggestionsPage extends StatefulWidget {
  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  List<ProduitPharModel> suggestions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPoduit();
  }

  Future<void> _fetchPoduit() async {
    EasyLoading.show(status: 'Chargement des produits...');

    ApiResponse response = await getProduitList();
    if (response.erreur == null) {
      setState(() {
        suggestions = response.data as List<ProduitPharModel>;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Recherche"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barre de recherche
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher produits',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 0, 93, 76),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Liste des produits
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final produit = suggestions[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MedicamentDetailPage(
                              medicament: {
                                'id': produit.id!,
                                'nom': produit.nom!,
                                'dosage': produit.dosage!,
                                'prix': produit.prix!,
                                'description': produit.desciption!
                              },
                            ),
                          ));
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icône à gauche (taille plus grande pour simuler une image)
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Icon(
                                  Icons
                                      .medical_services_outlined, // Icône pour les produits
                                  color: Color.fromARGB(255, 0, 93, 76),
                                  size:
                                      50.0, // Taille plus grande pour ressembler à une vignette
                                ),
                              ),
                              // Texte à droite
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Nom du produit (titre)
                                    Text(
                                      produit.nom ?? 'Sans nom',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                        height:
                                            4.0), // Espacement entre le titre et la description
                                    // Description du produit (sous-titre)
                                    Text(
                                      produit.desciption != null
                                          ? produit.desciption!.length > 30
                                              ? produit.desciption!
                                                      .substring(0, 30) +
                                                  '...'
                                              : produit.desciption!
                                          : 'Aucune description disponible',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    SizedBox(height: 6.0),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16.0,
                                          color: Colors.grey[600],
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          (produit.pharmacie?.commune != null &&
                                                  produit.pharmacie!.commune!
                                                      .isNotEmpty)
                                              ? produit.pharmacie!.id!
                                              : 'Commune inconnue',
                                          style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Icône flèche à droite pour la navigation
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                        // Ajouter un Divider ici pour la ligne horizontale
                        Divider(
                          color: Colors.grey[400], // Couleur de la ligne
                          thickness: 1.0, // Épaisseur de la ligne
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}
