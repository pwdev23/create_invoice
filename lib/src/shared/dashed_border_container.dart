import 'package:flutter/material.dart';
import 'dart:ui';

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double left = 0;
    final double top = 0;
    final double right = size.width;
    final double bottom = size.height;

    // Define the start and end points for each side
    _drawDashedLine(canvas, paint, Offset(left + borderRadius, top),
        Offset(right - borderRadius, top)); // Top
    _drawDashedLine(canvas, paint, Offset(right, top + borderRadius),
        Offset(right, bottom - borderRadius)); // Right
    _drawDashedLine(canvas, paint, Offset(right - borderRadius, bottom),
        Offset(left + borderRadius, bottom)); // Bottom
    _drawDashedLine(canvas, paint, Offset(left, bottom - borderRadius),
        Offset(left, top + borderRadius)); // Left

    // Draw rounded corners
    _drawCornerDashes(canvas, paint, size);
  }

  void _drawDashedLine(Canvas canvas, Paint paint, Offset start, Offset end) {
    double totalLength = (end - start).distance;
    double dashPatternLength = dashWidth + dashSpace;
    int dashCount = (totalLength / dashPatternLength).floor();
    double adjustedDashWidth = (totalLength / dashCount) - dashSpace;

    double dx = (end.dx - start.dx) / totalLength;
    double dy = (end.dy - start.dy) / totalLength;

    double currentX = start.dx;
    double currentY = start.dy;

    for (int i = 0; i < dashCount; i++) {
      Offset dashStart = Offset(currentX, currentY);
      Offset dashEnd = Offset(
          currentX + dx * adjustedDashWidth, currentY + dy * adjustedDashWidth);
      canvas.drawLine(dashStart, dashEnd, paint);
      currentX += dx * (adjustedDashWidth + dashSpace);
      currentY += dy * (adjustedDashWidth + dashSpace);
    }
  }

  void _drawCornerDashes(Canvas canvas, Paint paint, Size size) {
    double arcLength =
        borderRadius * 1.57; // Approximate length of 90-degree curve (π/2)
    double dashPatternLength = dashWidth + dashSpace;
    int dashCount = (arcLength / dashPatternLength).floor();
    double adjustedDashWidth = (arcLength / dashCount) - dashSpace;

    // Corner positions
    Offset topLeft = Offset(borderRadius, borderRadius);
    Offset topRight = Offset(size.width - borderRadius, borderRadius);
    Offset bottomRight =
        Offset(size.width - borderRadius, size.height - borderRadius);
    Offset bottomLeft = Offset(borderRadius, size.height - borderRadius);

    _drawArcDashes(
        canvas, paint, topLeft, 180, 270, adjustedDashWidth); // Top-left
    _drawArcDashes(
        canvas, paint, topRight, 270, 360, adjustedDashWidth); // Top-right
    _drawArcDashes(
        canvas, paint, bottomRight, 0, 90, adjustedDashWidth); // Bottom-right
    _drawArcDashes(
        canvas, paint, bottomLeft, 90, 180, adjustedDashWidth); // Bottom-left
  }

  void _drawArcDashes(Canvas canvas, Paint paint, Offset center,
      double startAngle, double endAngle, double dashSize) {
    final Path path = Path();
    path.addArc(
        Rect.fromCircle(center: center, radius: borderRadius),
        startAngle * 3.141592653589793 / 180,
        (endAngle - startAngle) * 3.141592653589793 / 180);

    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        Path dashPath = metric.extractPath(distance, distance + dashSize);
        canvas.drawPath(dashPath, paint);
        distance += dashSize + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashedBorderContainer extends StatelessWidget {
  const DashedBorderContainer({
    super.key,
    this.color = Colors.black,
    this.borderRadius = 12.0,
    this.strokeWidth = 2.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.child,
  });

  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
