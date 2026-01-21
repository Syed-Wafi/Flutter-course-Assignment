import '../models/member.dart';
import '../models/meal.dart';
import '../models/expense.dart';

class MessStore {
  static final List<Member> members = [];
  static final List<Meal> meals = [];
  static final List<Expense> expenses = [];

  // MEMBER CRUD
  static void addMember(Member m) => members.add(m);
  static void updateMember(String id, String newName) {
    final index = members.indexWhere((m) => m.id == id);
    if (index != -1) members[index].name = newName;
  }
  static void deleteMember(String id) {
    members.removeWhere((m) => m.id == id);
    meals.removeWhere((m) => m.memberId == id);
  }
  static List<Member> getMembers() => members;

  // MEAL CRUD
  static void addMeal(Meal m) => meals.add(m);
  static void updateMeal(String memberId, int count) {
    final index = meals.indexWhere((m) => m.memberId == memberId);
    if (index != -1) meals[index].count = count;
  }
  static void deleteMeal(String memberId) =>
      meals.removeWhere((m) => m.memberId == memberId);
  static List<Meal> getMeals() => meals;

  // EXPENSE CRUD
  static void addExpense(Expense e) => expenses.add(e);
  static void updateExpense(int index, Expense e) {
    if (index >= 0 && index < expenses.length) expenses[index] = e;
  }
  static void deleteExpense(int index) {
    if (index >= 0 && index < expenses.length) expenses.removeAt(index);
  }
  static List<Expense> getExpenses() => expenses;
}
