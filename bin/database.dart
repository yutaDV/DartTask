
import 'package:sqlite3/sqlite3.dart';
import 'getname.dart';
import 'dart:io';


void saveToDatabase(Root user) {
  final db = sqlite3.open('names.db');

  db.execute(
      '''
    CREATE TABLE IF NOT EXISTS names(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      count INTEGER,
      gender TEXT,
      probability REAL
    )
    '''
  );

  final existingUser = db.select(
    'SELECT * FROM names WHERE name = ?',
    [user.name],
  );

  if (existingUser.isEmpty) {
    db.execute(
        '''
      INSERT INTO names(name, count, gender, probability)
      VALUES (?, ?, ?, ?)
      ''',
        [user.name, user.count, user.gender, user.probability]
    );

    print('User details saved to database');
  } else {
    print('User details already exist in database');
  }
}

void printDatabase() {
  final db = sqlite3.open('names.db');

  final results = db.select('SELECT * FROM names');

  for (final row in results) {
    print('Name: ${row['name']}');
    print('Gender: ${row['gender']}');
    print('Count: ${row['count']}');
    print('Probability: ${row['probability']}');
    print('');
  }

  //db.close();
}

void printNamesWithLetters(String letters) {
  final db = sqlite3.open('names.db');

  final results = db.select(
    'SELECT name, count, gender, probability FROM names WHERE name LIKE ?',
    ['%$letters%'],
  );

  if (results.isNotEmpty) {
    print('Names containing letters "$letters":');
    for (final row in results) {
      print('Name: ${row['name']}');
      print('Gender: ${row['gender']}');
      print('Count: ${row['count']}');
      print('Probability: ${row['probability']}');
      print('');
    }
  } else {
    print('No names found containing letters "$letters".');
  }

}

void saveToTextFile() {
  final db = sqlite3.open('names.db');

  final result = db.select('SELECT * FROM names');

  final file = File('names.txt');
  if (!file.existsSync()) {
    file.createSync();
  } else {
    file.writeAsStringSync('');
  }

  final sink = file.openWrite();
  for (final row in result) {
    sink.writeln('Name: ${row['name']}, Count: ${row['count']}, Gender: ${row['gender']}, Probability: ${row['probability']}');
  }

  sink.close();
  print('Data saved to text file');
}
