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
        idEvent INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT NOT NULL UNIQUE,
        accountNumber TEXT,
        storeId TEXT,
        eventId TEXT,
        silent INTEGER,
        groupId TEXT,
        timestamp INTEGER
      )
    ''');
     
    await db.execute('''
      CREATE TABLE enrich (
        enrichId INTEGER PRIMARY KEY AUTOINCREMENT,
        idEvent INTEGER,
        uuid TEXT,
        category TEXT,
        description TEXT,
        epc TEXT,
        imageUrl TEXT,
        price TEXT,
        sku TEXT,
        gtin TEXT    
      )
    ''');

  }

  Future<int> saveEvents(Map<String, dynamic> row, List<EnrichFirebaseModel> enrich) async {
    final db = await instance.database;
    final id= await db.insert('events', row, conflictAlgorithm: ConflictAlgorithm.ignore);
    
    if(id > 0){
      for(var item in enrich){
        await saveEnrichData({
          "IdEvent": id,
          "uuid": row["uuid"],
          "category": item.category,
          "description": item.description,
          "epc": item.epc,
          "imageUrl": item.imageUrl,
          "price": item.price,
          "sku": item.sku,
          "gtin": item.gtin,
        });
      }
    }
    return id;
  }



  Future<int> saveEnrichData(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('enrich', row);
  }

 

  Future<List<Map<String, dynamic>>> getEventsByDate(bool sold, DateTime startDate, DateTime endDate) async {
    final startMillis = startDate.millisecondsSinceEpoch;
    final endMillis = endDate.millisecondsSinceEpoch;

    final db = await instance.database;
    if (sold){
      return await db.query(
        'events',
        where: 'timestamp BETWEEN ? AND ? AND eventId IN("rfid_alarm", "rfid_sale")',
        whereArgs: [startMillis, endMillis],
        orderBy: 'timestamp DESC',
      );
    }
    else{
      return await db.query(
        'events',
        where: 'timestamp BETWEEN ? AND ? AND eventId = "rfid_alarm"',
        whereArgs: [startMillis, endMillis],
        orderBy: 'timestamp DESC',
      );
    }
  }

  Future<List<Map<String, dynamic>>> getEnrichData(int id, String uuid) async {
    final db = await instance.database;
    final query= await db.query(
      'enrich',
      where: 'idEvent = ?',
      whereArgs: [id], 
    );

    return query;
  }


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

  


}
