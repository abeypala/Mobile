import 'dart:async';
import 'dart:io';
import 'package:kaladasava/models/biodata.dart';
import 'package:kaladasava/models/device.dart';
import 'package:kaladasava/models/eventdata.dart';
import 'package:kaladasava/models/locality.dart';
import 'package:kaladasava/models/rawplanet.dart';
import 'package:kaladasava/models/riseset.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "kaladasava.local.db");
    print(path);

// Delete the database
//await deleteDatabase(path);


    //path = '../TestDB.db';
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          
      await db.execute('''
        CREATE TABLE "LinkedAccounts" (
          "id"	TEXT NOT NULL,
          "email"	TEXT NOT NULL,
          PRIMARY KEY ("id")
        );
      ''');  
          
      await db.execute('''
        CREATE TABLE "Device" (
          "id"	TEXT NOT NULL,
          "name"	TEXT NOT NULL,
          "version"	TEXT NOT NULL,
          "physical"	TEXT NOT NULL,
          "ts"	INTEGER
        );
      ''');  
      
      await db.execute('''
        CREATE TABLE "DeviceLocation" (
          "lat"	REAL,
          "lng"	REAL,
          "alt"	REAL,
          "speed"	REAL,
          "acu"	REAL,
          "loc"	TEXT,
          "ts"	INTEGER
        );
      ''');     

      await db.execute('''
        CREATE TABLE "Planets" (
          "pid"     TEXT,
          "planet"  INTEGER,
          "longitude" REAL,
          "speed"	REAL,
          "magnitude"	REAL,
          PRIMARY KEY ("pid", "planet")
        );
      ''');    

      await db.execute('''
        CREATE TABLE "Charts" (
          "pid"     TEXT,
          "chart"  INTEGER,
          "planet"  INTEGER,
          "house"  INTEGER,
          PRIMARY KEY ("pid", "chart", "planet")
        );
      ''');   

      await db.execute('''
        CREATE TABLE "RiseSet" (
          "pid"     TEXT,
          "planet"     INTEGER,
          "fs"  INTEGER,
          "rs"  INTEGER,
          "nr"  INTEGER,
          "rise"  TEXT,
          "set"   TEXT,
          PRIMARY KEY ("pid", "planet")
        );
      ''');

      await db.execute('''
        CREATE TABLE "BioData" (
          "pid"	TEXT NOT NULL,
          "uid"	TEXT NOT NULL,
          "name"	TEXT NOT NULL,
          "tob"	TEXT NOT NULL,
          "location"	TEXT NOT NULL,
          "cc"	TEXT NOT NULL,
          "lat"	REAL NOT NULL,
          "lng"	REAL NOT NULL,
          "kin"	 INTEGER DEFAULT 0,
          "gender"	 INTEGER DEFAULT 0,
          "utcoff"	INTEGER NOT NULL,
          "lagna"	 INTEGER DEFAULT 0,
          "unixts"	 INTEGER DEFAULT 0,
          "editcount" INTEGER DEFAULT 0,
          "favourite" INTEGER DEFAULT 0,
          "fts" INTEGER DEFAULT 0,
          "ts"	INTEGER NOT NULL,
          PRIMARY KEY("pid")
        );
      ''');
    //editcount max 3?


    });
  }

createDevice(Device d) async {
  final db = await database;
  var raw = await db.rawInsert("REPLACE Into Device (id,name,version,physical,ts) VALUES (?,?,?,?,?)",[d.id,d.name,d.version,d.physical,d.ts]);
  return raw;
}  

Future<Device> readDevice(int sinceepoch) async {
  final _db = await database;
  var _res = await _db.rawQuery("SELECT id,name,version,physical,ts FROM Device WHERE ts>? LIMIT 1",[sinceepoch]);
return (_res.length==1)? Device(id:_res[0]['id'].toString(),name:_res[0]['name'].toString(),version:_res[0]['version'],physical:_res[0]['physical'].toString(),ts:_res[0]['ts']):null;
}  

createDeviceLocation(Locality d) async {
  final db = await database;
  var raw = await db.rawInsert("REPLACE Into DeviceLocation (lat,lng,alt,speed,acu,loc,ts) VALUES (?,?,?,?,?,?,?)",[d.latitude,d.longitude,d.altitude,d.speed,d.accuracy,d.formattedaddress,d.timestamp]);
  return raw;
} 

