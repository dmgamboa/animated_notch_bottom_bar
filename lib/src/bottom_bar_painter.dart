library rolling_bottom_bar;

import 'package:flutter/material.dart';

import 'constants/constants.dart';

class BottomBarPainter extends CustomPainter {
  BottomBarPainter({
    required this.position,
    required this.color,
    required this.showShadow,
    required this.notchColor,
    double? topRadius,
    double? bottomRadius,
  })  : _paint = Paint()
          ..color = color
          ..isAntiAlias = true,
        _shadowColor = Colors.grey.shade600,
        _notchPaint = Paint()
          ..color = notchColor
          ..isAntiAlias = true,
        this.topRadius = topRadius ?? kTopRadius,
        this.bottomRadius = bottomRadius ?? kBottomRadius;

  final double position;
  final Color color;
  final Paint _paint;
  final Color _shadowColor;
  final bool showShadow;
  final Paint _notchPaint;
  final Color notchColor;
  final double topRadius;
  final double bottomRadius;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBar(canvas, size);
    _drawFloatingCircle(canvas);
  }

  @override
  bool shouldRepaint(BottomBarPainter oldDelegate) {
    return position != oldDelegate.position || color != oldDelegate.color;
  }

  void _drawBar(Canvas canvas, Size size) {
    final left = kMargin;
    final right = size.width - kMargin;
    final top = kMargin;
    final bottom = top + kHeight;

    final path = Path()
      ..moveTo(left + kTopRadius, top)
      ..lineTo(position - kTopRadius, top)
      ..relativeArcToPoint(
        Offset(topRadius, topRadius),
        radius: Radius.circular(topRadius),
      )
      ..relativeArcToPoint(
        Offset((kCircleRadius + kCircleMargin) * 2, 0.0),
        radius: Radius.circular(kCircleRadius + kCircleMargin),
        clockwise: false,
      )
      ..relativeArcToPoint(
        Offset(topRadius, -topRadius),
        radius: Radius.circular(topRadius),
      )
      ..lineTo(right - kTopRadius, top)
      ..relativeArcToPoint(
        Offset(kTopRadius, topRadius),
        radius: Radius.circular(topRadius),
      )
      ..lineTo(right, bottom - bottomRadius)
      ..relativeArcToPoint(
        Offset(-bottomRadius, bottomRadius),
        radius: Radius.circular(bottomRadius),
      )
      ..lineTo(left + bottomRadius, bottom)
      ..relativeArcToPoint(
        Offset(-bottomRadius, -bottomRadius),
        radius: Radius.circular(bottomRadius),
      )
      ..lineTo(left, top + topRadius)
      ..relativeArcToPoint(
        Offset(topRadius, -topRadius),
        radius: Radius.circular(topRadius),
      );

    if (showShadow) {
      canvas.drawShadow(path, _shadowColor, 5.0, true);
    }

    canvas.drawPath(path, _paint);
  }

  void _drawFloatingCircle(Canvas canvas) {
    final path = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(
            position + kCircleMargin + kCircleRadius,
            kMargin + kCircleMargin,
          ),
          radius: kCircleRadius,
        ),
        0,
        kPi * 2,
      );

    if (showShadow) {
      canvas.drawShadow(path, _shadowColor, 5.0, true);
    }

    canvas.drawPath(path, _notchPaint);
  }
}
