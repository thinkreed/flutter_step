import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Bar {
  Bar(this.height);

  final double height;

  static Bar lerp(Bar begin, Bar end, double t) {
    return new Bar(lerpDouble(begin.height, end.height, t));
  }
}

class BarTween extends Tween<Bar> {
  BarTween(Bar begin, Bar end) : super(begin: begin, end: end);

  @override
  Bar lerp(double t) => Bar.lerp(begin, end, t);
}

class BarChartPainter extends CustomPainter {
  static const barWidth = 10.0;

  BarChartPainter(Animation<Bar> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<Bar> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final bar = animation.value;
    final paint = new Paint()
      ..color = Colors.blue[400]
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      new Rect.fromLTWH(
        (size.width - barWidth) / 2.0,
        size.height - bar.height,
        barWidth,
        bar.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => new ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  final random = new Random();
  AnimationController animation;
  BarTween tween;

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    tween = new BarTween(new Bar(0.0), new Bar(50.0));
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      tween = new BarTween(
        tween.evaluate(animation),
        new Bar(100.0 * random.nextDouble()),
      );
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new CustomPaint(
          size: new Size(200.0, 100.0),
          painter: new BarChartPainter(tween.animate(animation)),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.refresh),
        onPressed: changeData,
      ),
    );
  }
}