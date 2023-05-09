import 'package:untitled/untitled.dart' as untitled;
import 'dart:io';
import 'getname.dart';
import 'database.dart';


void menu() {
  String? input;

  do {
    print('---------------------');
    print('1. Запит імені');
    print('2. Вивід усієї  інформації з бази даних');
    print('3. Запис інформації в файл');
    print('4. Вибірка інформації за параметром');
    print('5. Вихід');
    print('---------------------');
    print('Введіть номер пункту:');

    input = stdin.readLineSync();

    try {
      int choice = int.parse(input!);

      switch (choice) {
        case 1:
        // виклик методу для запиту імені
          getName();
          break;
        case 2:
        // виклик методу для виведення інформації з бази даних
          printDatabase();
          break;
        case 3:
        // виклик методу для запису інформації в файл
          saveToTextFile();
          break;
        case 4:
        // виклик методу для вибірки інформації за параметром
          print('Please enter the letters that shouid be in the name:');
          String letters = stdin.readLineSync() ?? '';
          printNamesWithLetters(letters);
          break;
        case 5:
          print('До побачення!');
          break;
        default:
          print('Неправильний ввід. Введіть номер від 1 до 5.');
          break;
      }
    } catch (e) {
      print('Неправильний ввід. Введіть номер від 1 до 5.');
    }
  } while (input != '5');
}


void main(List<String> arguments) {
  print('Hello world: ${untitled.calculate()}!');
  menu();
}
