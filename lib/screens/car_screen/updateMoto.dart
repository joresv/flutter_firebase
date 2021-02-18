import 'dart:io';

import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/getImage.dart';
import 'package:firebase_app/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateMoto extends StatefulWidget {
  Vehicule v;
  UpdateMoto({this.v});
  @override
  _UpdateMotoState createState() => _UpdateMotoState();
}

class _UpdateMotoState extends State<UpdateMoto> {
  final key = GlobalKey<FormState>();
  String marque, model, prix, descrition;
  List<dynamic> images = [];

  Vehicule moto = Vehicule();
  void initState() {
    // TODO: implement initState
    super.initState();
    moto.type = CarType.moto;
    marque = widget.v.marque;
    prix = widget.v.prix;
    model = widget.v.modele;
    descrition = widget.v.detailSup;
    images.addAll(widget.v.images);
    moto = widget.v;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modifier " + widget.v.marque),
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
                    initialValue: marque,
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
                    initialValue: model,
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
                    initialValue: prix,
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
                    initialValue: descrition,
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
                              if (images[i] is File)
                                Image.file(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              if (images[i] is String)
                                Image.network(
                                  images[i],
                                  fit: BoxFit.fitHeight,
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
                          loading(context);
                          moto.marque = marque;
                          moto.modele = model;
                          moto.prix = prix;
                          moto.detailSup = descrition;
                          moto.images = [];
                          moto.uid = FirebaseAuth.instance.currentUser.uid;
                          for (var i = 0; i < images.length; i++) {
                            if (images[i] is File) {
                              String urlImage = await DBServices()
                                  .uploadImage(images[i], path: "motos");
                              if (urlImage != null) moto.images.add(urlImage);
                            } else {
                              moto.images.add(images[i]);
                            }
                          }
                          if (images.length == moto.images.length) {
                            bool update =
                                await DBServices().updatevehicule(moto);
                            if (update) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            ;
                          }
                        } else {
                          print("veillez remplir tous les champs");
                        }
                      },
                      child: Text("Modifier",
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
