class pharmacieModel {
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
  Qurtier? qurtier;
  Commune? commune;
  Villes? villes;
  Pays? pays;
  Agents? agents;

  pharmacieModel(
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
      this.qurtier,
      this.commune,
      this.villes,
      this.pays,
      this.agents});

  pharmacieModel.fromJson(Map<String, dynamic> json) {
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
    qurtier =
        json['qurtier'] != null ? new Qurtier.fromJson(json['qurtier']) : null;
    commune =
        json['commune'] != null ? new Commune.fromJson(json['commune']) : null;
    villes =
        json['villes'] != null ? new Villes.fromJson(json['villes']) : null;
    pays = json['pays'] != null ? new Pays.fromJson(json['pays']) : null;
    agents =
        json['agents'] != null ? new Agents.fromJson(json['agents']) : null;
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
    if (this.qurtier != null) {
      data['qurtier'] = this.qurtier!.toJson();
    }
    if (this.commune != null) {
      data['commune'] = this.commune!.toJson();
    }
    if (this.villes != null) {
      data['villes'] = this.villes!.toJson();
    }
    if (this.pays != null) {
      data['pays'] = this.pays!.toJson();
    }
    if (this.agents != null) {
      data['agents'] = this.agents!.toJson();
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

class Villes {
  String? id;
  String? nom;
  String? idPays;

  Villes({this.id, this.nom, this.idPays});

  Villes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    idPays = json['id_pays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['id_pays'] = this.idPays;
    return data;
  }
}

class Pays {
  String? id;
  String? nom;

  Pays({this.id, this.nom});

  Pays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
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
