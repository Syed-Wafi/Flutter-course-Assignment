import 'package:uuid/uuid.dart';

class Member {
  final String id;
  String name;
  Member({
    String? id,
    required this.name,
  }) : id = id ?? const Uuid().v4();
}
