import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../data/model/shopping_item_model.dart';

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
  static const columnQuantity = 'quantity';

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
    await db.execute(""" CREATE TABLE $table (
            $columnId INTEGER NOT NULL PRIMARY KEY,
            $columnImg TEXT NOT NULL,
            $columnName TEXT NOT NULL,
            $columnStock INTEGER NOT NULL,
            $columnCredit FLOAT(2) NOT NULL,
            $columnTk FLOAT(2) NOT NULL,
            $columnQuantity INTEGER NOT NULL
          ) """);
  }

  Future<void> dbInsert({required ShoppingItemModel item}) async {
    Database database = await init();
    int quantity = 1;


    bool itemExists = await _itemExistsInDatabase(database, table, item.id);
    int totalQuantity = await getTotalQuantity();

    if (!itemExists && totalQuantity<3) {
      // If the item does not exist, insert a new row
      await database.rawInsert("""
      INSERT INTO $table ($columnId, $columnImg, $columnName, $columnStock, $columnCredit, $columnTk, $columnQuantity) 
      VALUES (?, ?, ?, ?, ?, ?, ?)
    """, [
        item.id,
        item.img,
        item.name,
        item.stock,
        item.credit,
        item.tk,
        quantity
      ]);

      print('Successfully inserted item with ID ${item.id}');
    } else if(totalQuantity<3){
      // If the item exists, update its quantity
      await database.rawUpdate("""
      UPDATE $table SET $columnQuantity = $columnQuantity + ? WHERE $columnId = ?
    """, [quantity, item.id]);

      print('Successfully updated quantity for item with ID ${item.id}');
    }
  }

  Future<bool> _itemExistsInDatabase(
      Database database, String table, int itemId) async {
    var result = await database.rawQuery("""
    SELECT COUNT(*) FROM $table WHERE $columnId = ?
  """, [itemId]);

    int count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  Future<int> getTotalQuantity() async {
    Database database = await init();

    var result = await database.rawQuery("""
    SELECT SUM($columnQuantity) FROM $table
  """);

    int totalQuantity = Sqflite.firstIntValue(result) ?? 0;
    return totalQuantity;
  }

  Future<Map<int, int>> getIdQuantityMap() async {
    Database database = await init();

    var result = await database.rawQuery("""
    SELECT $columnId, $columnQuantity FROM $table
  """);

    Map<int, int> idQuantityMap = {};

    if (result.isNotEmpty) {
      for (var row in result) {
        int itemId = row[columnId] as int;
        int quantity = row[columnQuantity] as int;
        idQuantityMap[itemId] = quantity;
      }
    }

    return idQuantityMap;
  }


  Future<List<int>> getAllItems() async {
    Database database = await init();

    var result = await database.rawQuery("""
    SELECT $columnId FROM $table
  """);
    List<int> items = [];
    result.forEach((element) {
      items.add(int.parse(element['id'].toString()));
    });
    return items;
  }

  Future<void> removeItemAndUpdateQuantity({required int itemId}) async {
    Database database = await init();

    var result = await database.rawQuery("""
    SELECT SUM($columnQuantity) FROM $table WHERE $columnId = ?
  """, [itemId]);

    int currentQuantity = Sqflite.firstIntValue(result) ?? 0;

    if (currentQuantity == 1) {
      await database.rawDelete("""
      DELETE FROM $table WHERE $columnId = ?
    """, [itemId]);

      print('Successfully removed item with ID $itemId from the database.');
    } else {
      await database.rawUpdate("""
      UPDATE $table SET $columnQuantity = $columnQuantity - 1 WHERE $columnId = ?
    """, [itemId]);

      print('Successfully decreased quantity for item with ID $itemId.');
    }
  }
}
