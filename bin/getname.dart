import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqlite3/sqlite3.dart';
import 'dart:io';
//import 'package:path_provider/path_provider.dart';

class Root {
  final int count;
  final String gender;
  final String name;
  final double probability;

  Root({
    required this.count,
    required this.gender,
    required this.name,
    required this.probability,
  });

  factory Root.fromJson(Map<String, dynamic> json) {
    return Root(
      count: json['count'],
      gender: json['gender'],
      name: json['name'],
      probability: json['probability'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'count': count,
      'gender': gender,
      'probability': probability,
    };
  }
}

void main()  {
  getName();
}
void getName() async {
  print('Please enter a name:');
  String name = stdin.readLineSync() ?? '';

  Root user = await getUserDetails(name);

  print('Name: ${user.name}');
  print('Gender: ${user.gender}');
  print('Probability: ${user.probability}');

  saveToDatabase(user);
}

Future<Root> getUserDetails(String name) async {
  String apiUrl = 'https://api.genderize.io?name=$name';
  http.Response response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    return Root.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

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
  //db.close();
}