Future<Locality> readDeviceLocation(int sinceepoch) async {
  final _db = await database;
  var _res = await _db.rawQuery("SELECT lat,lng,alt,speed,acu,loc,ts FROM DeviceLocation WHERE ts>? LIMIT 1",[sinceepoch]);
return (_res.length==1)? Locality(latitude:_res[0]['lat'],longitude:_res[0]['lng'],altitude:_res[0]['alt'],speed:_res[0]['speed'],accuracy:_res[0]['acu'],address: _res[0]['loc'],timestamp:_res[0]['ts']):null;
}  

//Create and Update
Future createBioData(BioData b) async {
  final db = await database;
  var raw = await db.rawInsert("REPLACE Into BioData (pid,uid,name,tob,location,cc,lat,lng,kin,gender,utcoff,lagna,unixts,editcount,favourite,fts,ts)"
      " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",[b.pid,b.uid,b.name,DateFormat("yyyy-MM-dd HH:mm:ss").format(b.tob),b.location,b.cc,b.lat,b.lng,b.kin,b.gender,b.utcoff,b.lagna,b.unixts,b.editcount,b.favourite,b.fts,b.ts]);
return raw;
}

Future updateBioDataFavourite(Map<String,dynamic> m) async {
  final db = await database;
  var raw = await db.rawUpdate("UPDATE BioData SET favourite=?,fts=? WHERE pid=? AND uid=?;",[m['favourite'],m['fts'],m['pid'],m['uid']]);
return raw;
}

Future<List<BioData>> readBioData() async {
final db = await database;
var res = await db.rawQuery("SELECT * FROM BioData ORDER BY favourite DESC,kin ASC;");
return res.isNotEmpty ? res.map((c) => BioData.fromJson(c)).toList() : [];
}

Future deleteBioData(String pid) async {
final db = await database;
var raw = await db.rawDelete("DELETE FROM BioData WHERE pid = ? ;",[pid]);
return raw;
}

Future<int> countBioData() async {
   final db = await database; 
   return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM BioData'));
}

Future<List<int>> readBioDataInit(String uid) async {
final _db = await database;
var res =  await _db.rawQuery("SELECT ts FROM BioData WHERE uid = ?;",[uid]);
return res.isNotEmpty ? res.map((c) => c['ts'] as int).toList() : [];
}

Future<List<int>> readBioDataFav(String uid) async {
final _db = await database;
var res =  await _db.rawQuery("SELECT fts FROM BioData WHERE favourite = 1 AND uid = ?;",[uid]);
return res.isNotEmpty ? res.map((c) => c['fts'] as int).toList() : [];
}

Future<List<BioData>> readBioData2() async {
final db = await database;
var res = await db.rawQuery("SELECT pid,uid,name,tob,location,lat,lng,kin,gender,utcoff,lagna,editcount,favourite,fts,ts FROM BioData ORDER BY kin;");
List<BioData> list =
    res.isNotEmpty ? res.map((c) => BioData.fromJson(c)).toList() : [];
return list;
}

createPlanets(List<RawPlanet> pl, BioData b) async {
  final db = await database;
  Batch batch = db.batch();
 pl.asMap().forEach((index, value) => batch.insert('Planets',{'pid':b.pid,'planet':index,'longitude':value.longitude,'speed':value.speed,'magnitude':value.magnitude},conflictAlgorithm: ConflictAlgorithm.replace));
 var results = await batch.commit();
return results;
}  

createRiseSet(List<Riseset> rl, BioData b) async {
  final db = await database;
  Batch batch = db.batch();
  rl.asMap().forEach((index, value) => batch.insert('RiseSet',value.todbMap(index, value, b.pid),conflictAlgorithm: ConflictAlgorithm.replace));
  var results = await batch.commit();
return results;
}  

createChart(List<EventData> ljd){
ljd.forEach((jd) { 

    if(jd != null)if(jd.event != null)if(jd.event.pid != null){
      createBioData(jd.event);
      createPlanets(jd.planets,jd.event);
      createRiseSet(jd.riseset,jd.event);
  }
});
}

} 