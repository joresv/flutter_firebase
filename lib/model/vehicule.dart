class Vehicule {
  List<String> images;
  List<String> like;
  List<String> dislike;
  List<String> favories;
  String marque;
  String modele;
  String prix;
  String detailSup;
  String uid;
  CarType type;
  String id;
  Vehicule(
      {this.detailSup,
      this.images,
      this.marque,
      this.modele,
      this.prix,
      this.type,
      this.id,
      this.uid,
      this.dislike,
      this.like,
      this.favories});

  factory Vehicule.fromJson(Map<String, dynamic> map, {String id}) => Vehicule(
      id: id,
      marque: map["marque"],
      modele: map["modele"],
      prix: map["prix"],
      detailSup: map["detailSup"],
      uid: map["uid"],
      images: map["images"].map<String>((i) => i as String).toList(),
      like: map["like"] == null
          ? []
          : map["like"].map<String>((i) => i as String).toList(),
      favories: map["favories"] == null
          ? []
          : map["favories"].map<String>((i) => i as String).toList(),
      dislike: map["dislike"] == null
          ? []
          : map["dislike"].map<String>((i) => i as String).toList(),
      type: map["type"] == "car" ? CarType.car : CarType.moto);

  Map<String, dynamic> toMap() {
    return {
      "type": type == CarType.car ? "car" : "moto",
      "images": images,
      "marque": marque,
      "modele": modele,
      "detailSup": detailSup,
      "prix": prix,
      "uid": uid,
      "like": like,
      "dislike": dislike,
      "favories": favories
    };
  }
}

enum CarType { car, moto }
