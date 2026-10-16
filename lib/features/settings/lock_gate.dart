import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/providers.dart';
import '../../core/theme/app_theme.dart';

/// Covers the app with a lock screen when app lock is on: at launch, and
/// after Kobo has been in the background for 30 seconds or more.
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate> {
  static const _relockAfter = Duration(seconds: 30);

  final _auth = LocalAuthentication();
  late final AppLifecycleListener _life;
  bool _locked = false;
  bool _authing = false;
  DateTime? _hiddenAt;

  bool get _enabled => switch (ref.read(settingsProvider)) {
        AsyncData(:final value) => value.appLockEnabled,
        _ => false,
      };

  @override
  void initState() {
    super.initState();
    _locked = _enabled;
    _life = AppLifecycleListener(onHide: _onHide, onShow: _onShow);
    if (_locked) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _unlock());
    }
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  void _onHide() {
    // The fingerprint prompt itself hides the app; don't count that.
    if (!_authing) _hiddenAt = DateTime.now();
  }

  void _onShow() {
    final hidden = _hiddenAt;
    _hiddenAt = null;
    if (_authing || !_enabled || hidden == null) return;
    if (DateTime.now().difference(hidden) >= _relockAfter) {
      setState(() => _locked = true);
      _unlock();
    }
  }

  Future<void> _unlock() async {
    if (_authing) return;
    _authing = true;
    var ok = false;
    try {
      ok = await _auth.authenticate(
        localizedReason: 'Unlock Kobo to see your budget',
        options: const AuthenticationOptions(stickyAuth: true),
      );
    } on PlatformException {
      ok = false;
    } finally {
      _authing = false;
    }
    if (ok && mounted) setState(() => _locked = false);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = switch (ref.watch(settingsProvider)) {
      AsyncData(:final value) => value.appLockEnabled,
      _ => false,
    };
    return Stack(
      children: [
        widget.child,
        if (enabled && _locked)
          Positioned.fill(child: _LockScreen(onUnlock: _unlock)),
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock});
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final k = context.koboColors;
    final text = Theme.of(context).textTheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Material(
        color: k.note,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('kobo',
                    style: displayStyle(28, weight: 800, color: k.onNote)),
                const Spacer(),
                Icon(Icons.lock_outline_rounded, size: 48, color: k.onNote),
                const SizedBox(height: 16),
                Text('Kobo is locked',
                    style: displayStyle(36, weight: 760, color: k.onNote)),
                const SizedBox(height: 8),
                Text(
                  'Use your fingerprint or phone PIN to open it.',
                  style: text.bodyLarge
                      ?.copyWith(color: k.onNote.withValues(alpha: 0.8)),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: k.onNote,
                      foregroundColor: k.note,
                    ),
                    onPressed: onUnlock,
                    child: const Text('Unlock'),
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
