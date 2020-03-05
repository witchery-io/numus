import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Future<Database> database;

  DB(path) {
    database = openDatabase(
      join(path, 'addresses_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE address(id INTEGER PRIMARY KEY, address TEXT, settings TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<List<Address>> addresses() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('address');
    return List.generate(maps.length, (i) {
      return Address(
          id: maps[i]['id'],
          address: maps[i]['address'],
          settings: maps[i]['settings']);
    });
  }

  Future<void> insertAddress(Address address) async {
    final Database db = await database;
    await db.insert('address', address.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteAddress(int id) async {
    final db = await database;
    await db.delete('address', where: "id = ?", whereArgs: [id]);
  }

  Future<void> updateAddress(Address address) async {
    final db = await database;
    await db.update('address', address.toMap(),
        where: "id = ?", whereArgs: [address.id]);
  }

  Future delete() async {
    final db = await database;
    db.delete('address');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

class Address {
  final int id;
  final String address;
  final String settings;

  Address({this.id, this.address, this.settings});

  Map<String, dynamic> toMap() {
    return {'id': id, 'address': address, 'settings': settings};
  }

  @override
  String toString() {
    return 'Address{id: $id, address: $address, age: $settings}';
  }
}
