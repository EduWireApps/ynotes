import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Thing extends StatelessWidget {
  Thing();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: ThingPainter());
  }
}

class ThingPainter extends CustomPainter {
  ThingPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.transparent, BlendMode.screen);
    var frame = Offset.zero & size;
    canvas.translate(-100.0000000000, -28.0000000000);

// 821:63 : Thing (COMPONENT)
    var draw_821_63 = (Canvas canvas, Rect container) {
      var frame = Rect.fromLTWH(100.0000000000, 28.0000000000, (container.width - (0.0)),
          (container.height - (0.0))) /* H:LEFT_RIGHT V:TOP_BOTTOM F:(l:100,t:28,r:-100,b:-100,w:51,h:169) */;
      canvas.save();
      canvas.transform(Float64List.fromList([
        1.0000000000,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0000000000,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
        frame.left,
        frame.top,
        0.0,
        1.0
      ]));
      canvas.drawRect(Offset.zero & frame.size, (Paint()..color = _ColorCatalog.instance.color_0));

// 820:68 : Subtract (BOOLEAN_OPERATION)
      var draw_820_68 = (Canvas canvas, Rect container) {
        var frame =
            Rect.fromLTWH(0.0, 0.0, 51.0000000000, 169.0000000000) /* H:SCALE V:SCALE F:(l:0,t:0,r:0,b:0,w:51,h:169) */;
        canvas.save();
        canvas.scale((container.width) / 51.0000000000, (container.height) / 169.0000000000);
        canvas.transform(Float64List.fromList([
          1.0000000000,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0000000000,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          frame.left,
          frame.top,
          0.0,
          1.0
        ]));
        var transform = Float64List.fromList([
          (frame.width / 51.0000000000),
          0.0,
          0.0,
          0.0,
          0.0,
          (frame.height / 169.0000000000),
          0.0,
          0.0,
          0.0,
          0.0,
          1.0,
          0.0,
          0.0,
          0.0,
          0.0,
          1.0
        ]);
        var fillGeometry = [_PathCatalog.instance.path_0.transform(transform)];
        fillGeometry.forEach((path) {
          canvas.drawPath(path, _PaintCatalog.instance.paint_0);
        });
        canvas.restore();
      };
      draw_820_68(canvas, frame);
      canvas.restore();
    };
    draw_821_63(canvas, frame);
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) => [];
  }

  @override
  bool shouldRebuildSemantics(ThingPainter oldDelegate) {
    return shouldRepaint(oldDelegate);
  }

  @override
  bool shouldRepaint(ThingPainter oldDelegate) {
    return false;
  }
}

class _PathCatalog {
  _PathCatalog() {
    this.path_0 = _build_0();
  }

  Path path_0;

  static final _PathCatalog instance = _PathCatalog();

  static Path _build_0() {
    var path = Path();
    path.moveTo(23.0000000000, 0.0);
    path.cubicTo(10.2975000000, 0.0, 0.0, 10.2975000000, 0.0, 23.0000000000);
    path.lineTo(0.0, 146.0000000000);
    path.cubicTo(0.0, 158.7030000000, 10.2975000000, 169.0000000000, 23.0000000000, 169.0000000000);
    path.lineTo(51.0000000000, 169.0000000000);
    path.cubicTo(39.9543000000, 169.0000000000, 31.0000000000, 160.0460000000, 31.0000000000, 149.0000000000);
    path.lineTo(31.0000000000, 20.0000000000);
    path.cubicTo(31.0000000000, 8.9543000000, 39.9543000000, 0.0, 51.0000000000, 0.0);
    path.lineTo(23.0000000000, 0.0);
    path.close();
    return path;
  }
}

class _PaintCatalog {
  _PaintCatalog() {
    this.paint_0 = (Paint()..color = _ColorCatalog.instance.color_1);
  }

  Paint paint_0;

  static final _PaintCatalog instance = _PaintCatalog();
}

class _EffectCatalog {
  _EffectCatalog() {}

  static final _EffectCatalog instance = _EffectCatalog();
}

class _ColorCatalog {
  _ColorCatalog() {
    this.color_0 = Color.fromARGB(0, 0, 0, 0);
    this.color_1 = Color.fromARGB(255, 255, 119, 21);
  }

  Color color_0;

  Color color_1;

  static final _ColorCatalog instance = _ColorCatalog();
}

class _TextStyleCatalog {
  _TextStyleCatalog() {}

  static final _TextStyleCatalog instance = _TextStyleCatalog();
}

class Data {
  Data({this.isVisible});

  final bool isVisible;

  @override
  bool operator ==(o) => o is Data && isVisible == o.isVisible;
  @override
  int get hashcode {
    int result = 17;
    result = 37 * result + (this.isVisible?.hashCode ?? 0);
    return result;
  }
}

class TextData extends Data {
  TextData({isVisible, this.text}) : super(isVisible: isVisible);

  final String text;

  @override
  bool operator ==(o) => o is TextData && isVisible == o.isVisible && text == o.text;
  @override
  int get hashcode {
    int result = 17;
    result = 37 * result + (this.isVisible?.hashCode ?? 0);
    result = 37 * result + (this.text?.hashCode ?? 0);
    return result;
  }
}

class VectorData extends Data {
  VectorData({isVisible}) : super(isVisible: isVisible);

  @override
  bool operator ==(o) => o is VectorData && isVisible == o.isVisible;
  @override
  int get hashcode {
    int result = 17;
    result = 37 * result + (this.isVisible?.hashCode ?? 0);
    return result;
  }
}
