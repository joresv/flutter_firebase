import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/car_screen/addCar.dart';
import 'package:firebase_app/screens/car_screen/favories.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/vehiculeCard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CarLis extends StatefulWidget {
  @override
  _CarLisState createState() => _CarLisState();
}

class _CarLisState extends State<CarLis> {
  @override
  Widget build(BuildContext context) {
    final List<Vehicule> cars = Provider.of<List<Vehicule>>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste de Voitures"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.heart),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => StreamProvider<List<Vehicule>>.value(
                      value: DBServices().getvehiculefav(CarType.car),
                      child: Favories())));
            },
          )
        ],
      ),
      body: cars == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : cars.length == 0
              ? Center(
                  child: Text("Aucune voitures"),
                )
              : ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (ctx, i) {
                    final car = cars[i];
                    return i == cars.length - 1
                        ? Container(
                            child: VCard(car: car),
                            margin: EdgeInsets.only(bottom: 80),
                          )
                        : VCard(car: car);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => AddCar()));
        },
      ),
    );
  }
}
