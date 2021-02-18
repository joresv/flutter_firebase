import 'package:firebase_app/model/user.dart';
import 'package:firebase_app/screens/admin/pub_list.dart';
import 'package:firebase_app/screens/admin/user_list.dart';
import 'package:firebase_app/services/db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Espace administrateur"),
            backgroundColor: Colors.red,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.folder)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamProvider<List<UserM>>.value(
                  value: DBServices().getAllUsers, child: UserListPage()),
              PubListPage()
            ],
          ),
        ));
  }
}
