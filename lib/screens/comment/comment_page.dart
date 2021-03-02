import 'package:firebase_app/model/comment.dart';
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/comment/comment_component.dart';
import 'package:firebase_app/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatelessWidget {
  Vehicule vehicule;
  CommentWidget({this.vehicule});
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<Comment>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des commentaires"),
        backgroundColor: Colors.green,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: comments == null
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  : comments.length == 0
                      ? Center(
                          child: Text("Aucune voitures"),
                        )
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (ctx, i) {
                            final comment = comments[i];
                            return CommentComponent(comment: comment);
                          },
                        )),
          Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.green,
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      bool commentOk = await DBServices().add_comment(Comment(
                          id_comment_pub: vehicule.id,
                          id_user: UserM.currentUser.id,
                          msg: commentController.text));
                      if (commentOk) commentController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
