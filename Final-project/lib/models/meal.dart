import 'package:uuid/uuid.dart';

class Meal {
  final String id;
  final String memberId;
  int count;
  Meal({
    String? id,
    required this.memberId,
    required this.count,
  }) : id = id ?? const Uuid().v4();
}
