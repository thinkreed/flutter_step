import 'package:flutter/material.dart';

class AlignColumnApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('images/pic1.jpg'),
              Image.asset('images/pic2.jpg'),
              Image.asset('images/pic3.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
