import 'package:flutter/material.dart';
import '../utils/calculation.dart';
import '../services/database_service.dart';
import '../models/member.dart';
import '../models/meal.dart';
import '../models/expense.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final databaseService = DatabaseService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Trigger rebuild when data is loaded
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Summary')),
      body: FutureBuilder(
        future: Future.wait([
          databaseService.getMembers(),
          databaseService.getMeals(),
          databaseService.getExpenses(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading summary: ${snapshot.error}'),
            );
          }

          final summary = CalculationService.calculateWithData(
            members: (snapshot.data?[0] as List? ?? []).cast<Member>(),
            meals: (snapshot.data?[1] as List? ?? []).cast<Meal>(),
            expenses: (snapshot.data?[2] as List? ?? []).cast<Expense>(),
          );

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: Colors.green[50],
                  elevation: 3,
                  child: ListTile(
                    title: const Text('Total Meals'),
                    trailing: Text('${summary.totalMeals}'),
                  ),
                ),
                Card(
                  color: Colors.green[50],
                  elevation: 3,
                  child: ListTile(
                    title: const Text('Total Expense'),
                    trailing: Text(summary.totalExpense.toStringAsFixed(2)),
                  ),
                ),
                Card(
                  color: Colors.green[50],
                  elevation: 3,
                  child: ListTile(
                    title: const Text('Meal Rate'),
                    trailing: Text(summary.mealRate.toStringAsFixed(2)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Member Bills',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView(
                    children: summary.memberBills.entries
                        .map((e) => Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                title: Text(e.key),
                                subtitle: Text(
                                    'Meals: ${summary.memberMeals[e.key] ?? 0}'),
                                trailing: Text(e.value.toStringAsFixed(2)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
