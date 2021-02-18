import 'dart:io';
import 'package:firebase_app/model/vehicule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/model/user.dart';

class DBServices {
  final CollectionReference usercol =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference carouselcol =
      FirebaseFirestore.instance.collection("carousel");
  final CollectionReference vehiculecol =
      FirebaseFirestore.instance.collection("vehicule");

  Future saveUser(UserM user) async {
    try {
      await usercol.doc(user.id).set(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future getUser(String id) async {
    try {
      final data = await usercol.doc(id).get();
      final user = UserM.fromJson(data.data());
      return user;
    } catch (e) {
      return false;
    }
  }

  Future updateUser(UserM user) async {
    try {
      await usercol.doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<UserM> get getCurrentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user != null
        ? usercol.doc(user.uid).snapshots().map((user) {
            UserM.currentUser = UserM.fromJson(user.data());
            return UserM.fromJson(user.data());
          })
        : null;
  }

  Future<String> uploadImage(File file, {String path}) async {
    var time = DateTime.now().toString();
    var ext = Path.basename(file.path).split(".")[1].toString();
    String image = path + "_" + time + "." + ext;
    try {
      StorageReference ref =
          FirebaseStorage.instance.ref().child(path + "/" + image);
      StorageUploadTask upload = ref.putFile(file);
      await upload.onComplete;
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<List> get getCarouselImage async {
    try {
      final data = await carouselcol.doc("ZlhrUQtxlBN7KsbgfFpM").get();
      return data.data()["imgs"];
    } catch (e) {
      return null;
    }
  }

  Future savevehicule(Vehicule vehicule) async {
    try {
      await vehiculecol.doc().set(vehicule.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatevehicule(Vehicule vehicule) async {
    try {
      await vehiculecol.doc(vehicule.id).update(vehicule.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deletevehicule(String id) async {
    try {
      await vehiculecol.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Vehicule>> getvehicule({CarType type, String uid}) {
    return vehiculecol
        .where("type",
            isEqualTo: type == null
                ? null
                : type == CarType.car
                    ? "car"
                    : "moto")
        .where("uid", isEqualTo: uid)
        .snapshots()
        .map((vehicule) {
      return vehicule.docs
          .map((e) => Vehicule.fromJson(e.data(), id: e.id))
          .toList();
    });
  }

  Stream<List<Vehicule>> getvehiculefav(CarType type) {
    final user = FirebaseAuth.instance.currentUser;
    return vehiculecol
        .where("type", isEqualTo: type == CarType.car ? "car" : "moto")
        .where("favories", arrayContains: user.uid)
        .snapshots()
        .map((vehicule) {
      return vehicule.docs
          .map((e) => Vehicule.fromJson(e.data(), id: e.id))
          .toList();
    });
  }

  Stream<List<UserM>> get getAllUsers {
    return usercol.snapshots().map((users) {
      return users.docs.map((e) => UserM.fromJson(e.data())).toList();
    });
  }
}
