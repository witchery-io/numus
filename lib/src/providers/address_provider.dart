import 'package:sqflite/sqflite.dart';

final String tableAddress = 'address';
final String columnId = '_id';
final String columnTitle = 'title';
final String columnDone = 'done';

class Address {
  int id;
  String title;
  bool done;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Address();

  Address.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class AddressProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableAddress ( 
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnDone integer not null)
''');
    });
  }

  Future<Address> insert(Address address) async {
    address.id = await db.insert(tableAddress, address.toMap());
    return address;
  }

  Future<Address> getAddress(int id) async {
    List<Map> maps = await db.query(tableAddress,
        columns: [columnId, columnDone, columnTitle],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Address.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableAddress, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Address address) async {
    return await db.update(tableAddress, address.toMap(),
        where: '$columnId = ?', whereArgs: [address.id]);
  }

  Future close() async => db.close();
}
