import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AgendaElementGenerated extends StatelessWidget {
  AgendaElementGenerated();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: AgendaElementPainter());
  }
}

class AgendaElementPainter extends CustomPainter {
  AgendaElementPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.transparent, BlendMode.screen);
    var frame = Offset.zero & size;
    canvas.translate(2078.0000000000, 1768.0000000000);

// 66:0 : AgendaElement (COMPONENT)
    var draw_66_0 = (Canvas canvas, Rect container) {
      var frame = Rect.fromLTWH(
          -2078.0000000000,
          -1768.0000000000,
          (container.width - (0.0)),
          (container.height -
              (0.0))) /* H:LEFT_RIGHT V:TOP_BOTTOM F:(l:-2078,t:-1768,r:2078,b:2078,w:319,h:176) */;
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
      canvas.drawRect(Offset.zero & frame.size,
          (Paint()..color = _ColorCatalog.instance.color_0));

// 65:6 : MaterialLesson (GROUP)
      var draw_65_6 = (Canvas canvas, Rect container) {
// 65:5 : Rectangle 59 (VECTOR)
        var draw_65_5 = (Canvas canvas, Rect container) {
          var frame = Rect.fromLTWH(0.0, 46.0000000000, 319.0000000000,
              130.0000000000) /* H:SCALE V:SCALE F:(l:0,t:46,r:0,b:0,w:319,h:130) */;
          canvas.save();
          canvas.scale((container.width) / 319.0000000000,
              (container.height) / 176.0000000000);
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
            (frame.width / 319.0000000000),
            0.0,
            0.0,
            0.0,
            0.0,
            (frame.height / 130.0000000000),
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
          var fillGeometry = [
            _PathCatalog.instance.path_0.transform(transform)
          ];
          fillGeometry.forEach((path) {
            var effectPaint = _EffectCatalog.instance.paint_0;
            canvas.save();
            canvas.translate(0.0, 4.0000000000);
            canvas.drawPath(path, effectPaint);
            canvas.restore();
          });
          fillGeometry.forEach((path) {
            canvas.drawPath(path, _PaintCatalog.instance.paint_0);
          });
          canvas.restore();
        };
        draw_65_5(canvas, frame);

// 65:4 : Rectangle 58 (VECTOR)
        var draw_65_4 = (Canvas canvas, Rect container) {
          var frame = Rect.fromLTWH(0.0, 23.0000000000, 319.0000000000,
              130.0000000000) /* H:SCALE V:SCALE F:(l:0,t:23,r:0,b:0,w:319,h:130) */;
          canvas.save();
          canvas.scale((container.width) / 319.0000000000,
              (container.height) / 176.0000000000);
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
            (frame.width / 319.0000000000),
            0.0,
            0.0,
            0.0,
            0.0,
            (frame.height / 130.0000000000),
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
          var fillGeometry = [
            _PathCatalog.instance.path_1.transform(transform)
          ];
          fillGeometry.forEach((path) {
            var effectPaint = _EffectCatalog.instance.paint_0;
            canvas.save();
            canvas.translate(0.0, 4.0000000000);
            canvas.drawPath(path, effectPaint);
            canvas.restore();
          });
          fillGeometry.forEach((path) {
            canvas.drawPath(path, _PaintCatalog.instance.paint_0);
          });
          canvas.restore();
        };
        draw_65_4(canvas, frame);

// 64:38 : Rectangle 56 (VECTOR)
        var draw_64_38 = (Canvas canvas, Rect container) {
          var frame = Rect.fromLTWH(0.0, 0.0, 319.0000000000,
              130.0000000000) /* H:SCALE V:SCALE F:(l:0,t:0,r:0,b:0,w:319,h:130) */;
          canvas.save();
          canvas.scale((container.width) / 319.0000000000,
              (container.height) / 176.0000000000);
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
            (frame.width / 319.0000000000),
            0.0,
            0.0,
            0.0,
            0.0,
            (frame.height / 130.0000000000),
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
          var fillGeometry = [
            _PathCatalog.instance.path_2.transform(transform)
          ];
          fillGeometry.forEach((path) {
            canvas.drawPath(path, _PaintCatalog.instance.paint_1);
          });
          canvas.restore();
        };
        draw_64_38(canvas, frame);

// 64:39 : Rectangle 57 (RECTANGLE)
        var draw_64_39 = (Canvas canvas, Rect container) {
          var frame = Rect.fromLTWH(0.0, 0.0, 319.0000000000,
              9.0000000000) /* H:SCALE V:SCALE F:(l:0,t:0,r:0,b:0,w:319,h:9) */;
          canvas.save();
          canvas.scale((container.width) / 319.0000000000,
              (container.height) / 176.0000000000);
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
            (frame.width / 319.0000000000),
            0.0,
            0.0,
            0.0,
            0.0,
            (frame.height / 9.0000000000),
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
          var fillGeometry = [
            (Path()
              ..addRect(Rect.fromLTWH(0.0, 0.0, frame.width, frame.height)))
          ];
          fillGeometry.forEach((path) {
            canvas.drawPath(path, _PaintCatalog.instance.paint_2);
          });
          canvas.restore();
        };
        draw_64_39(canvas, frame);
      };
      draw_65_6(canvas, frame);

// 65:13 : Rectangle 8 (VECTOR)
      var draw_65_13 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(82.2011718750, 155.0000000000, 54.7898368835,
            19.4599666595) /* H:SCALE V:SCALE F:(l:82.201171875,t:155,r:182.00899124145508,b:182.00899124145508,w:54.78983688354492,h:19.4599666595459) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
          (frame.width / 54.7898368835),
          0.0,
          0.0,
          0.0,
          0.0,
          (frame.height / 19.4599666595),
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
        var fillGeometry = [_PathCatalog.instance.path_3.transform(transform)];
        fillGeometry.forEach((path) {
          canvas.drawPath(path, _PaintCatalog.instance.paint_3);
        });
        canvas.restore();
      };
      draw_65_13(canvas, frame);

// 65:7 : 08h30 - 09h30 (TEXT)
      var draw_65_7 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(4.0000000000, 13.0000000000, 150.0000000000,
            28.0000000000) /* H:SCALE V:SCALE F:(l:4,t:13,r:165,b:165,w:150,h:28) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
        var style_0 = _TextStyleCatalog.instance.ui_TextStyle_0;
        var paragraphStyle = ui.ParagraphStyle(
          fontFamily: 'Asap',
          textAlign: TextAlign.left,
          fontSize: 24.0000000000,
          fontWeight: FontWeight.w400,
        );
        var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(style_0);
        paragraphBuilder.addText("08h30 - 09h30");
        var paragraph = paragraphBuilder.build();
        paragraph.layout(new ui.ParagraphConstraints(width: frame.width));
        canvas.drawParagraph(paragraph, Offset.zero);
        canvas.restore();
      };
      draw_65_7(canvas, frame);

// 65:8 : Mathématiques (TEXT)
      var draw_65_8 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(4.0000000000, 42.0000000000, 166.0000000000,
            28.0000000000) /* H:SCALE V:SCALE F:(l:4,t:42,r:149,b:149,w:166,h:28) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
        var style_0 = _TextStyleCatalog.instance.ui_TextStyle_1;
        var paragraphStyle = ui.ParagraphStyle(
          fontFamily: 'Asap',
          textAlign: TextAlign.left,
          fontSize: 24.0000000000,
          fontWeight: FontWeight.w600,
        );
        var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(style_0);
        paragraphBuilder.addText("Mathématiques");
        var paragraph = paragraphBuilder.build();
        paragraph.layout(new ui.ParagraphConstraints(width: frame.width));
        canvas.drawParagraph(paragraph, Offset.zero);
        canvas.restore();
      };
      draw_65_8(canvas, frame);

// 65:9 : Madame DESCARTES (TEXT)
      var draw_65_9 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(4.0000000000, 70.0000000000, 224.0000000000,
            28.0000000000) /* H:SCALE V:SCALE F:(l:4,t:70,r:91,b:91,w:224,h:28) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
        var style_0 = _TextStyleCatalog.instance.ui_TextStyle_1;
        var paragraphStyle = ui.ParagraphStyle(
          fontFamily: 'Asap',
          textAlign: TextAlign.left,
          fontSize: 24.0000000000,
          fontWeight: FontWeight.w600,
        );
        var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(style_0);
        paragraphBuilder.addText("Madame DESCARTES");
        var paragraph = paragraphBuilder.build();
        paragraph.layout(new ui.ParagraphConstraints(width: frame.width));
        canvas.drawParagraph(paragraph, Offset.zero);
        canvas.restore();
      };
      draw_65_9(canvas, frame);

// 65:16 : Rappel 1 (TEXT)
      var draw_65_16 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(4.0000000000, 134.0000000000, 51.0000000000,
            15.0000000000) /* H:SCALE V:SCALE F:(l:4,t:134,r:264,b:264,w:51,h:15) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
        var style_0 = _TextStyleCatalog.instance.ui_TextStyle_2;
        var paragraphStyle = ui.ParagraphStyle(
          fontFamily: 'Asap',
          textAlign: TextAlign.left,
          fontSize: 13.0000000000,
          fontWeight: FontWeight.w600,
        );
        var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(style_0);
        paragraphBuilder.addText("Rappel 1");
        var paragraph = paragraphBuilder.build();
        paragraph.layout(new ui.ParagraphConstraints(width: frame.width));
        canvas.drawParagraph(paragraph, Offset.zero);
        canvas.restore();
      };
      draw_65_16(canvas, frame);

// 65:17 : Evenement 2 (TEXT)
      var draw_65_17 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(4.0000000000, 157.0000000000, 75.0000000000,
            15.0000000000) /* H:SCALE V:SCALE F:(l:4,t:157,r:240,b:240,w:75,h:15) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
        var style_0 = _TextStyleCatalog.instance.ui_TextStyle_2;
        var paragraphStyle = ui.ParagraphStyle(
          fontFamily: 'Asap',
          textAlign: TextAlign.left,
          fontSize: 13.0000000000,
          fontWeight: FontWeight.w600,
        );
        var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(style_0);
        paragraphBuilder.addText("Evenement 2");
        var paragraph = paragraphBuilder.build();
        paragraph.layout(new ui.ParagraphConstraints(width: frame.width));
        canvas.drawParagraph(paragraph, Offset.zero);
        canvas.restore();
      };
      draw_65_17(canvas, frame);

// 65:20 : 08 : 55 (TEXT)
      var draw_65_20 = (Canvas canvas, Rect container) {
        var frame = Rect.fromLTWH(91.0000000000, 158.0000000000, 37.0000000000,
            15.0000000000) /* H:SCALE V:SCALE F:(l:91,t:158,r:191,b:191,w:37,h:15) */;
        canvas.save();
        canvas.scale((container.width) / 319.0000000000,
            (container.height) / 176.0000000000);
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
        var style_0 = _TextStyleCatalog.instance.ui_TextStyle_3;
        var paragraphStyle = ui.ParagraphStyle(
          fontFamily: 'Asap',
          textAlign: TextAlign.left,
          fontSize: 13.0000000000,
          fontWeight: FontWeight.w600,
        );
        var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(style_0);
        paragraphBuilder.addText("08 : 55");
        var paragraph = paragraphBuilder.build();
        paragraph.layout(new ui.ParagraphConstraints(width: frame.width));
        canvas.drawParagraph(paragraph, Offset.zero);
        canvas.restore();
      };
      draw_65_20(canvas, frame);
      canvas.restore();
    };
    draw_66_0(canvas, frame);
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) => [];
  }

  @override
  bool shouldRebuildSemantics(AgendaElementPainter oldDelegate) {
    return shouldRepaint(oldDelegate);
  }

  @override
  bool shouldRepaint(AgendaElementPainter oldDelegate) {
    return false;
  }
}

