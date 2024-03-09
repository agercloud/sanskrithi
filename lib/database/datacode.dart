import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) => Grocery(
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async => await db.execute('''
        CREATE TABLE groceries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
        )
      '''),
    );
  }

  Future<List<Grocery>> getGroceries(String searchQuery) async {
    final db = await database;
    try {
      final groceries = await db.query('groceries',
          where: searchQuery.isNotEmpty ? 'name LIKE ?' : null,
          whereArgs: searchQuery.isNotEmpty ? ['%$searchQuery%'] : null,
          orderBy: 'name');
      return groceries.map((g) => Grocery.fromMap(g)).toList();
    } catch (error) {
      throw error;
    }
  }

  Future<int> addGrocery(Grocery grocery) async {
    final db = await database;
    return await db.insert('groceries', grocery.toMap());
  }

  Future<int> remove(String name) async {
    Database db = await instance.database;
    return await db.delete('groceries', where: 'name = ?', whereArgs: [name]);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
