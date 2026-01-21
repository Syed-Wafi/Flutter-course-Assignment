import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/member.dart';
import '../models/meal.dart';

class MealPage extends StatefulWidget {
  const MealPage({super.key});

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  Member? selectedMember;
  final mealController = TextEditingController();
  final databaseService = DatabaseService();
  List<Member> members = [];
  List<Meal> meals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final loadedMembers = await databaseService.getMembers();
      final loadedMeals = await databaseService.getMeals();
      setState(() {
        members = loadedMembers;
        meals = loadedMeals;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _addMeal() async {
    if (selectedMember == null || mealController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a member and enter meal count')),
        );
      }
      return;
    }
    
    final count = int.tryParse(mealController.text);
    if (count == null || count <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid meal count')),
        );
      }
      return;
    }

    try {
      final existingMeal = meals.firstWhere(
        (m) => m.memberId == selectedMember!.id,
        orElse: () => Meal(memberId: '', count: 0),
      );

      if (existingMeal.memberId.isNotEmpty) {
        await databaseService.updateMeal(existingMeal.id, count);
      } else {
        final newMeal = Meal(memberId: selectedMember!.id, count: count);
        await databaseService.addMeal(newMeal);
      }
      
      if (mounted) {
        // Clear input before closing
        mealController.clear();
        selectedMember = null;
        
        // Close modal
        Navigator.pop(context);
        
        // Reload data after closing modal
        await _loadData();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal added/updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding meal: $e')),
        );
      }
    }
  }

  Future<void> _deleteMeal(String mealId) async {
    try {
      await databaseService.deleteMeal(mealId);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Meal deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting meal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meals')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (_) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<Member>(
                          value: selectedMember,
                          hint: const Text('Select Member'),
                          isExpanded: true,
                          items: members.map((m) {
                            return DropdownMenuItem(
                              value: m,
                              child: Text(m.name),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedMember = val;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: mealController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Meals'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: _addMeal,
                            child: const Text('Add / Update Meal')),
                      ],
                    ),
                  ));
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : meals.isEmpty
              ? const Center(
                  child: Text('No meals added yet. Add meals to get started!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: meals.length,
                  itemBuilder: (_, index) {
                    final meal = meals[index];
                    final member = members.firstWhere(
                      (m) => m.id == meal.memberId,
                      orElse: () => Member(name: 'Unknown'),
                    );
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text('${member.name} - ${meal.count} meals'),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteMeal(meal.id)),
                      ),
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    mealController.dispose();
    super.dispose();
  }
}
