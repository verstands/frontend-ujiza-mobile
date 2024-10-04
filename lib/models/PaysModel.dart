class PaysModel {
  String? id;
  String? nom;

  PaysModel({this.id, this.nom});

  PaysModel.fromJson(Map<String, dynamic> json) {
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
