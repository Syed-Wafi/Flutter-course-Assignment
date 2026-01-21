import '../data/mess_store.dart';
import '../models/monthly_summary.dart';
import '../models/member.dart';
import '../models/meal.dart';
import '../models/expense.dart';

class CalculationService {
  static MonthlySummary calculate() {
    final totalMeals = MessStore.getMeals().fold(0, (sum, m) => sum + m.count);

    final totalExpense =
        MessStore.getExpenses().fold(0.0, (sum, e) => sum + e.amount);

    final mealRate = totalMeals == 0 ? 0.0 : totalExpense / totalMeals;

    final Map<String, double> bills = {};
    final Map<String, int> memberMealCounts = {};
    for (var member in MessStore.getMembers()) {
      final memberMeals = MessStore.getMeals()
          .where((m) => m.memberId == member.id)
          .fold(0, (sum, m) => sum + m.count);
      bills[member.name] = (memberMeals * mealRate).toDouble();
      memberMealCounts[member.name] = memberMeals;
    }

    return MonthlySummary(
      totalMeals: totalMeals,
      totalExpense: totalExpense,
      mealRate: mealRate,
      memberBills: bills,
      memberMeals: memberMealCounts,
    );
  }

  static MonthlySummary calculateWithData({
    required List<Member> members,
    required List<Meal> meals,
    required List<Expense> expenses,
  }) {
    final totalMeals = meals.fold(0, (sum, m) => sum + m.count);
    final totalExpense = expenses.fold(0.0, (sum, e) => sum + e.amount);
    final mealRate = totalMeals == 0 ? 0.0 : totalExpense / totalMeals;

    final Map<String, double> bills = {};
    final Map<String, int> memberMealCounts = {};

    for (var member in members) {
      final memberMeals = meals
          .where((m) => m.memberId == member.id)
          .fold(0, (sum, m) => sum + m.count);
      bills[member.name] = (memberMeals * mealRate).toDouble();
      memberMealCounts[member.name] = memberMeals;
    }

    return MonthlySummary(
      totalMeals: totalMeals,
      totalExpense: totalExpense,
      mealRate: mealRate,
      memberBills: bills,
      memberMeals: memberMealCounts,
    );
  }
}
