import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CarDetail extends StatefulWidget {
  final Vehicule v;
  CarDetail({this.v});

  @override
  _CarDetailState createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  Color color = Colors.green;

  UserM user;

  getUser() async {
    final u = await DBServices().getUser(widget.v.uid);
    if (u != null) {
      setState(() {
        user = u;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUser();
  }

  @override
  Widget build(BuildContext context) {
    color = widget.v.type == CarType.car ? Colors.green : Colors.lightBlue;
    IconData icon = widget.v.type == CarType.car
        ? FontAwesomeIcons.carAlt
        : FontAwesomeIcons.motorcycle;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(widget.v.marque),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Sliders(imgs: widget.v.images),
            SizedBox(
              height: 10,
            ),
            item(widget.v.marque, icon),
            item(widget.v.modele, icon),
            item(widget.v.prix + " €", FontAwesomeIcons.coins),
            item(widget.v.detailSup, icon),
            Divider(
              color: Colors.black,
            ),
            Text("User"),
            Divider(
              color: Colors.black,
            ),
            if (user != null)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: color,
                  backgroundImage:
                      user.image != null ? NetworkImage(user.image) : null,
                  child: user.image != null
                      ? Container()
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                  radius: 30,
                ),
                subtitle: Text(user.email),
                title: Text(
                  user.pseudo,
                  style: style.copyWith(fontSize: 18),
                ),
              ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  ListTile item(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: style.copyWith(fontSize: 20),
      ),
    );
  }
}
