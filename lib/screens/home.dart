import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/admin/admin.dart';
import 'package:firebase_app/screens/car_screen/addCar.dart';
import 'package:firebase_app/screens/car_screen/addMoto.dart';
import 'package:firebase_app/screens/car_screen/listcar.dart';
import 'package:firebase_app/screens/car_screen/listmoto.dart';
import 'package:firebase_app/screens/menu.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AuthServices auth = AuthServices();
  final key = GlobalKey<ScaffoldState>();
  Animation<double> _animation;
  List imgs;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(microseconds: 250));
    final curve =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curve);
  }

  get getCarouselImage async {
    final img = await DBServices().getCarouselImage;
    setState(() {
      imgs = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userm = Provider.of<UserM>(context);
    UserM.currentUser = userm;
    getCarouselImage;
    return Scaffold(
      key: key,
      drawer: Menu(),
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          if (userm != null)
            InkWell(
              onTap: () {
                key.currentState.openDrawer();
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        userm.image != null ? NetworkImage(userm.image) : null,
                    child: userm.image != null
                        ? Container()
                        : Icon(Icons.person, color: Colors.black),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(userm.pseudo),
                ],
              ),
            ),
          IconButton(
              icon: Icon(
                FontAwesomeIcons.powerOff,
                size: 20,
              ),
              onPressed: () async {
                await mydialog(context, ok: () async {
                  await auth.signOut();
                  setState(() {});
                  Navigator.of(context).pop();
                },
                    title: "Deconnexion",
                    content: "Voulez-vous vous déconnecter?");
              })
        ],
      ),
      body: Column(
        children: [
          Sliders(imgs: imgs),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lightBlue),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (userm != null) {
                      if (userm.enable) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) =>
                                StreamProvider<List<Vehicule>>.value(
                                  value: DBServices()
                                      .getvehicule(type: CarType.car),
                                  child: CarLis(),
                                )));
                      } else {
                        messages("Votre compte a été bloqué");
                      }
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.green,
                    child: Icon(FontAwesomeIcons.carAlt,
                        size: 50, color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => StreamProvider<List<Vehicule>>.value(
                          value: DBServices().getvehicule(type: CarType.moto),
                          child: MotoList(),
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.lightBlue,
                    child: Icon(FontAwesomeIcons.motorcycle,
                        size: 50, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionBubble(
        backGroundColor: Colors.lightBlue,
        items: [
          if (userm != null)
            if (userm.admin)
              Bubble(
                  title: "Espace admin",
                  titleStyle: style.copyWith(fontSize: 16, color: Colors.white),
                  iconColor: Colors.white,
                  bubbleColor: Colors.red,
                  icon: FontAwesomeIcons.userAlt,
                  onPress: () {
                    _animationController.reverse();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => AdminPage()));
                  }),
          Bubble(
              title: "Voiture",
              titleStyle: style.copyWith(fontSize: 16, color: Colors.white),
              iconColor: Colors.white,
              bubbleColor: Colors.green,
              icon: FontAwesomeIcons.carAlt,
              onPress: () {
                _animationController.reverse();
                if (userm != null) {
                  if (userm.enable) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => AddCar()));
                  } else {
                    messages("Votre compte a été bloqué");
                  }
                }
              }),
          Bubble(
              title: "Moto",
              titleStyle: style.copyWith(fontSize: 16, color: Colors.white),
              iconColor: Colors.white,
              bubbleColor: Colors.lightBlue,
              icon: FontAwesomeIcons.motorcycle,
              onPress: () {
                _animationController.reverse();
                if (userm != null) {
                  if (userm.enable) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => AddMoto()));
                  } else {
                    messages("Votre compte a été bloqué");
                  }
                }
              })
        ],
        onPress: _animationController.isCompleted
            ? _animationController.reverse
            : _animationController.forward,
        animation: _animation,
        iconColor: Colors.white,
        animatedIconData: AnimatedIcons.add_event,
      ),
    );
  }
}
