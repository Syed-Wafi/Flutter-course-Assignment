import 'package:flutter/material.dart';
import '../utils/calculation.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = CalculationService.calculate();

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Summary')),
      body: Padding(
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                            trailing: Text(e.value.toStringAsFixed(2)),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
