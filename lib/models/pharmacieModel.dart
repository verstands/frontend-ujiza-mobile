class pharmacieModel {
  String? id;
  String? nom;
  String? commune;
  String? communeavenu;
  String? idQuartier;
  String? idUser;
  String? image;
  String? agentsId;
  Qurtier? qurtier;
  Agents? agents;

  pharmacieModel(
      {this.id,
      this.nom,
      this.commune,
      this.communeavenu,
      this.idQuartier,
      this.idUser,
      this.image,
      this.agentsId,
      this.qurtier,
      this.agents});

  pharmacieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    commune = json['commune'];
    communeavenu = json['communeavenu'];
    idQuartier = json['id_quartier'];
    idUser = json['id_user'];
    image = json['image'];
    agentsId = json['agentsId'];
    qurtier =
        json['qurtier'] != null ? new Qurtier.fromJson(json['qurtier']) : null;
    agents =
        json['Agents'] != null ? new Agents.fromJson(json['Agents']) : null;
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
    if (this.qurtier != null) {
      data['qurtier'] = this.qurtier!.toJson();
    }
    if (this.agents != null) {
      data['Agents'] = this.agents!.toJson();
    }
    return data;
  }
}

class Qurtier {
  String? id;
  String? nom;
  String? idCommune;
  Null? paysId;

  Qurtier({this.id, this.nom, this.idCommune, this.paysId});

  Qurtier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    idCommune = json['id_commune'];
    paysId = json['paysId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['id_commune'] = this.idCommune;
    data['paysId'] = this.paysId;
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
