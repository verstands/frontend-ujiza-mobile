import 'package:flutter/material.dart';
import 'package:ujiza/utils/AdService.dart';
import 'package:ujiza/utils/MeuApp.dart';
import 'package:ujiza/utils/banniere.dart';
import 'package:ujiza/utils/customAppBar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Initialiser les annonces dès que la page est chargée
    AdService().initialize();
  }

  @override
  void dispose() {
    // Assurez-vous de libérer les ressources lorsque la page est détruite
    AdService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home page',
      ),
      drawer: AppMenu(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // Ajuste pour aligner en haut
            children: [
              // Ajouter la bannière ici
              const Banniere(), // Le widget bannière est maintenant en haut

              // Barre de recherche
              TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher produits...',
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
                onTap: () {
                  // Lorsque l'utilisateur clique sur le champ de texte
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

class SuggestionsPage extends StatelessWidget {
  final List<String> suggestions = [
    'Produit 1',
    'Produit 2',
    'Produit 3',
    'Produit 4',
    'Produit 5',
  ];

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
                hintText: 'Rechercher...',
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
              onTap: () {
                // Ajouter une action si nécessaire lorsque le champ est cliqué
              },
            ),
            const SizedBox(
                height:
                    16.0), // Espacement entre la barre de recherche et la liste
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      // Action lors du clic sur une suggestion
                      Navigator.pop(context); // Retourner à la page précédente
                    },
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
