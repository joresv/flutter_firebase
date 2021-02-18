import 'package:firebase_app/services/auth.dart';
import 'package:firebase_app/utils/constant.dart';
import 'package:firebase_app/utils/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  AuthServices auth = AuthServices();
  String email, pass, cpass, pseu;
  final keys = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
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
                    Text(
                      "Sign Up",
                      style: style,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onChanged: (e) => pseu = e,
                      validator: (e) => e.isEmpty ? "Champ vide" : null,
                      decoration: InputDecoration(
                          hintText: "Entrer votre Pseudo", labelText: "Pseudo"),
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
                    TextFormField(
                      obscureText: true,
                      onChanged: (e) => cpass = e,
                      validator: (e) => e.isEmpty
                          ? "Champ vide"
                          : e.length < 6
                              ? "le password doit être plus de 6"
                              : null,
                      decoration: InputDecoration(
                          hintText: "*****************",
                          labelText: "Confirmation"),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        if (keys.currentState.validate()) {
                          loading(context);
                          print(email + "    " + pass);
                          bool register = await auth.signup(email, pass, pseu);
                          if (register != null) {
                            Navigator.of(context).pop();
                            if (register) Navigator.of(context).pop();
                          }
                        }
                      },
                      child: Text("Sign Up"),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
