import 'dart:io';
 
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart'; 

Future<Database> openDatabaseapp() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = app.path + '/' + 'smart_healt_data.db';
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
    print(records);
    return true;
  }
}
