import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_app/screens/car_screen/addCar.dart';
import 'package:firebase_app/screens/car_screen/carDetails.dart';
import 'package:firebase_app/screens/car_screen/updateCar.dart';
import 'package:firebase_app/screens/car_screen/updateMoto.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VCard extends StatelessWidget {
  Vehicule car;
  CarType type;
  Color likeColor = Colors.grey;
  Color dislikeColor = Colors.grey;
  Icon favIcon = Icon(
    FontAwesomeIcons.heart,
    size: 20,
  );
  VCard({this.car, this.type = CarType.car});
  @override
  Widget build(BuildContext context) {
    bool iscar = car.type == CarType.car ? true : false;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Color themeColor =
        car.type == CarType.car ? Colors.green : Colors.lightBlue;
    final user = FirebaseAuth.instance.currentUser;
    if (car.like.contains(user.uid)) {
      likeColor = Colors.lightBlue;
      dislikeColor = Colors.grey;
    } else if (car.dislike.contains(user.uid)) {
      dislikeColor = Colors.red;
      likeColor = Colors.grey;
    } else {
      dislikeColor = Colors.grey;
      likeColor = Colors.grey;
    }

    if (car.favories.contains(user.uid))
      favIcon = Icon(
        FontAwesomeIcons.solidHeart,
        size: 20,
        color: Colors.red,
      );
    else
      favIcon = Icon(
        FontAwesomeIcons.heart,
        size: 20,
        color: themeColor,
      );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => CarDetail(
                    v: car,
                  )));
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: car.type == CarType.car
                      ? Colors.green
                      : Colors.lightBlue),
              borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Container(
                height: height / 4.2,
                width: width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(car.images.first))),
                child: Container(
                  alignment: Alignment.topRight,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    color: Colors.white,
                    child: IconButton(
                      icon: favIcon,
                      onPressed: () async {
                        if (car.favories.contains(user.uid))
                          car.favories.remove(user.uid);
                        else
                          car.favories.add(user.uid);
                        await DBServices().updatevehicule(car);
                      },
                    ),
                  ),
                ),
                // child: ,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(car.marque,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      height: 1)),
                              Text(car.modele),
                              Text(car.detailSup),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.solidThumbsUp,
                                color: likeColor,
                                size: 20,
                              ),
                              onPressed: () async {
                                if (car.like.contains(user.uid)) {
                                  car.like.remove(user.uid);
                                } else if (car.dislike.contains(user.uid)) {
                                  car.dislike.remove(user.uid);
                                  car.like.add(user.uid);
                                } else {
                                  car.like.add(user.uid);
                                }
                                await DBServices().updatevehicule(car);
                              },
                            ),
                            Text(car.like.length.toString()),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.solidThumbsDown,
                                color: dislikeColor,
                                size: 20,
                              ),
                              onPressed: () async {
                                if (car.dislike.contains(user.uid)) {
                                  car.dislike.remove(user.uid);
                                } else if (car.like.contains(user.uid)) {
                                  car.like.remove(user.uid);
                                  car.dislike.add(user.uid);
                                } else {
                                  car.dislike.add(user.uid);
                                }
                                await DBServices().updatevehicule(car);
                              },
                            ),
                            Text(car.dislike.length.toString()),
                          ],
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            mydialog(context,
                                title: "Suppression",
                                content: "Voulez-vous supprimer " + car.marque,
                                ok: () async {
                              Navigator.of(context).pop();
                              loading(context);
                              bool delete =
                                  await DBServices().deletevehicule(car.id);
                              if (delete != null) {
                                Navigator.of(context).pop();
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: themeColor),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => iscar
                                    ? UpdateCar(v: car)
                                    : UpdateMoto(
                                        v: car,
                                      )));
                          },
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// child: ListTile(
//   onTap: () {
// Navigator.of(context).push(MaterialPageRoute(
//     builder: (ctx) => CarDetail(
//           v: car,
//         )));
//   },
//   subtitle: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(car.modele),
// Row(
//   children: [
//     IconButton(
//       icon: Icon(
//         FontAwesomeIcons.solidThumbsUp,
//         color: likeColor,
//         size: 20,
//       ),
//       onPressed: () async {
//         if (car.like.contains(user.uid)) {
//           car.like.remove(user.uid);
//         } else if (car.dislike.contains(user.uid)) {
//           car.dislike.remove(user.uid);
//           car.like.add(user.uid);
//         } else {
//           car.like.add(user.uid);
//         }
//         await DBServices().updatevehicule(car);
//       },
//     ),
//     Text(car.like.length.toString()),
//     IconButton(
//       icon: Icon(
//         FontAwesomeIcons.solidThumbsDown,
//         color: dislikeColor,
//         size: 20,
//       ),
//       onPressed: () async {
//         if (car.dislike.contains(user.uid)) {
//           car.dislike.remove(user.uid);
//         } else if (car.like.contains(user.uid)) {
//           car.like.remove(user.uid);
//           car.dislike.add(user.uid);
//         } else {
//           car.dislike.add(user.uid);
//         }
//         await DBServices().updatevehicule(car);
//       },
//     ),
//     Text(car.dislike.length.toString()),
//   ],
// )
//   ],
// ),
//   leading: Container(
//     child: Image(
//       height: 50,
//       width: 50,
//       image: NetworkImage(car.images.first),
//     ),
//   ),
// trailing: car.uid == FirebaseAuth.instance.currentUser.uid
//     ? Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: Icon(
//               Icons.delete,
//               color: Colors.red,
//             ),
//             onPressed: () {
//               mydialog(context,
//                   title: "Suppression",
//                   content: "Voulez-vous supprimer " + car.marque,
//                   ok: () async {
//                 Navigator.of(context).pop();
//                 loading(context);
//                 bool delete =
//                     await DBServices().deletevehicule(car.id);
//                 if (delete != null) {
//                   Navigator.of(context).pop();
//                 }
//               });
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.edit, color: themeColor),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                   builder: (ctx) => iscar
//                       ? UpdateCar(v: car)
//                       : UpdateMoto(
//                           v: car,
//                         )));
//             },
//           )
//         ],
//       )
//       : null,
//   title: Text(car.marque),
// ),
