import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String id_user;
  String id_comment;
  String id_comment_pub;
  Timestamp date_comment;
  String msg;
  List<String> like;
  List<String> dislike;
  Comment(
      {this.date_comment,
      this.dislike,
      this.id,
      this.id_comment,
      this.id_user,
      this.like,
      this.id_comment_pub,
      this.msg});
  factory Comment.fromJson(Map<String, dynamic> j, String id) => Comment(
        id: id,
        id_user: j["id_user"],
        date_comment: j['date_comment'],
        like: j["like"] == null
            ? []
            : j["like"].map<String>((i) => i as String).toList(),
        dislike: j["dislike"] == null
            ? []
            : j["dislike"].map<String>((i) => i as String).toList(),
        id_comment: j["id_comment"],
        id_comment_pub: j['id_comment_pub'],
        msg: j['msg'],
      );
  Map<String, dynamic> toMap() => {
        "like": like,
        "dislike": dislike,
        "id_comment": id_comment,
        "date_comment": date_comment,
        "id_user": id_user,
        'id_comment_pub': id_comment_pub,
        "msg": msg
      };
}
