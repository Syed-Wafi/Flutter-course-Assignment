import 'dart:io';

void main() {
  File('hello.txt').writeAsStringSync('\nWafiul', mode: FileMode.append);
}
