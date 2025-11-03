import 'dart:io';

void main() {
  for (int i = 1; i <= 100; i++) {
    File('file_$i.txt').writeAsStringSync('This is file number $i');
  }
}
