import 'package:firebase_app/screens/register.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthServices auth = AuthServices();
  String email, pass;
  final keys = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: keys,
            child: Column(
              children: [
                Text("Login", style: style),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (e) => email = e,
                  validator: (e) => e.isEmpty ? "Champ vide" : null,
                  decoration: InputDecoration(
                      hintText: "Entrer votre email", labelText: "Email"),
                ),
                TextFormField(
                  obscureText: true,
                  onChanged: (e) => pass = e,
                  validator: (e) => e.isEmpty
                      ? "Champ vide"
                      : e.length < 6
                          ? "le password doit être plus de 6"
                          : null,
                  decoration: InputDecoration(
                      hintText: "*****************", labelText: "Password"),
                ),
                SizedBox(
                  height: 10,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (keys.currentState.validate()) {
                      loading(context);
                      print(email + "    " + pass);
                      bool login = await auth.signin(email, pass);
                      if (login != null) {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                        if (!login) print("email ou mot de passe incorrect");
                      }
                    }
                  },
                  child: Text("Sign In"),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.redAccent,
                      onPressed: () async {
                        loading(context);
                        bool googleSignIn = await auth.googleSignIn();
                        if (googleSignIn != null) Navigator.of(context).pop();
                      },
                      label: Text(
                        "Google",
                        style:
                            style.copyWith(fontSize: 18, color: Colors.white),
                      ),
                      icon: Icon(FontAwesomeIcons.google,
                          size: 20, color: Colors.white),
                    ),
                    Container(
                      width: 15,
                    ),
                    FlatButton.icon(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.blueAccent,
                      onPressed: () async {},
                      label: Text(
                        "Google",
                        style:
                            style.copyWith(fontSize: 18, color: Colors.white),
                      ),
                      icon: Icon(FontAwesomeIcons.facebookF,
                          size: 20, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Avez-vous un compte ?"),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (ctx) => Register()));
                        },
                        child: Text("register"))
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
