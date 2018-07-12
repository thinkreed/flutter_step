import 'package:flutter/material.dart';

class AlignRowApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset('images/pic4.jpg'),
              Image.asset('images/pic5.jpg'),
              Image.asset('images/pic6.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}
