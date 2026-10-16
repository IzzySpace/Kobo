import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../money/money.dart';

/// Shared timings. Everything goes through [of] so the phone's
/// "Remove animations" setting turns motion off app-wide.
abstract final class Motion {
  static const fast = Duration(milliseconds: 160);
  static const medium = Duration(milliseconds: 360);
  static const slow = Duration(milliseconds: 900);
  static const curve = Curves.easeOutCubic;

  static bool reduced(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  static Duration of(BuildContext context, Duration d) =>
      reduced(context) ? Duration.zero : d;
}

/// A naira amount that counts to its new value when it changes.
class AnimatedNaira extends StatelessWidget {
  const AnimatedNaira(
    this.kobo, {
    super.key,
    this.style,
    this.countUp = false,
    this.duration = Motion.medium,
  });

  final int kobo;
  final TextStyle? style;

  /// Count up from ₦0 on first appearance.
  final bool countUp;
  final Duration duration;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: countUp ? 0 : null, end: kobo.toDouble()),
        duration: Motion.of(context, countUp ? Motion.slow : duration),
        curve: Motion.curve,
        builder: (context, value, _) {
          // Whole naira while moving, exact value once settled.
          final shown = value == kobo ? kobo : (value / 100).round() * 100;
          return Text(
            formatNaira(shown),
            style: style,
            maxLines: 1,
            softWrap: false,
          );
        },
      );
}

/// A whole number that counts to its new value.
class AnimatedCount extends StatelessWidget {
  const AnimatedCount(this.value, {super.key, this.style});

  final int value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
        tween: Tween<double>(end: value.toDouble()),
        duration: Motion.of(context, Motion.medium),
        curve: Motion.curve,
        builder: (context, v, _) => Text('${v.round()}', style: style),
      );
}

/// Shrinks slightly while pressed and gives a light haptic tick on tap.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _set(true) : null,
        onTapUp: enabled ? (_) => _set(false) : null,
        onTapCancel: enabled ? () => _set(false) : null,
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                widget.onTap!();
              }
            : null,
        child: AnimatedScale(
          scale: _down ? widget.scale : 1,
          duration: Motion.of(context, Motion.fast),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      ),
    );
  }
}
