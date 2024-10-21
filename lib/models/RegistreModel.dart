class UserModel {
  String? id;
  String? nom;
  String? prenom;
  String? mdp;
  String? telephone;
  String? statut;
  String? idFonction;
  String? email;

  UserModel(
      {this.id,
      this.nom,
      this.prenom,
      this.mdp,
      this.telephone,
      this.statut,
      this.idFonction,
      this.email});

  UserModel.fromJson(Map<String, dynamic> json) {
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
