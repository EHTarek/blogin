import 'package:blogin/services/logs.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class NotificationDbHelper {
  static const int version = 1;
  static const dbName = 'Notifications.db';

  static const table = 'received_notification';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnBody = 'body';
  static const columnPayload = 'payload';

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, dbName);
    Database database = await openDatabase(
      path,
      version: version,
      /* onConfigure: (db) async {
       await db.delete(table);
      },*/
      onCreate: _onCreate,
    );
    return database;
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(""" CREATE TABLE $table (
            $columnId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            $columnTitle TEXT NOT NULL,
            $columnBody TEXT NOT NULL,
            $columnPayload TEXT NOT NULL
          ) """);
  }

  Future<void> dbInsert({required RemoteMessage message}) async {
    Database database = await init();

    // If the item does not exist, insert a new row
    await database.rawInsert("""
      INSERT INTO $table ($columnTitle, $columnBody, $columnPayload) 
      VALUES (?, ?, ?)
    """, [
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      message.data.toString()
    ]);

    Log('Successfully inserted item');
  }

  Future<int> getTotalQuantity() async {
    Database database = await init();

    var result = await database.rawQuery("""
    SELECT COUNT(*) FROM $table
    """);

    int totalQuantity = Sqflite.firstIntValue(result) ?? 0;

    return totalQuantity;
  }

  Future<List<Map<String, dynamic>>> getAllNotification() async {
    Database database = await init();

    var result = await database.rawQuery("""
    SELECT * FROM $table
  """);
    List<Map<String, dynamic>> items = [];
    for (var element in result) {
      final map = {
        columnId: element[columnId],
        columnTitle: element[columnTitle],
        columnBody: element[columnBody],
        columnPayload: element[columnPayload]
      };
      items.add(map);
    }
    return items;
  }

  Future<void> removeItem({required int itemId}) async {
    Database database = await init();

    await database.rawDelete("""
      DELETE FROM $table WHERE $columnId = ?
    """, [itemId]);

    print('Successfully removed item with ID $itemId from the database.');
  }
}
