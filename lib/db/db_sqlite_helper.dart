import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:storeops_mobile/data/models/enrich_firebase_model.dart';

class DbSqliteHelper {
  static final DbSqliteHelper instance = DbSqliteHelper._init();
  static Database? db;

  DbSqliteHelper._init();

  Future<Database> get database async {
    if (db != null) return db!;
    db = await initDB('storeops.db');
    return db!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: createDB,
    );
  }

  Future createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        eventId INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT NOT NULL,
        accountNumber TEXT,
        storeId TEXT,
        eventType TEXT,
        silent INTEGER,
        groupId TEXT,
        timestamp INTEGER
      )
    ''');
     
    await db.execute('''
      CREATE TABLE enrich (
        enrichId INTEGER PRIMARY KEY AUTOINCREMENT,
        eventId INTEGER,
        uuid TEXT,
        category TEXT,
        description TEXT,
        epc TEXT,
        imageUrl TEXT,
        price TEXT,
        sku TEXT        
      )
    ''');

  }

  Future<int> saveEvents(Map<String, dynamic> row, List<EnrichFirebaseModel> enrich) async {
    final db = await instance.database;
    final id= await db.insert('events', row);

    for(var item in enrich){
      await saveEnrichData({
        "eventId": id,
        "uuid": row["uuid"],
        "category": item.category,
        "description": item.description,
        "epc": item.epc,
        "imageUrl": item.imageUrl,
        "price": item.price,
        "sku": item.sku,
      });
    }
    return id;
  }

  Future<int> saveEnrichData(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('enrich', row);
  }

 
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final db = await instance.database;
    return await db.query('events', orderBy: 'timestamp DESC');
  }

   Future<List<Map<String, dynamic>>> getEventsToday() async {
    
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startMillis = startOfDay.millisecondsSinceEpoch;

  
    final endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
    final endMillis = endOfDay.millisecondsSinceEpoch;

    final db = await instance.database;
    return await db.query(
      'events',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [startMillis, endMillis],
      orderBy: 'timestamp DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getEnrichData(int id) async {
    final db = await instance.database;
    return await db.query(
      'enrich',
      where: 'id = ?',
      whereArgs: [id], 
      // orderBy: 'timestamp DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getEnrichAll() async {
    final db = await instance.database;
    return await db.query('enrich');
  }


  // Future<List<Map<String, dynamic>>> getFilterEvents() async {
  //   final db = await instance.database;
  //   return await db.rawQuery('''
  //     SELECT e.*,en.*
  //     FROM events ev
  //     LEFT JOIN enrich en ON ev.id = en.id
  //   ''');
  // }

  Future<int> deleteEvents() async {
    final db = await instance.database;
    return await db.delete('events');
  }

  Future<int> deleteEnrich() async {
    final db = await instance.database;
    return await db.delete('enrich');
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Map<String, dynamic>> getEventsWithEnrich() async {
    final db = await instance.database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final startMillis = startOfDay.millisecondsSinceEpoch;

  
    final endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
    final endMillis = endOfDay.millisecondsSinceEpoch;


    final result = await db.rawQuery('''
      SELECT e.eventid, e.uuid, e.timestamp, e.groupId, e.silent,
            en.enrichId, en.description, en.epc, en.imageUrl
      FROM events e
      LEFT JOIN enrich en ON e.eventId = en.eventId
      
      ORDER BY e.timestamp DESC
    ''');
// WHERE e.timestamp BETWEEN '$startMillis' AND '$endMillis'
    final Map<String, dynamic> grouped = {};

    for (final row in result) {
      final id = row['eventId'].toString();
      final timestamp = row['timestamp'] as int;
      final finalTimestamp = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (!grouped.containsKey(id)) {
        grouped[id] = {
          "event": {
            "eventId": row["id"],
            "uuid": row["uuid"],
            "timestamp": finalTimestamp.toIso8601String(),
            "groupId": row["groupId"],
            "silent": row["silent"],
          },
          "epcs": <Map<String, dynamic>>[],
        };
      }

      if (row["enrichId"] != null) {
        grouped[id]["epcs"].add({
          "id": row["enrichId"],
          "description": row["description"],
          "epc": row["epc"],
          "imageUrl": row["imageUrl"],
        });
      }
    }

  return grouped;
}



}
