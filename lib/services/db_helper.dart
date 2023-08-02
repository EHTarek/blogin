import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbHelper {
  static const int version = 1;
  static const dbName = 'ShoppingCart.db';

  static const table = 'cart_item';

  static const columnId = 'id';
  static const columnImg = 'img';
  static const columnName = 'name';
  static const columnStock = 'stock';
  static const columnCredit = 'credit';
  static const columnTk = 'tk';

  // static const columnQuantity = 'quantity';

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, dbName);
    Database database = await openDatabase(
      path,
      version: version,
      onConfigure: (db) {
        db.delete(table);
      },
      onCreate: _onCreate,
    );
    return database;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER NOT NULL PRIMARY KEY,
            $columnImg TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnStock INTEGER NOT NULL,
            $columnCredit FLOAT(2) NOT NULL,
            $columnTk FLOAT(2) NOT NULL
          )
          ''');
    // $columnQuantity INTEGER NOT NULL,
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database database = await init();
    return await database.insert(table, row,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database database = await init();
    return await database.query(table);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database database = await init();
    final results = await database.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(results) ?? 0;
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database database = await init();
    int id = row[columnId];
    return await database.update(
      table,
      row,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database database = await init();
    return await database.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}
