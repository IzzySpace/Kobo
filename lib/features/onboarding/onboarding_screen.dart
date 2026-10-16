import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/database/app_database.dart';
import '../../core/dates.dart';
import '../../core/money/money.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/amount_field.dart';
import '../../core/ui/labels.dart';
import '../../core/ui/motion.dart';
import '../../core/ui/note_card.dart';
import '../../core/ui/step_layout.dart';
import '../budget/ui/budget_plan_step.dart';
import '../budget/ui/categories_editor.dart';
import 'onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();
  int _step = 0;
  static const _count = 6;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _go(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    final d = Motion.of(context, Motion.medium);
    if (d == Duration.zero) {
      _pages.jumpToPage(step);
    } else {
      _pages.animateToPage(step, duration: d, curve: Motion.curve);
    }
  }

  void _next() => _go(_step + 1);
  void _back() => _go(_step - 1);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: _step == 0
            ? null
            : AppBar(
                backgroundColor: scheme.surface,
                surfaceTintColor: Colors.transparent,
                scrolledUnderElevation: 0,
                leading: BackButton(onPressed: _back),
                titleSpacing: 0,
                title: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _StepProgress(current: _step, total: _count - 1),
                ),
              ),
        body: PageView(
          controller: _pages,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _WelcomeStep(onNext: _next),
            _BalanceStep(onNext: _next),
            _IncomeStep(onNext: _next),
            _GoalStep(onNext: _next),
            _CategoriesStep(onNext: _next),
            const BudgetPlanStep(),
          ],
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: 'Step $current of $total',
      child: Row(
        children: [
          for (var i = 1; i <= total; i++)
            Expanded(
              child: AnimatedContainer(
                duration: Motion.of(context, Motion.medium),
                curve: Motion.curve,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: i <= current
                      ? scheme.primary
                      : scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------- Welcome ----------------

class _WelcomeStep extends StatefulWidget {
  const _WelcomeStep({required this.onNext});
  final VoidCallback onNext;

  @override
  State<_WelcomeStep> createState() => _WelcomeStepState();
}

class _WelcomeStepState extends State<_WelcomeStep>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );
  late final Animation<double> _lines = CurvedAnimation(
    parent: _c,
    curve: const Interval(0, 0.75, curve: Curves.easeInOutCubic),
  );
  late final Animation<double> _copy = CurvedAnimation(
    parent: _c,
    curve: const Interval(0.45, 1, curve: Curves.easeOutCubic),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (Motion.reduced(context)) {
      _c.value = 1;
    } else {
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final k = context.koboColors;
    final text = Theme.of(context).textTheme;
    final height = MediaQuery.sizeOf(context).height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ColoredBox(
        color: k.note,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.62,
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _lines,
                  builder: (_, __) => CustomPaint(
                    painter: GuillochePainter(
                      color: k.onNote.withValues(alpha: 0.14),
                      progress: _lines.value,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
                child: AnimatedBuilder(
                  animation: _copy,
                  builder: (context, child) => Opacity(
                    opacity: _copy.value,
                    child: Transform.translate(
                      offset: Offset(0, 18 * (1 - _copy.value)),
                      child: child,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('kobo',
                          style: displayStyle(28, weight: 800, color: k.onNote)),
                      const Spacer(),
                      Text(
                        'Make it last till the next alert.',
                        style: displayStyle(44,
                            weight: 780, height: 1.02, color: k.onNote),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'A budget that works offline. No account, no data '
                        'needed.',
                        style: text.bodyLarge?.copyWith(
                          color: k.onNote.withValues(alpha: 0.8),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: k.onNote,
                            foregroundColor: k.note,
                          ),
                          onPressed: widget.onNext,
                          child: const Text('Get started'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Balance ----------------

class _BalanceStep extends ConsumerStatefulWidget {
  const _BalanceStep({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_BalanceStep> createState() => _BalanceStepState();
}

class _BalanceStepState extends ConsumerState<_BalanceStep> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _c;
  static const _quick = [5000, 10000, 20000, 50000, 100000];

  @override
  void initState() {
    super.initState();
    final k = ref.read(onboardingProvider).balanceKobo;
    _c = TextEditingController(text: k == 0 ? '' : koboToInputText(k));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _setQuick(int kobo) {
    HapticFeedback.selectionClick();
    _c.text = koboToInputText(kobo);
    _c.selection = TextSelection.collapsed(offset: _c.text.length);
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    ref.read(onboardingProvider.notifier).setBalance(parseNairaToKobo(_c.text)!);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _form,
        child: StepLayout(
          title: 'How much do you have right now?',
          subtitle: 'Your bank balance plus any cash. You can change it later.',
          primaryLabel: 'Continue',
          onPrimary: _submit,
          children: [
            AmountField(
              controller: _c,
              allowZero: true,
              autofocus: true,
              fontSize: 44,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final n in _quick)
                  ActionChip(
                    label: Text(formatNaira(n * 100)),
                    onPressed: () => _setQuick(n * 100),
                  ),
              ],
            ),
          ],
        ),
      );
}

// ---------------- Income ----------------

class _IncomeStep extends ConsumerStatefulWidget {
  const _IncomeStep({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_IncomeStep> createState() => _IncomeStepState();
}

class _IncomeStepState extends ConsumerState<_IncomeStep> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late IncomeFrequency _freq;
  late DateTime _end;
  bool _endPicked = false;

  bool get _irregular => _freq == IncomeFrequency.irregular;

  @override
  void initState() {
    super.initState();
    final d = ref.read(onboardingProvider);
    _amount = TextEditingController(
      text: d.usualIncomeKobo == 0 ? '' : koboToInputText(d.usualIncomeKobo),
    );
    _freq = d.frequency;
    _endPicked = d.cycleEnd != null;
    _end = d.cycleEnd ?? _defaultEnd(_freq);
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  static DateTime _tomorrow() {
    final t = DateTime.now();
    return DateTime(t.year, t.month, t.day + 1);
  }

  static DateTime _defaultEnd(IncomeFrequency f) {
    final t = DateTime.now();
    return switch (f) {
      IncomeFrequency.weekly => DateTime(t.year, t.month, t.day + 7),
      IncomeFrequency.monthly => DateTime(t.year, t.month + 1, t.day),
      IncomeFrequency.irregular => DateTime(t.year, t.month, t.day + 30),
    };
  }

  static IconData _icon(IncomeFrequency f) => switch (f) {
        IncomeFrequency.weekly => Icons.view_week_rounded,
        IncomeFrequency.monthly => Icons.calendar_month_rounded,
        IncomeFrequency.irregular => Icons.bolt_rounded,
      };

  Future<void> _pickDate() async {
    final tomorrow = _tomorrow();
    final picked = await showDatePicker(
      context: context,
      initialDate: _end.isBefore(tomorrow) ? tomorrow : _end,
      firstDate: tomorrow,
      lastDate: DateTime(tomorrow.year + 1, tomorrow.month, tomorrow.day),
    );
    if (picked != null) {
      setState(() {
        _end = picked;
        _endPicked = true;
      });
    }
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    if (_end.isBefore(_tomorrow())) _end = _defaultEnd(_freq);
    ref.read(onboardingProvider.notifier).setIncome(
          usualKobo: parseNairaToKobo(_amount.text) ?? 0,
          frequency: _freq,
          cycleEnd: dateOnly(_end),
        );
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final scheme = theme.colorScheme;
    final days = cycleDays(_end);

    return Form(
      key: _form,
      child: StepLayout(
        title: 'When does money come in?',
        subtitle: 'This sets how long your money needs to last.',
        primaryLabel: 'Continue',
        onPrimary: _submit,
        children: [
          Row(
            children: [
              for (final f in IncomeFrequency.values) ...[
                if (f != IncomeFrequency.values.first)
                  const SizedBox(width: 10),
                Expanded(
                  child: _FrequencyTile(
                    icon: _icon(f),
                    label: f.label,
                    selected: _freq == f,
                    onTap: () => setState(() {
                      _freq = f;
                      if (!_endPicked) _end = _defaultEnd(f);
                    }),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          AmountField(
            controller: _amount,
            label: _irregular ? 'Typical amount (optional)' : 'How much each time?',
            allowZero: _irregular,
            optional: _irregular,
          ),
          const SizedBox(height: 20),
          Pressable(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _irregular ? 'Make it last until' : 'Next income',
                          style: text.labelLarge
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, d MMMM').format(_end),
                          style: text.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text('Tap to change',
                            style: text.bodySmall
                                ?.copyWith(color: scheme.primary)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedCount(days,
                          style: text.amount(40, color: scheme.primary)),
                      Text(days == 1 ? 'day' : 'days',
                          style: text.labelMedium),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_irregular) ...[
            const SizedBox(height: 12),
            Text(
              'Each time you add income, Kobo will ask this again.',
              style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _FrequencyTile extends StatelessWidget {
  const _FrequencyTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Pressable(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.of(context, Motion.medium),
        curve: Motion.curve,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        decoration: BoxDecoration(
          color: selected
              ? scheme.primary.withValues(alpha: 0.12)
              : scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: selected ? scheme.primary : scheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? scheme.primary : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Savings goal ----------------

class _GoalStep extends ConsumerStatefulWidget {
  const _GoalStep({required this.onNext});
  final VoidCallback onNext;

  @override
  ConsumerState<_GoalStep> createState() => _GoalStepState();
}

class _GoalStepState extends ConsumerState<_GoalStep> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _target;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    final g = ref.read(onboardingProvider).goal;
    _name = TextEditingController(text: g?.name ?? '');
    _target = TextEditingController(
      text: g == null ? '' : koboToInputText(g.targetKobo),
    );
    _deadline = g?.deadline;
  }

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final t = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime(t.year, t.month + 3, t.day),
      firstDate: DateTime(t.year, t.month, t.day + 1),
      lastDate: DateTime(t.year + 5, t.month, t.day),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    ref.read(onboardingProvider.notifier).setGoal((
      name: _name.text.trim(),
      targetKobo: parseNairaToKobo(_target.text)!,
      deadline: _deadline,
    ));
    widget.onNext();
  }

  void _skip() {
    FocusScope.of(context).unfocus();
    ref.read(onboardingProvider.notifier).setGoal(null);
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) => Form(
        key: _form,
        child: StepLayout(
          title: 'Saving for something?',
          subtitle: 'Optional. A new phone, next session’s fees, a trip '
              'home. Kobo will set money aside for it.',
          primaryLabel: 'Save goal',
          onPrimary: _save,
          secondaryLabel: 'Skip for now',
          onSecondary: _skip,
          children: [
            TextFormField(
              controller: _name,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration:
                  koboInputDecoration(context, label: 'What are you saving for?'),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Give your goal a name'
                  : null,
            ),
            const SizedBox(height: 8),
            AmountField(controller: _target, label: 'Target amount'),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: _deadline == null
                  ? OutlinedButton.icon(
                      onPressed: _pickDeadline,
                      icon: const Icon(Icons.event_rounded),
                      label: const Text('Add a deadline (optional)'),
                    )
                  : InputChip(
                      avatar: const Icon(Icons.event_rounded),
                      label: Text(
                          'By ${DateFormat('d MMM yyyy').format(_deadline!)}'),
                      onPressed: _pickDeadline,
                      onDeleted: () => setState(() => _deadline = null),
                    ),
            ),
          ],
        ),
      );
}

// ---------------- Categories ----------------

class _CategoriesStep extends StatelessWidget {
  const _CategoriesStep({required this.onNext});
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => StepLayout(
        title: 'What do you spend on?',
        subtitle: 'Tap a category to rename it, change its priority or '
            'remove it. Priority decides what gets money first.',
        primaryLabel: 'Looks good',
        onPrimary: onNext,
        children: const [CategoriesEditor()],
      );
}
