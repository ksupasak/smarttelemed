import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smarttelemed/apps/myapp/provider/provider.dart';

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
//////////////////////

Future<Database> openDatabaseInOutHospital() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = '${app.path}/InOutHospital.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future<List<RecordSnapshot<int, Map<String, Object?>>>>
getInOutHospital() async {
  Database db = await openDatabaseInOutHospital();
  var store = intMapStoreFactory.store('InOutHospital');
  var records = await store.find(db);

  return records;
}

Future<void> addDataInOutHospital(Map data) async {
  deleteInOutHospital();
  final db = await openDatabaseInOutHospital();
  final store = intMapStoreFactory.store('InOutHospital');
  final key = await store.add(db, {
    'in_hospital': data['in_hospital'],
    'requirel_id_card': data['requirel_id_card'],
    'require_VN': data['require_VN'],
    'text_no_idcard': data['text_no_idcard'],
    'text_no_hn': data['text_no_hn'],
    'text_no_vn': data['text_no_vn'],
  });

  await db.close();
}

Future deleteInOutHospital() async {
  Database db = await openDatabaseInOutHospital();
  var store = intMapStoreFactory.store('InOutHospital');
  await store.drop(db);
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
  final db = await openDatabasePrinter();
  final store = intMapStoreFactory.store('printer');
  final key = await store.add(db, data);

  await db.close();
}

Future deleteaPrinter() async {
  Database db = await openDatabaseMinMax();
  var store = intMapStoreFactory.store('printer');
  await store.drop(db);
}
