import 'dart:io';

void main() {
  var file = File('students.csv');
  var students = [
    ['Name', 'Age', 'Address'],
    ['Hasanat', '20', 'Habigonj'],
    ['wafi', '21', 'Chittagong'],
    ['Alamin', '22', 'Sylhet']
  ];

  var content = students.map((e) => e.join(',')).join('\n');
  file.writeAsStringSync(content);

  var readData = file.readAsLinesSync();
  for (var line in readData) {
    print(line);
  }
}
