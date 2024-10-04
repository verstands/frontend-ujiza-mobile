class CommuneModel {
  String? id;
  String? nom;
  String? idVille;
  Null? paysId;

  CommuneModel({this.id, this.nom, this.idVille, this.paysId});

  CommuneModel.fromJson(Map<String, dynamic> json) {
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
