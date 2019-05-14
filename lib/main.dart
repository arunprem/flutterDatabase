import 'package:database_intro/util/database_helper.dart';
import 'package:flutter/material.dart';

import 'Models/user.dart';

List _users;

void main() async {
  var db = new DatabaseHelper();

  //add user

  // int SavedUser = await db.saveUser(new User("Prem", "PCC"));
  // print("UserSaved: $SavedUser");

  User updateData = User.fromMap(
      {"username": "UpdateArun", "password": "UpdatedPassword", "id": 6});

  await db.updateUser(updateData);

  _users = await db.getAllUsers();
  //print(_users);

  for (int i = 0; i < _users.length; i++) {
    User user = User.map(_users[i]);
    print("username:${user.username},User Id:${user.id}");
  }

  int count = await db.getCount();
  print(count);

  var getuser = await db.getuser(13);
  print("${getuser.username}");

  var deleteUser = await db.deleteUser(14);
  print("$deleteUser");

  runApp(new MaterialApp(
    title: "Database",
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("Database"),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
      ),
      body: new ListView.builder(
          itemCount: _users.length,
          itemBuilder: (_, int position) {
            return new Card(
              color: Colors.white,
              elevation: 2.0,
              child: new ListTile(
                leading: new CircleAvatar(
                  child: new Text("${User.fromMap(_users[position]).id}"),
                ),
                title:
                    new Text("User:${User.fromMap(_users[position]).username}"),
                subtitle: new Text("Id:${User.fromMap(_users[position]).id}"),
                onTap: () =>
                    debugPrint("${User.fromMap(_users[position]).password}"),
              ),
            );
          }),
    );
  }
}
