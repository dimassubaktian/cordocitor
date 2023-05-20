import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../models/qrcode_model.dart';
import 'dart:io';
import 'dart:async';

class QrCodeDbProvider {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, "qrcode.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE Qrcode(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            time TEXT
          )
        
        """);
      },
    );
  }

  Future<int> addItem(QrcodeModel item) async {
    //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert(
      "Qrcode", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<QrcodeModel>> fetchQrcode() async {
    //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Qrcode"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return QrcodeModel(
        id: maps[i]['id'] as int,
        text: maps[i]['text'] as String,
        time: maps[i]['time'] as String,
      );
    });
  }

  Future<int> deleteQrcode(int id) async {
    //returns number of items deleted
    final db = await init();

    int result = await db.delete("Qrcode", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
        );

    return result;
  }
}