class _PathCatalog {
  _PathCatalog() {
    this.path_0 = _build_0();
    this.path_1 = _build_1();
    this.path_2 = _build_2();
    this.path_3 = _build_3();
  }

  Path path_0;

  Path path_1;

  Path path_2;

  Path path_3;

  static final _PathCatalog instance = _PathCatalog();

  static Path _build_0() {
    var path = Path();
    path.moveTo(0.0, 5.0000000000);
    path.cubicTo(0.0, 2.2385800000, 2.2385800000, 0.0, 5.0000000000, 0.0);
    path.lineTo(314.0000000000, 0.0);
    path.cubicTo(316.7610000000, 0.0, 319.0000000000, 2.2385800000,
        319.0000000000, 5.0000000000);
    path.lineTo(319.0000000000, 130.0000000000);
    path.lineTo(0.0, 130.0000000000);
    path.lineTo(0.0, 5.0000000000);
    path.close();
    return path;
  }

  static Path _build_1() {
    var path = Path();
    path.moveTo(0.0, 5.0000000000);
    path.cubicTo(0.0, 2.2385800000, 2.2385800000, 0.0, 5.0000000000, 0.0);
    path.lineTo(314.0000000000, 0.0);
    path.cubicTo(316.7610000000, 0.0, 319.0000000000, 2.2385800000,
        319.0000000000, 5.0000000000);
    path.lineTo(319.0000000000, 130.0000000000);
    path.lineTo(0.0, 130.0000000000);
    path.lineTo(0.0, 5.0000000000);
    path.close();
    return path;
  }

