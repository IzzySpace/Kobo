import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../money/money.dart';
import '../theme/app_theme.dart';

/// Turns kobo into "12,500" for prefilling fields.
String koboToInputText(int kobo) => formatNaira(kobo).replaceFirst('₦', '');

/// Shared look for Kobo's text fields.
InputDecoration koboInputDecoration(
  BuildContext context, {
  String? label,
  String? hint,
  String? prefixText,
  TextStyle? prefixStyle,
  TextStyle? hintStyle,
}) {
  final scheme = Theme.of(context).colorScheme;
  OutlineInputBorder side(Color c, [double w = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: hintStyle,
    prefixText: prefixText,
    prefixStyle: prefixStyle,
    filled: true,
    fillColor: scheme.surfaceContainerLowest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    border: side(scheme.outlineVariant),
    enabledBorder: side(scheme.outlineVariant),
    focusedBorder: side(scheme.primary, 2),
    errorBorder: side(scheme.error),
    focusedErrorBorder: side(scheme.error, 2),
  );
}

/// Live comma grouping, digits plus one dot, max 2 decimal places.
class NairaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (raw.isEmpty) return const TextEditingValue();

    final dot = raw.indexOf('.');
    final hasDot = dot >= 0;
    var intPart = hasDot ? raw.substring(0, dot) : raw;
    var frac = hasDot ? raw.substring(dot + 1).replaceAll('.', '') : '';
    if (frac.length > 2) frac = frac.substring(0, 2);

    intPart = intPart.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    if (intPart.length > 8) return oldValue;

    final grouped = intPart.isEmpty ? (hasDot ? '0' : '') : _group(intPart);
    final text = hasDot ? '$grouped.$frac' : grouped;
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  static String _group(String digits) {
    final b = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) b.write(',');
      b.write(digits[i]);
    }
    return b.toString();
  }
}

class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    required this.controller,
    this.label,
    this.allowZero = false,
    this.optional = false,
    this.autofocus = false,
    this.fontSize = 30,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? label;
  final bool allowZero;

  /// Empty input is accepted (the caller treats it as ₦0).
  final bool optional;
  final bool autofocus;
  final double fontSize;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.amount(fontSize);
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [NairaInputFormatter()],
      style: style,
      onFieldSubmitted: onSubmitted,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: koboInputDecoration(
        context,
        label: label,
        hint: '0',
        hintStyle: style.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.22),
        ),
        prefixText: '₦ ',
        prefixStyle: style.copyWith(color: theme.colorScheme.primary),
      ),
      validator: (v) {
        final text = v ?? '';
        if (optional && text.trim().isEmpty) return null;
        return validateAmount(text, allowZero: allowZero);
      },
    );
  }
}

/// Dialog with one amount field. Returns kobo, or null if cancelled.
Future<int?> showAmountDialog(
  BuildContext context, {
  required String title,
  int initialKobo = 0,
  bool allowZero = true,
}) =>
    showDialog<int>(
      context: context,
      builder: (_) => _AmountDialog(
        title: title,
        initialKobo: initialKobo,
        allowZero: allowZero,
      ),
    );

class _AmountDialog extends StatefulWidget {
  const _AmountDialog({
    required this.title,
    required this.initialKobo,
    required this.allowZero,
  });

  final String title;
  final int initialKobo;
  final bool allowZero;

  @override
  State<_AmountDialog> createState() => _AmountDialogState();
}

class _AmountDialogState extends State<_AmountDialog> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _c = TextEditingController(
    text: widget.initialKobo == 0 ? '' : koboToInputText(widget.initialKobo),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(context, parseNairaToKobo(_c.text));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.title),
        content: Form(
          key: _form,
          child: AmountField(
            controller: _c,
            allowZero: widget.allowZero,
            autofocus: true,
            onSubmitted: (_) => _save(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      );
}
