class UserM {
  String id, email, pseudo, image;
  bool admin, enable;
  static UserM currentUser;
  UserM(
      {this.id,
      this.pseudo,
      this.email,
      this.image,
      this.admin = false,
      this.enable = true});
  factory UserM.fromJson(Map<String, dynamic> j) => UserM(
      email: j['email'],
      id: j['id'],
      pseudo: j['pseudo'],
      image: j['image'],
      admin: j['admin'],
      enable: j["enable"]);
  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "pseudo": pseudo,
        "image": image,
        "admin": admin,
        "enable": enable
      };
}