  static Path _build_2() {
    var path = Path();
    path.moveTo(0.0, 5.0000000000);
    path.cubicTo(0.0, 2.2385800000, 2.2385800000, 0.0, 5.0000000000, 0.0);
    path.lineTo(314.0000000000, 0.0);
    path.cubicTo(316.7610000000, 0.0, 319.0000000000, 2.2385800000,
        319.0000000000, 5.0000000000);
    path.lineTo(319.0000000000, 130.0000000000);
    path.lineTo(0.0, 130.0000000000);
    path.lineTo(0.0, 5.0000000000);
    path.close();
    return path;
  }

  static Path _build_3() {
    var path = Path();
    path.moveTo(0.0, 9.7299800000);
    path.cubicTo(0.0, 4.3562600000, 4.3037000000, 0.0, 9.6125800000, 0.0);
    path.lineTo(45.1773000000, 0.0);
    path.cubicTo(50.4861000000, 0.0, 54.7898000000, 4.3562600000, 54.7898000000,
        9.7299800000);
    path.cubicTo(54.7898000000, 15.1037000000, 50.4861000000, 19.4600000000,
        45.1773000000, 19.4600000000);
    path.lineTo(9.6125800000, 19.4600000000);
    path.cubicTo(
        4.3037000000, 19.4600000000, 0.0, 15.1037000000, 0.0, 9.7299800000);
    path.close();
    return path;
  }
}

