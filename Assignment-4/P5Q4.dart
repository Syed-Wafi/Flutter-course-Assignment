import 'dart:io';

void main() {
  File('hello.txt').copySync('hello_copy.txt');
}
