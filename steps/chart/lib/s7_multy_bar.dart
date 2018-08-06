import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class BarChart {
  BarChart(this.bars);

  factory BarChart.empty(Size size) {
    return new BarChart(<Bar>[]);
  }

  factory BarChart.random(Size size, Random random) {
    const barWidthFraction = 0.75;
    const minBarDistance = 20.0;
    final barCount = random.nextInt((size.width / minBarDistance).floor()) + 1;
    final barDistance = size.width / (1 + barCount);
    final barWidth = barDistance * barWidthFraction;
    final startX = barDistance - barWidth / 2;
    final color = ColorPalette.primary.random(random);
    final bars = new List.generate(
      barCount,
      (i) => new Bar(
            startX + i * barDistance,
            barWidth,
            random.nextDouble() * size.height,
            color,
          ),
    );
    return new BarChart(bars);
  }

  final List<Bar> bars;

  static BarChart lerp(BarChart begin, BarChart end, double t) {
    final barCount = max(begin.bars.length, end.bars.length);
    final bars = new List.generate(
      barCount,
      (i) => Bar.lerp(
            begin._barOrNull(i) ?? end.bars[i].collapsed,
            end._barOrNull(i) ?? begin.bars[i].collapsed,
            t,
          ),
    );
    return new BarChart(bars);
  }

  Bar _barOrNull(int index) => (index < bars.length ? bars[index] : null);
}

class BarChartTween extends Tween<BarChart> {
  BarChartTween(BarChart begin, BarChart end) : super(begin: begin, end: end);

  @override
  BarChart lerp(double t) => BarChart.lerp(begin, end, t);
}

class Bar {
  Bar(this.x, this.width, this.height, this.color);

  final double x;
  final double width;
  final double height;
  final Color color;

  Bar get collapsed => new Bar(x, 0.0, 0.0, color);

  static Bar lerp(Bar begin, Bar end, double t) {
    return new Bar(
      lerpDouble(begin.x, end.x, t),
      lerpDouble(begin.width, end.width, t),
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
  BarChartPainter(Animation<BarChart> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<BarChart> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint()..style = PaintingStyle.fill;
    final chart = animation.value;
    for (final bar in chart.bars) {
      paint.color = bar.color;
      canvas.drawRect(
        new Rect.fromLTWH(
          bar.x,
          size.height - bar.height,
          bar.width,
          bar.height,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BarChartPainter old) => false;
}

class ChartPage extends StatefulWidget {
  @override
  ChartPageState createState() => new ChartPageState();
}

class ChartPageState extends State<ChartPage> with TickerProviderStateMixin {
  static const size = const Size(200.0, 100.0);
  final random = new Random();
  AnimationController animation;
  BarChartTween tween;

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    tween = new BarChartTween(
      new BarChart.empty(size),
      new BarChart.random(size, random),
    );
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeData() {
    setState(() {
      tween = new BarChartTween(
        tween.evaluate(animation),
        new BarChart.random(size, random),
      );
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new CustomPaint(
          size: size,
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