class _PaintCatalog {
  _PaintCatalog() {
    this.paint_0 = (Paint()..color = _ColorCatalog.instance.color_2);
    this.paint_1 = (Paint()..color = _ColorCatalog.instance.color_3);
    this.paint_2 = (Paint()..color = _ColorCatalog.instance.color_4);
    this.paint_3 = (Paint()..color = _ColorCatalog.instance.color_5);
  }

  Paint paint_0;

  Paint paint_1;

  Paint paint_2;

  Paint paint_3;

  static final _PaintCatalog instance = _PaintCatalog();
}

class _EffectCatalog {
  _EffectCatalog() {
    this.paint_0 = (Paint()
      ..color = _ColorCatalog.instance.color_1
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, 4));
  }

  Paint paint_0;

  static final _EffectCatalog instance = _EffectCatalog();
}

class _ColorCatalog {
  _ColorCatalog() {
    this.color_0 = Color.fromARGB(0, 0, 0, 0);
    this.color_1 = Color.fromARGB(63, 0, 0, 0);
    this.color_2 = Color.fromARGB(255, 255, 255, 255);
    this.color_3 = Color.fromARGB(255, 98, 114, 198);
    this.color_4 = Color.fromARGB(255, 24, 42, 136);
    this.color_5 = Color.fromARGB(255, 140, 140, 140);
    this.color_6 = Color.fromARGB(255, 0, 0, 0);
  }

  Color color_0;

  Color color_1;

  Color color_2;

  Color color_3;

  Color color_4;

  Color color_5;

  Color color_6;

  static final _ColorCatalog instance = _ColorCatalog();
}

class _TextStyleCatalog {
  _TextStyleCatalog() {
    this.ui_TextStyle_0 = ui.TextStyle(
      fontFamily: 'Asap',
      color: _ColorCatalog.instance.color_6,
      fontSize: 24.0000000000,
      fontWeight: FontWeight.w400,
    );
    this.ui_TextStyle_1 = ui.TextStyle(
      fontFamily: 'Asap',
      color: _ColorCatalog.instance.color_6,
      fontSize: 24.0000000000,
      fontWeight: FontWeight.w600,
    );
    this.ui_TextStyle_2 = ui.TextStyle(
      fontFamily: 'Asap',
      color: _ColorCatalog.instance.color_6,
      fontSize: 13.0000000000,
      fontWeight: FontWeight.w600,
    );
    this.ui_TextStyle_3 = ui.TextStyle(
      fontFamily: 'Asap',
      color: _ColorCatalog.instance.color_2,
      fontSize: 13.0000000000,
      fontWeight: FontWeight.w600,
    );
  }

  ui.TextStyle ui_TextStyle_0;

  ui.TextStyle ui_TextStyle_1;

  ui.TextStyle ui_TextStyle_2;

  ui.TextStyle ui_TextStyle_3;

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
  bool operator ==(o) =>
      o is TextData && isVisible == o.isVisible && text == o.text;
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
