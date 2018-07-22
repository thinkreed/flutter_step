import 'package:flutter/material.dart';

import 'dart:convert';

class JsonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("gesture"),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
      };
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var stack = Stack(
      alignment: const Alignment(0.6, 0.6),
      children: <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('images/girl.jpg'),
          radius: 100.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black45,
          ),
          child: Text(
            'Mia B',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );

    void _handleTap() {
      var originUser = new User("thinkreed", "thinkreed2017@outlook.com");
      String json = JSON.encode(originUser);
      print("origin user is " + json);
      Map<String, dynamic> pairs = JSON.decode(json);
      var decodeUser = new User.fromJson(pairs);
      print(
          'from decode user name is ${decodeUser.name}, email is ${decodeUser.email}');
    }

    return Center(
      child: GestureDetector(
        onTap: _handleTap,
        child: stack,
      ),
    );
  }
}
