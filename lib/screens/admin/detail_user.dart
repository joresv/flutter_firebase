import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/utils/vehiculeCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailUser extends StatelessWidget {
  final UserM user;
  DetailUser({this.user});
  @override
  Widget build(BuildContext context) {
    final List<Vehicule> cars = Provider.of<List<Vehicule>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Informations de l'utilisateur"),
      ),
      body: cars == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 10),
              itemCount: cars.length + 1,
              itemBuilder: (_, i) {
                if (i == 0) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.red,
                          backgroundImage: user.image != null
                              ? NetworkImage(user.image)
                              : null,
                          child: user.image != null
                              ? Container()
                              : Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      Text(
                        "Pseudo: ${user.pseudo}",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text("Email: ${user.email}",
                          style: Theme.of(context).textTheme.headline6),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(top: 20, left: 10),
                        child: Text("Publications: ${cars.length}",
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ],
                  );
                } else {
                  final car = cars[i - 1];
                  return i == cars.length
                      ? Container(
                          child: VCard(car: car),
                          margin: EdgeInsets.only(bottom: 80),
                        )
                      : VCard(car: car);
                }
              }),
    );
  }
}
