import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/getImage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserM>(context);
    return Container(
      color: Colors.white,
      width: 250,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(user.email ?? "Aucun"),
            accountName: Text(user.pseudo ?? "Aucun"),
            currentAccountPicture: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage:
                    user.image != null ? NetworkImage(user.image) : null,
                child: Stack(children: [
                  if (user.image == null)
                    Center(child: Icon(Icons.person, color: Colors.black)),
                  if (loading)
                    Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    )),
                  Positioned(
                    top: 38,
                    left: 13,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        final data = await showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return GetImage();
                            });
                        if (data != null) {
                          loading = true;
                          setState(() {});
                          String urlImage = await DBServices()
                              .uploadImage(data, path: "profil");
                          if (urlImage != null) {
                            final updateUser = user;
                            updateUser.image = urlImage;
                            bool isupdate =
                                await DBServices().updateUser(updateUser);
                            if (isupdate) {
                              loading = false;
                              setState(() {});
                            }
                          }
                        }
                      },
                    ),
                  )
                ])),
          ),
        ],
      ),
    );
  }
}
