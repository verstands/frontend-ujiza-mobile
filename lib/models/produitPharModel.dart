class ProduitPharModel {
  String? id;
  String? nom;
  String? dosage;
  String? prix;
  String? desciption;
  String? idPharmacie;
  Pharmacie? pharmacie;

  ProduitPharModel(
      {this.id,
      this.nom,
      this.dosage,
      this.prix,
      this.desciption,
      this.idPharmacie,
      this.pharmacie});

  ProduitPharModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    dosage = json['dosage'];
    prix = json['prix'];
    desciption = json['desciption'];
    idPharmacie = json['id_pharmacie'];
    pharmacie = json['pharmacie'] != null
        ? new Pharmacie.fromJson(json['pharmacie'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['dosage'] = this.dosage;
    data['prix'] = this.prix;
    data['desciption'] = this.desciption;
    data['id_pharmacie'] = this.idPharmacie;
    if (this.pharmacie != null) {
      data['pharmacie'] = this.pharmacie!.toJson();
    }
    return data;
  }
}

class Pharmacie {
  String? id;
  String? nom;
  String? telephone;
  String? commune;
  String? communeavenu;
  String? idQuartier;

  Pharmacie(
      {this.id,
      this.nom,
      this.telephone,
      this.commune,
      this.communeavenu,
      this.idQuartier});

  Pharmacie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    telephone = json['telephone'];
    commune = json['commune'];
    communeavenu = json['communeavenu'];
    idQuartier = json['id_quartier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['telephone'] = this.telephone;
    data['commune'] = this.commune;
    data['communeavenu'] = this.communeavenu;
    data['id_quartier'] = this.idQuartier;
    return data;
  }
}
