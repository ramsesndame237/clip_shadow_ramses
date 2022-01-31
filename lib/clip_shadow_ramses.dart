library clip_shadow_ramses;

import 'package:flutter/widgets.dart';


/// A flutter clipshadownpainter.
class _ClipShadowPainter extends CustomPainter {
  const _ClipShadowPainter({
    required this.clipper,
    required this.boxShadows, List<BoxShadow>? clipShadow,
  });
  
  final CustomClipper<Path> clipper;
  final List<BoxShadow> boxShadows;

  @override
  void paint(Canvas? canvas, Size? size) {
    for (final shadow in boxShadows) {
      final spreadSize = Size(
        (size?.width ?? 0) + shadow.spreadRadius * 2,
        (size?.height ?? 0) + shadow.spreadRadius * 2,
      );
      final clipPath = clipper.getClip(spreadSize).shift(
            Offset(
              shadow.offset.dx - shadow.spreadRadius,
              shadow.offset.dy - shadow.spreadRadius,
            ),
          );
      final paint = shadow.toPaint();
      canvas?.drawPath(clipPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipShadow extends StatelessWidget {
  /// A list of shadows cast by this box behind the box.
  final List<BoxShadow>? boxShadow;

  /// If non-null, determines which clip to use.
  final CustomClipper<Path> clipper;

  /// The [Widget] below this widget in the tree.
  final Widget? child;

  ClipShadow({
    required this.boxShadow,
    required this.clipper,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowPainter(
          clipShadow: boxShadow,
          clipper: clipper, boxShadows: []
      ),
      child: ClipPath(
        clipper: clipper,
        child: child,
      ),
    );
  }
}
