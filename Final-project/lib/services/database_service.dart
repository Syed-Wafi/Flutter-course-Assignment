import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/member.dart';
import '../models/meal.dart';
import '../models/expense.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  final SupabaseClient _supabase = Supabase.instance.client;

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  String get userId => _supabase.auth.currentUser?.id ?? '';

  // ==================== MEMBER OPERATIONS ====================
  Future<void> addMember(Member member) async {
    try {
      await _supabase.from('members').insert({
        'id': member.id,
        'name': member.name,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Member>> getMembers() async {
    try {
      final response = await _supabase
          .from('members')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => Member(
                id: data['id'],
                name: data['name'],
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMember(String memberId, String newName) async {
    try {
      await _supabase
          .from('members')
          .update({
            'name': newName,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', memberId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMember(String memberId) async {
    try {
      // Delete associated meals first
      await _supabase
          .from('meals')
          .delete()
          .eq('member_id', memberId)
          .eq('user_id', userId);

      // Then delete the member
      await _supabase
          .from('members')
          .delete()
          .eq('id', memberId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== MEAL OPERATIONS ====================
  Future<void> addMeal(Meal meal) async {
    try {
      await _supabase.from('meals').insert({
        'id': meal.id,
        'member_id': meal.memberId,
        'count': meal.count,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Meal>> getMeals() async {
    try {
      final response = await _supabase
          .from('meals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => Meal(
                id: data['id'],
                memberId: data['member_id'],
                count: data['count'],
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMeal(String mealId, int count) async {
    try {
      await _supabase
          .from('meals')
          .update({
            'count': count,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', mealId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMeal(String mealId) async {
    try {
      await _supabase
          .from('meals')
          .delete()
          .eq('id', mealId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== EXPENSE OPERATIONS ====================
  Future<void> addExpense(Expense expense) async {
    try {
      await _supabase.from('expenses').insert({
        'id': expense.id,
        'title': expense.title,
        'amount': expense.amount,
        'user_id': userId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Expense>> getExpenses() async {
    try {
      final response = await _supabase
          .from('expenses')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((data) => Expense(
                id: data['id'],
                title: data['title'],
                amount: (data['amount'] as num).toDouble(),
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateExpense(String expenseId, Expense expense) async {
    try {
      await _supabase
          .from('expenses')
          .update({
            'title': expense.title,
            'amount': expense.amount,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', expenseId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      await _supabase
          .from('expenses')
          .delete()
          .eq('id', expenseId)
          .eq('user_id', userId);
    } catch (e) {
      rethrow;
    }
  }

  // ==================== UTILITY ====================
  Future<void> clearAllUserData() async {
    try {
      final uid = userId;
      // Delete all meals
      await _supabase.from('meals').delete().eq('user_id', uid);
      // Delete all expenses
      await _supabase.from('expenses').delete().eq('user_id', uid);
      // Delete all members
      await _supabase.from('members').delete().eq('user_id', uid);
    } catch (e) {
      rethrow;
    }
  }
}
