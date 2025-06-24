// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';

Future<Database> openDatabaseapp() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = '${app.path}/smart_healt_data.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future<bool> showDataBaseDatauserApp() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('smart_healt');
  var records = await store.find(db);
  if ((records.length == 0)) {
    return false;
  } else {
    debugPrint(records.toString());
    return true;
  }
}

Future<List<RecordSnapshot<int, Map<String, Object?>>>> getAllData() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('smart_healt');
  var records = await store.find(db);

  return records;
}

/////////////////////////////////////////////////////

Future<void> addDataInfoToDatabase(DataProvider data) async {
  deletedatabase();
  final db = await openDatabaseapp();
  final store = intMapStoreFactory.store('smart_healt');
  await store.add(db, {
    'myapp': data.app,
    'name_hospital': data.name_hospital,
    'platfromURL': data.platfromURL,
    'platfromURLGateway': data.platfromURLGateway,
    'care_unit_id': data.care_unit_id,
    'passwordsetting': data.password,
    'care_unit': data.care_unit,
  });

  await db.close();
}

Future deletedatabase() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('smart_healt');
  await store.drop(db);
}

/////////////////////////////////////////////////////
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
  await store.add(db, data);

  await db.close();
}

Future deleteaMinMax() async {
  Database db = await openDatabaseMinMax();
  var store = intMapStoreFactory.store('minmax');
  await store.drop(db);
}

/////////////////////////////////////////////////////

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
  await store.add(db, {
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

/////////////////////////////////////////////////////

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
  await store.add(db, data);

  await db.close();
}

Future deleteaPrinter() async {
  Database db = await openDatabaseMinMax();
  var store = intMapStoreFactory.store('printer');
  await store.drop(db);
}
////////////////////////////

Future<Database> openLanguageApp() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = '${app.path}/languageApp.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future<List<RecordSnapshot<int, Map<String, Object?>>>> getLanguageApp() async {
  Database db = await openLanguageApp();
  var store = intMapStoreFactory.store('languageApp');
  var records = await store.find(db);
  return records;
}

Future<void> addLanguageApp(Map<String, Object?> data) async {
  deleteaLanguageApp();
  final db = await openLanguageApp();
  final store = intMapStoreFactory.store('languageApp');
  await store.add(db, data);
  await db.close();
}

Future deleteaLanguageApp() async {
  Database db = await openLanguageApp();
  var store = intMapStoreFactory.store('languageApp');
  await store.drop(db);
}




////////////////////////////