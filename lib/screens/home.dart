import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medigo/models/QuartierModel.dart';
import 'package:medigo/models/produitPharModel.dart';
import 'package:medigo/screens/SearchPharcmacieAll.dart';
import 'package:medigo/screens/detailMedoc.dart';
import 'package:medigo/screens/pharmaciieAllList.dart';
import 'package:medigo/services/api_response.dart';
import 'package:medigo/services/produitservice.dart';
import 'package:medigo/utils/AdService.dart';
import 'package:medigo/utils/MeuApp.dart';
import 'package:medigo/utils/banniere.dart';
import 'package:medigo/utils/carousel.dart';
import 'package:medigo/utils/customAppBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  String quartierInfo = '';
  String qid = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedQuarter();
  }

  Future<void> _loadSelectedQuarter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? quartierJson = prefs.getString('quartier');
    if (quartierJson != null) {
      Map<String, dynamic> quartierMap = jsonDecode(quartierJson);
      QuartierModel quartier = QuartierModel(
        id: quartierMap['id'],
        nom: quartierMap['nom'],
        //commune: Commune(nom: quartierMap['communeNom']),
      );

      setState(() {
        quartierInfo = '${quartier.nom}, ${quartier.commune?.nom}';
        qid = '${quartier.id}';
        isLoading = false;
      });
    } else {
      setState(() {
        quartierInfo = 'Aucun quartier trouvé.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 93, 76),
        title: Text(
          isLoading ? 'Chargement...' : quartierInfo,
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CarouselPage(),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/logo/medigoacceuil.png'),
                    const SizedBox(
                      height: 5,
                    ),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuggestionsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              BannierePub(),
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
  List<ProduitPharModel> filteredSuggestions = [];
  bool loading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPoduit();
    searchController.addListener(_filterSuggestions);
  }

  Future<void> _fetchPoduit() async {
    EasyLoading.show(status: 'Chargement des produits...');

    ApiResponse response = await getProduitList();
    if (response.erreur == null) {
      setState(() {
        suggestions = response.data as List<ProduitPharModel>;
        filteredSuggestions = suggestions;
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

  void _filterSuggestions() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredSuggestions = suggestions.where((produit) {
        return produit.nom!
            .toLowerCase()
            .contains(query); // Filter based on name
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Recherche"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
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
            Expanded(
              child: loading
                  ? Center(child: Text(""))
                  : ListView.builder(
                      itemCount: filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final produit = filteredSuggestions[index];
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
                                    'prix': produit.prix.toString(),
                                    'description': produit.description!,
                                    'pharmacie': produit.pharmacie!.nom!,
                                    'commune': produit.pharmacie!.commune!.nom!,
                                    'telephone':
                                        produit.pharmacie!.agents!.telephone!,
                                  },
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 12.0),
                                      child: Icon(
                                        Icons.medical_services_outlined,
                                        color: Color.fromARGB(255, 0, 93, 76),
                                        size: 50.0,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            produit.nom ?? '',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 6.0),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.local_pharmacy,
                                                size: 16.0,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                produit.pharmacie!.nom!,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_city,
                                                size: 16.0,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                produit
                                                    .pharmacie!.commune!.nom!,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 13.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.attach_money,
                                                size: 16.0,
                                                color: Colors.grey[600],
                                              ),
                                              SizedBox(width: 4.0),
                                              Text(
                                                '${produit.prix} CDF',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16.0,
                                      color: Colors.grey[600],
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[400],
                                thickness: 1.0,
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
