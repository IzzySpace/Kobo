/// Suggested split for income above the usual amount:
/// 40% savings, 20% a small treat, the rest to the emergency buffer.
/// Savings and treat round down to ₦100; the buffer takes the remainder.
class IncomeSplit {
  const IncomeSplit({
    required this.buffer,
    required this.savings,
    required this.treat,
  });

  final int buffer;
  final int savings;
  final int treat;

  int get total => buffer + savings + treat;

  factory IncomeSplit.of(int extraKobo) {
    if (extraKobo <= 0) {
      return const IncomeSplit(buffer: 0, savings: 0, treat: 0);
    }
    int down(int k) => k - k % 10000;
    final savings = down(extraKobo * 40 ~/ 100);
    final treat = down(extraKobo * 20 ~/ 100);
    return IncomeSplit(
      buffer: extraKobo - savings - treat,
      savings: savings,
      treat: treat,
    );
  }
}
