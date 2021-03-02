import 'package:firebase_app/model/comment.dart';
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/comment/coment_comment.dart';
import 'package:firebase_app/screens/comment/comment_page.dart';
import 'package:firebase_app/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamComment extends StatelessWidget {
  Vehicule vehicule;
  StreamComment({this.vehicule});
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    String count = "";
    if (comment_lenght != null) {
      count = comment_lenght > 1
          ? "$comment_lenght commentaires"
          : "$comment_lenght commentaire";
    }
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                      value: DBServices().gecomment(vehicule.id),
                      child: CommentWidget(
                        vehicule: vehicule,
                      ),
                    )));
          },
        ),
        Text(count)
      ],
    );
  }
}

class StreamCommentComment extends StatelessWidget {
  Comment comment;
  UserM user;
  StreamCommentComment({this.comment, this.user});
  @override
  Widget build(BuildContext context) {
    final comment_lenght = Provider.of<int>(context);
    int count = 0;
    if (comment_lenght != null) {
      count = comment_lenght;
    }
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.message,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => StreamProvider<List<Comment>>.value(
                      value: DBServices().gecommentComment(comment.id),
                      child: CommentCommentWidget(
                          comment: comment, user: this.user),
                    )));
          },
        ),
        Text("$count", style: TextStyle(fontSize: 17, color: Colors.white))
      ],
    );
  }
}
