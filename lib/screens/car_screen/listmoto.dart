import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/car_screen/addMoto.dart';
import 'package:firebase_app/screens/car_screen/favories.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/vehiculeCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MotoList extends StatefulWidget {
  @override
  _MotoListState createState() => _MotoListState();
}

class _MotoListState extends State<MotoList> {
  @override
  Widget build(BuildContext context) {
    final List<Vehicule> motos = Provider.of<List<Vehicule>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste de Motos"),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.heart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => StreamProvider<List<Vehicule>>.value(
                      value: DBServices().getvehiculefav(CarType.moto),
                      child: Favories())));
            },
          )
        ],
      ),
      body: motos == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : motos.length == 0
              ? Center(
                  child: Text("Aucune moto"),
                )
              : ListView.builder(
                  itemCount: motos.length,
                  itemBuilder: (ctx, i) {
                    final car = motos[i];
                    return i == motos.length - 1
                        ? Container(
                            child: VCard(car: car),
                            margin: EdgeInsets.only(bottom: 80),
                          )
                        : VCard(car: car);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => AddMoto()));
        },
      ),
    );
  }
}
