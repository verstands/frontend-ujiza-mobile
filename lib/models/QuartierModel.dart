class QuartierModel {
  String? id;
  String? nom;
  String? idCommune;
  Null? paysId;

  QuartierModel({this.id, this.nom, this.idCommune, this.paysId});

  QuartierModel.fromJson(Map<String, dynamic> json) {
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
