import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smarttelemed/myapp/provider/provider.dart';

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
    'myapp': data.app,
    'name_hospital': data.name_hospital,
    'platfromURL': data.platfromURL,
    'care_unit_id': data.care_unit_id,
    'passwordsetting': data.password,
    'care_unit': data.care_unit,
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

Future<Database> openDatabasedevice() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = app.path + '/' + 'smart_healt_device.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future deletedevice() async {
  Database db = await openDatabasedevice();
  var store = intMapStoreFactory.store('smart_healt_device');
  await store.drop(db);
}

Future<List<RecordSnapshot<int, Map<String, Object?>>>> getdevice() async {
  Database db = await openDatabasedevice();
  var store = intMapStoreFactory.store('smart_healt_device');
  var records = await store.find(db);

  return records;
}

Future deletedatabaseUser() async {
  Database db = await openDatabaseappUser();
  var store = intMapStoreFactory.store('data_user_smart_healt');
  await store.drop(db);
}

Future<Database> openDatabaseappUser() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = app.path + '/' + 'data_user_smart_healt.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future<List<RecordSnapshot<int, Map<String, Object?>>>> getAllDataUser() async {
  Database db = await openDatabaseappUser();
  var store = intMapStoreFactory.store('data_user_smart_healt');
  var records = await store.find(db);

  return records;
}
