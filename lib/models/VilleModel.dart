class VilleModel {
  String? id;
  String? nom;
  String? idPays;

  VilleModel({this.id, this.nom, this.idPays});

  VilleModel.fromJson(Map<String, dynamic> json) {
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
