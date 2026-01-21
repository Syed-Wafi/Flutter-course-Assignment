import 'package:uuid/uuid.dart';

class Expense {
  final String id;
  String title;
  double amount;
  Expense({
    String? id,
    required this.title,
    required this.amount,
  }) : id = id ?? const Uuid().v4();
}
