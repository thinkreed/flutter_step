import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ColorPalette {
  static final ColorPalette primary = new ColorPalette(<Color>[
    Colors.blue[400],
    Colors.red[400],
    Colors.green[400],
    Colors.yellow[400],
    Colors.purple[400],
    Colors.orange[400],
    Colors.teal[400],
  ]);

  ColorPalette(List<Color> colors) : _colors = colors {
    assert(colors.isNotEmpty);
  }

  final List<Color> _colors;

  Color operator [](int index) => _colors[index % length];

  int get length => _colors.length;

  Color random(Random random) => this[random.nextInt(length)];
}

class Bar {
  Bar(this.height, this.color);

  factory Bar.empty() => new Bar(0.0, Colors.transparent);

  factory Bar.random(Random random) {
    return new Bar(
      random.nextDouble() * 100.0,
      ColorPalette.primary.random(random),
    );
  }

  final double height;
  final Color color;

  static Bar lerp(Bar begin, Bar end, double t) {
    return new Bar(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
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
      ..color = bar.color
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
    tween = new BarTween(new Bar.empty(), new Bar.random(random));
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      tween = new BarTween(tween.evaluate(animation), new Bar.random(random));
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