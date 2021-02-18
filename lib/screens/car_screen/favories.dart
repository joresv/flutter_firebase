import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/utils/vehiculeCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Vehicule> vehicules = Provider.of<List<Vehicule>>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Mes favories"),
        ),
        body: vehicules == null
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              )
            : vehicules.length == 0
                ? Center(
                    child: Text("Aucun favories"),
                  )
                : ListView.builder(
                    itemCount: vehicules.length,
                    itemBuilder: (ctx, i) {
                      final car = vehicules[i];
                      return i == vehicules.length - 1
                          ? Container(
                              child: VCard(car: car),
                              margin: EdgeInsets.only(bottom: 80),
                            )
                          : VCard(car: car);
                    },
                  ));
  }
}
