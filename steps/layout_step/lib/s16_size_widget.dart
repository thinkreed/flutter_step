import 'package:flutter/material.dart';

class SizeWidgetApp extends StatelessWidget {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Image.asset('images/pic4.jpg'),
              ),
              Expanded(
                flex: 2,
                child: Image.asset('images/pic5.jpg'),
              ),
              Expanded(
                flex: 1,
                child: Image.asset('images/pic6.jpg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
