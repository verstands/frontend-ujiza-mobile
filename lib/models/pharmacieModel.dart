class pharmacieModel {
  String? id;
  String? nom;
  String? telephone;
  String? commune;
  String? communeavenu;
  String? idQuartier;
  Quartier? quartier;

  pharmacieModel({
    this.id,
    this.nom,
    this.telephone,
    this.commune,
    this.communeavenu,
    this.idQuartier,
    this.quartier,
  });

  pharmacieModel.fromJson(Map<String, dynamic> json) {
    print('Données JSON : $json'); // Vérifie ce que tu reçois
    id = json['id'];
    nom = json['nom'];
    telephone =
        json['telephone']; // Vérifie que 'telephone' existe dans ton JSON
    commune = json['commune']; // Idem pour 'commune'
    communeavenu = json['communeavenu']; // Idem pour 'communeavenu'
    idQuartier = json['id_quartier']; // Vérifie cette clé aussi
    quartier = json['quartier'] != null
        ? Quartier.fromJson(json['quartier'])
        : null; // Correction de la clé 'quartier'
    print('PharmacieModel: $this');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['telephone'] = this.telephone;
    data['commune'] = this.commune;
    data['communeavenu'] = this.communeavenu;
    data['id_quartier'] = this.idQuartier;
    if (this.quartier != null) {
      data['quartier'] =
          this.quartier!.toJson(); // Correction de la clé 'quartier'
    }
    return data;
  }

  @override
  String toString() {
    return 'PharmacieModel(id: $id, nom: $nom, telephone: $telephone, commune: $commune, communeavenu: $communeavenu, quartier: $quartier)';
  }
}

class Quartier {
  String? id;
  String? nom;
  String? idCommune;
  String? paysId;

  Quartier({this.id, this.nom, this.idCommune, this.paysId});

  Quartier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    idCommune = json['id_commune'];
    paysId = json['paysId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['id_commune'] = this.idCommune;
    data['paysId'] = this.paysId;
    return data;
  }
}
