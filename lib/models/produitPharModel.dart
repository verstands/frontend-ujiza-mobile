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
  String? idcommune;
  String? communeavenu;
  String? idQuartier;
  String? idUser;
  String? image;
  String? idville;
  String? idpays;
  String? agentsId;
  Agents? agents;
  Commune? commune;

  Pharmacie(
      {this.id,
      this.nom,
      this.idcommune,
      this.communeavenu,
      this.idQuartier,
      this.idUser,
      this.image,
      this.idville,
      this.idpays,
      this.agentsId,
      this.agents,
      this.commune});

  Pharmacie.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    idcommune = json['idcommune'];
    communeavenu = json['communeavenu'];
    idQuartier = json['id_quartier'];
    idUser = json['id_user'];
    image = json['image'];
    idville = json['idville'];
    idpays = json['idpays'];
    agentsId = json['agentsId'];
    agents =
        json['agents'] != null ? new Agents.fromJson(json['agents']) : null;
    commune =
        json['commune'] != null ? new Commune.fromJson(json['commune']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['idcommune'] = this.idcommune;
    data['communeavenu'] = this.communeavenu;
    data['id_quartier'] = this.idQuartier;
    data['id_user'] = this.idUser;
    data['image'] = this.image;
    data['idville'] = this.idville;
    data['idpays'] = this.idpays;
    data['agentsId'] = this.agentsId;
    if (this.agents != null) {
      data['agents'] = this.agents!.toJson();
    }
    if (this.commune != null) {
      data['commune'] = this.commune!.toJson();
    }
    return data;
  }
}

class Agents {
  String? id;
  String? nom;
  String? prenom;
  String? mdp;
  String? telephone;
  String? statut;
  String? idFonction;
  String? email;

  Agents(
      {this.id,
      this.nom,
      this.prenom,
      this.mdp,
      this.telephone,
      this.statut,
      this.idFonction,
      this.email});

  Agents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    mdp = json['mdp'];
    telephone = json['telephone'];
    statut = json['statut'];
    idFonction = json['id_fonction'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['prenom'] = this.prenom;
    data['mdp'] = this.mdp;
    data['telephone'] = this.telephone;
    data['statut'] = this.statut;
    data['id_fonction'] = this.idFonction;
    data['email'] = this.email;
    return data;
  }
}

class Commune {
  String? id;
  String? nom;
  String? idVille;
  Null? paysId;

  Commune({this.id, this.nom, this.idVille, this.paysId});

  Commune.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    idVille = json['id_ville'];
    paysId = json['paysId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['id_ville'] = this.idVille;
    data['paysId'] = this.paysId;
    return data;
  }
}
