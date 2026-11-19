import 'package:flutter/material.dart';

/// Button with premium left-to-right shimmer animation
/// Respects MediaQuery.disableAnimations for reduced-motion support
class ShimmerWorkoutButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ShimmerWorkoutButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<ShimmerWorkoutButton> createState() => _ShimmerWorkoutButtonState();
}

class _ShimmerWorkoutButtonState extends State<ShimmerWorkoutButton>
    with TickerProviderStateMixin {
  late AnimationController _innerShimmerController;
  late AnimationController _borderShimmerController;
  late Animation<double> _innerShimmerAnimation;
  late Animation<double> _borderShimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    // Inner shimmer: 2.5s sweep + 1.5s pause = 4s total
    _innerShimmerController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _innerShimmerAnimation = Tween<double>(begin: -0.4, end: 1.4).animate(
      CurvedAnimation(
        parent: _innerShimmerController,
        curve: const Interval(0.0, 0.625, curve: Curves.easeInOut), // 2.5s of 4s
      ),
    );

    // Border shimmer: 4s continuous loop around the border
    _borderShimmerController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _borderShimmerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _borderShimmerController,
        curve: Curves.linear,
      ),
    );

    if (widget.onPressed != null) {
      _innerShimmerController.repeat();
      _borderShimmerController.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerWorkoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onPressed == null && oldWidget.onPressed != null) {
      _innerShimmerController.stop();
      _borderShimmerController.stop();
    } else if (widget.onPressed != null && oldWidget.onPressed == null) {
      _innerShimmerController.repeat();
      _borderShimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _innerShimmerController.dispose();
    _borderShimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final backgroundColor = widget.backgroundColor ?? const Color(0xFFFF6B00);
    final foregroundColor = widget.foregroundColor ?? Colors.white;

    // Fallback: no animation
    if (disableAnimations || widget.onPressed == null) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: widget.onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100), // Pill shape
            ),
          ),
          child: widget.child,
        ),
      );
    }

    // Animated shimmer version
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: SizedBox(
          width: double.infinity,
          height: 52, // Match typical button height
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100), // Pill shape
            child: Stack(
              children: [
                // Solid orange base
                Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                // Border shimmer
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _borderShimmerAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _BorderShimmerPainter(
                          progress: _borderShimmerAnimation.value,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      );
                    },
                  ),
                ),
                // Inner shimmer overlay
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _innerShimmerAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              (_innerShimmerAnimation.value - 0.2).clamp(0.0, 1.0),
                              (_innerShimmerAnimation.value - 0.1).clamp(0.0, 1.0),
                              _innerShimmerAnimation.value.clamp(0.0, 1.0),
                              (_innerShimmerAnimation.value + 0.1).clamp(0.0, 1.0),
                              (_innerShimmerAnimation.value + 0.2).clamp(0.0, 1.0),
                            ],
                            colors: const [
                              Colors.transparent,
                              Color(0x20FFFFFF),
                              Color(0x60FFFFFF),
                              Color(0x20FFFFFF),
                              Colors.transparent,
                            ],
                            transform: const GradientRotation(-0.15),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // White content (icon + text)
                Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: foregroundColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    child: IconTheme(
                      data: IconThemeData(
                        color: foregroundColor,
                        size: 24,
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for border shimmer effect
class _BorderShimmerPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;

  _BorderShimmerPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    final path = Path()..addRRect(rrect);

    final pathMetrics = path.computeMetrics().first;
    final totalLength = pathMetrics.length;

    // Shimmer segment: 15% of perimeter
    final segmentLength = totalLength * 0.15;
    final currentPos = totalLength * progress;

    // Extract shimmer segment
    final start = (currentPos - segmentLength / 2).clamp(0.0, totalLength);
    final end = (currentPos + segmentLength / 2).clamp(0.0, totalLength);

    if (end > start) {
      final segment = pathMetrics.extractPath(start, end);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(segment, paint);
    }
  }

  @override
  bool shouldRepaint(_BorderShimmerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
