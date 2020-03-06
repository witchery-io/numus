import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Future<Database> database;

  DB._(this.database);

  factory DB.init(path) {
    return DB._(openDatabase(join(path, 'addresses_database.db'),
        version: 1,
        onCreate: (db, version) => db.execute(
            "CREATE TABLE address(id INTEGER PRIMARY KEY, type TEXT, balance NUMERIC, hasUsed INTEGER)")));
  }

  Future<List<Address>> addresses() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('address');
    return List.generate(
        maps.length,
        (i) => Address(
            id: maps[i]['id'],
            type: maps[i]['type'],
            balance: maps[i]['balance'],
            hasUsed: maps[i]['hasUsed']));
  }

  Future<List<Map>> getValidAddressId(String type) async {
    final Database db = await database;
    return db.query('address',
        columns: ['id'], where: 'balance > 0 AND type == "$type"');
  }

  Future<List<Map>> getUnusedAddress(String type) async {
    final Database db = await database;
    return db.query('address',
        columns: ['id'], where: 'hasUsed == 0 AND type == "$type"', limit: 1);
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
  final int hasUsed;

  Address({this.id, this.type, this.balance, this.hasUsed});

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type, 'balance': balance, 'hasUsed': hasUsed};
  }

  @override
  String toString() {
    return 'Address{id: $id, type: $type, balance: $balance, hasUsed: $hasUsed}';
  }
}
