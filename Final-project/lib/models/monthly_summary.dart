class MonthlySummary {
  final int totalMeals;
  final double totalExpense;
  final double mealRate;
  final Map<String, double> memberBills;
  final Map<String, int> memberMeals;

  MonthlySummary({
    required this.totalMeals,
    required this.totalExpense,
    required this.mealRate,
    required this.memberBills,
    required this.memberMeals,
  });
}
