class QuartierModel {
  String? id;
  String? nom;
  String? idCommune;
  Null? paysId;
  Commune? commune;

  QuartierModel({this.id, this.nom, this.idCommune, this.paysId, this.commune});

  QuartierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    idCommune = json['id_commune'];
    paysId = json['paysId'];
    commune =
        json['commune'] != null ? new Commune.fromJson(json['commune']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom'] = this.nom;
    data['id_commune'] = this.idCommune;
    data['paysId'] = this.paysId;
    if (this.commune != null) {
      data['commune'] = this.commune!.toJson();
    }
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
