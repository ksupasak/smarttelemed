import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smarttelemed/station/provider/provider.dart'; 

Future<Database> openDatabaseapp() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = app.path + '/' + 'smart_healt_data.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future deletedatabase() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('smart_healt');
  await store.drop(db);
}

Future<bool> Showdatabasedatauserapp() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('smart_healt');
  var records = await store.find(db);
  print(records);
  if ((records.length == 0)) {
    return false;
  } else {
    return true;
  }
}

Future<void> addDataInfoToDatabase(DataProvider data) async {
  deletedatabase();
  final db = await openDatabaseapp();
  final store = intMapStoreFactory.store('smart_healt');
  final key = await store.add(db, {
    'name_hospital': data.name_hospital,
    'platfromURL': data.platfromURL,
    'care_unit_id': data.care_unit_id,
    'device': '1234',
    'passwordsetting': data.passwordsetting,
    'care_unit': data.care_unit,
    'myapp': data.myapp,
  });

  await db.close();
}

Future<void> updateDataInfoToDatabase(DataProvider data) async {
  final db = await openDatabaseapp();
  final store = intMapStoreFactory.store('smart_healt');
  final key = await store.update(db, {
    'name_hospital': data.name_hospital,
    'platfromURL': data.platfromURL,
  });
  await db.close();
}

Future<List<RecordSnapshot<int, Map<String, Object?>>>> getAllData() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('smart_healt');
  var records = await store.find(db);

  return records;
}



//////////////
Future<Database> openDatabaseMinMax() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = '${app.path}/minmax.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}
Future<List<RecordSnapshot<int, Map<String, Object?>>>> getMinMax() async {
  Database db = await openDatabaseMinMax();
  var store = intMapStoreFactory.store('minmax');
  var records = await store.find(db);
  return records;
}
Future<void> addDataMinMax(Map<String, Object?> data) async {
 deleteaMinMax();
  final db = await openDatabaseMinMax();
  final store = intMapStoreFactory.store('minmax');
  final key = await store.add(db, data);

  await db.close();
}
Future deleteaMinMax() async {
  Database db = await openDatabaseMinMax();
  var store = intMapStoreFactory.store('minmax');
  await store.drop(db);
}
////
 Future<Database> openDatabasePrinter() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = '${app.path}/printer.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}
Future<List<RecordSnapshot<int, Map<String, Object?>>>> getPrinter() async {
  Database db = await openDatabasePrinter();
  var store = intMapStoreFactory.store('printer');
  var records = await store.find(db);
  return records;
}
Future<void> addDataPrinter(Map<String, Object?> data) async {
 deleteaPrinter();
  final db = await  openDatabasePrinter();
  final store = intMapStoreFactory.store('printer');
  final key = await store.add(db, data);

  await db.close();
}
Future deleteaPrinter() async {
  Database db = await openDatabaseMinMax();
  var store = intMapStoreFactory.store('printer');
  await store.drop(db);
}
