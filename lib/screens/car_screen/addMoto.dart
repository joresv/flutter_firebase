import 'dart:io';

import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/getImage.dart';
import 'package:firebase_app/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddMoto extends StatefulWidget {
  @override
  _AddMotoState createState() => _AddMotoState();
}

class _AddMotoState extends State<AddMoto> {
  final key = GlobalKey<FormState>();
  String marque, model, prix, descrition;
  List<File> images = [];

  Vehicule moto = Vehicule();
  void initState() {
    // TODO: implement initState
    super.initState();
    moto.type = CarType.moto;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter une moto"),
          backgroundColor: Colors.lightBlue,
          actions: [Icon(FontAwesomeIcons.motorcycle)],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    validator: (e) => e.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => marque = e,
                    decoration: InputDecoration(
                        hintText: "Marque du vehicule",
                        labelText: "Marque",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (e) => e.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => model = e,
                    decoration: InputDecoration(
                        hintText: "Model du vehicule",
                        labelText: "Model",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (e) => e.isEmpty ? "Prix se champ" : null,
                    onChanged: (e) => prix = e,
                    decoration: InputDecoration(
                        hintText: "Prix du vehicule",
                        labelText: "Prix",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (e) => e.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => descrition = e,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "Détails supplémentaires",
                        labelText: "Détails",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < images.length; i++)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.4)),
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          height: 70,
                          width: 70,
                          child: Stack(
                            children: [
                              Image.file(
                                images[i],
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.minusCircle,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(i);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      InkWell(
                        onTap: () async {
                          final data = await showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return GetImage();
                              });
                          if (data != null)
                            setState(() {
                              images.add(data);
                            });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.lightBlue,
                          child: Icon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: FlatButton(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: Colors.lightBlue,
                      onPressed: () async {
                        if (key.currentState.validate() && images.length > 0) {
                          print(images);
                          loading(context);
                          moto.marque = marque;
                          moto.modele = model;
                          moto.prix = prix;
                          moto.detailSup = descrition;
                          moto.images = [];
                          moto.uid = FirebaseAuth.instance.currentUser.uid;
                          for (var i = 0; i < images.length; i++) {
                            String urlImage = await DBServices()
                                .uploadImage(images[i], path: "motos");
                            if (urlImage != null) moto.images.add(urlImage);
                          }
                          if (images.length == moto.images.length) {
                            bool save = await DBServices().savevehicule(moto);
                            if (save) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            ;
                          }
                        } else {
                          print("veillez remplir tous les champs");
                        }
                      },
                      child: Text("Enregistrer",
                          style: style.copyWith(
                              color: Colors.white, fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
