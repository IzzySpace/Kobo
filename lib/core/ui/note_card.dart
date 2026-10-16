import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Banknote security pattern: interference waves plus a seal rosette.
/// [progress] from 0 to 1 draws it in from left to right.
class GuillochePainter extends CustomPainter {
  GuillochePainter({required this.color, this.progress = 1});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = color;
    final w = size.width;
    final h = size.height;

    // Waves across the note.
    final maxX = w * progress;
    for (var i = 0; i < 9; i++) {
      final path = Path();
      final base = h * (0.34 + i * 0.075);
      final amp = h * (0.05 + 0.012 * i);
      final phase = i * 0.55;
      for (double x = 0; x <= maxX; x += 3) {
        final t = x / w;
        final y = base +
            amp *
                math.sin(t * math.pi * 4 + phase) *
                math.cos(t * math.pi * 1.5 - phase * 0.5);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }

    // Seal rosette, top right.
    final center = Offset(w * 0.84, h * 0.24);
    final r = math.min(w, h) * 0.34;
    final end = math.pi * 2 * progress;
    for (var j = 0; j < 7; j++) {
      final path = Path();
      for (double a = 0; a <= end; a += 0.02) {
        final rr = r * (0.72 + 0.28 * math.sin(9 * a + j * 0.45));
        final p = center + Offset(math.cos(a) * rr, math.sin(a) * rr);
        if (a == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(GuillochePainter old) =>
      old.progress != progress || old.color != color;
}

/// The note-green card used for the most important number on a screen.
class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final k = context.koboColors;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: ColoredBox(
        color: k.note,
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: GuillochePainter(
                    color: k.onNote.withValues(alpha: 0.09),
                  ),
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: DefaultTextStyle.merge(
                style: TextStyle(color: k.onNote),
                child: IconTheme.merge(
                  data: IconThemeData(color: k.onNote),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
