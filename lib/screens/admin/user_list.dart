import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/admin/detail_user.dart';
import 'package:firebase_app/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    final allUsers = Provider.of<List<UserM>>(context);
    return allUsers == null
        ? Center(
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ))
        : allUsers.length == 0
            ? Center(child: Text("Aucun utilisateur"))
            : ListView.builder(
                itemCount: allUsers.length,
                itemBuilder: (_, i) {
                  final userm = allUsers[i];
                  return Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        ListTile(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      StreamProvider<List<Vehicule>>.value(
                                        value: DBServices()
                                            .getvehicule(uid: userm.id),
                                        child: DetailUser(user: userm),
                                      ))),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.red,
                            backgroundImage: userm.image != null
                                ? NetworkImage(userm.image)
                                : null,
                            child: userm.image != null
                                ? Container()
                                : Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text("${userm.pseudo}"),
                          subtitle: Text("${userm.email}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!userm.admin)
                                IconButton(
                                  icon: Icon(
                                      userm.enable
                                          ? Icons.lock_open
                                          : Icons.lock,
                                      color: userm.enable
                                          ? Colors.green
                                          : Colors.red),
                                  onPressed: () async {
                                    await DBServices().updateUser(
                                        userm..enable = !userm.enable);
                                  },
                                ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.lightBlue),
                                onPressed: () {},
                              ),
                              if (userm.admin)
                                Icon(
                                  Icons.star,
                                  color: Colors.red,
                                )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5, left: 30, right: 5),
                          height: 1,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                },
              );
  }
}
