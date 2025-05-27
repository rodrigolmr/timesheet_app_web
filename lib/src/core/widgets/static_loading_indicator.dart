import 'package:flutter/material.dart';

class StaticLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const StaticLoadingIndicator({
    super.key,
    this.size = 48.0,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: indicatorColor.withOpacity(0.2),
              width: 4.0,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Static arc segment
              CustomPaint(
                size: Size(size, size),
                painter: _StaticArcPainter(
                  color: indicatorColor,
                  strokeWidth: 4.0,
                ),
              ),
              // Center dot
              Container(
                width: 8.0,
                height: 8.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: indicatorColor,
                ),
              ),
            ],
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: indicatorColor,
            ),
          ),
        ],
      ],
    );
  }
}

class _StaticArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _StaticArcPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw a 90-degree arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.57, // Start at top (-π/2)
      1.57, // Sweep 90 degrees (π/2)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class StaticLoadingOverlay extends StatelessWidget {
  final bool isVisible;
  final String? message;
  final Widget child;

  const StaticLoadingOverlay({
    super.key,
    required this.isVisible,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isVisible)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: StaticLoadingIndicator(
                      message: message,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}