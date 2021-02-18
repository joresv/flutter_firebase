import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/screens/home.dart';
import 'package:firebase_app/screens/login.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statut extends StatefulWidget {
  @override
  _StatutState createState() => _StatutState();
}

class _StatutState extends State<Statut> {
  AuthServices auth = AuthServices();
  User user;
  Future<void> getUser() async {
    final userResult = await auth.user;
    setState(() {
      user = userResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return user == null
        ? LoginPage()
        : StreamProvider<UserM>.value(
            value: DBServices().getCurrentUser,
            child: HomePage(),
          );
  }
}
