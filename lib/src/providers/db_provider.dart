import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Future<Database> database;

  DB(path) {
    database = openDatabase(join(path, 'addresses_database.db'),
        version: 1,
        onCreate: (db, version) => db.execute(
            "CREATE TABLE address(id INTEGER PRIMARY KEY, type TEXT, balance NUMERIC)"));
  }

  Future<List<Address>> addresses() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('address');
    return List.generate(
        maps.length,
        (i) => Address(
            id: maps[i]['id'],
            type: maps[i]['type'],
            balance: maps[i]['balance']));
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
    await db.delete('address');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

class Address {
  final int id;
  final String type;
  final num balance;

  Address({this.id, this.type, this.balance});

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type, 'balance': balance};
  }

  @override
  String toString() {
    return 'Address{id: $id, type: $type, balance: $balance}';
  }
}
