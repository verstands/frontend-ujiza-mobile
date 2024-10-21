class ProduitPharModel {
  String? id;
  String? nom;
  String? dosage;
  String? prix;
  String? description;
  String? idPharmacie;
  Pharmacie? pharmacie;

  ProduitPharModel(
      {this.id,
      this.nom,
      this.dosage,
      this.prix,
      this.description,
      this.idPharmacie,
      this.pharmacie});

  ProduitPharModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    dosage = json['dosage'];
    prix = json['prix'];
    description = json['description'];
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
    data['description'] = this.description;
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
  String? commune;
  String? communeavenu;
  String? idQuartier;
  String? idUser;
  String? image;
  String? agentsId;

  Pharmacie(
      {this.id,
      this.nom,
      this.commune,
      this.communeavenu,
      this.idQuartier,
      this.idUser,
      this.image,
      this.agentsId});

  Pharmacie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    commune = json['commune'];
    communeavenu = json['communeavenu'];
    idQuartier = json['id_quartier'];
    idUser = json['id_user'];
    image = json['image'];
    agentsId = json['agentsId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['commune'] = this.commune;
    data['communeavenu'] = this.communeavenu;
    data['id_quartier'] = this.idQuartier;
    data['id_user'] = this.idUser;
    data['image'] = this.image;
    data['agentsId'] = this.agentsId;
    return data;
  }
}
