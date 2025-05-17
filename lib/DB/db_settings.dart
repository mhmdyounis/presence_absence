import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DbSettings {
  ///SINGELTON
  DbSettings._();

  static final DbSettings _dbSettings = DbSettings._();

  factory DbSettings() => _dbSettings;

  /// DB
  late Database database;

  Future<void> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'myApp_dbRoomFinally.sql');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('PRAGMA foreign_keys = ON');

        await db.execute("CREATE TABLE schools("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "school_name TEXT NOT NULL,"
            "educational_stage TEXT NOT NULL,"
            "total_students INTEGER NOT NULL"
            ")");

        await db.execute("CREATE TABLE classes("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "school_id INTEGER NOT NULL,"
            "student_count INTEGER NOT NULL,"
            "FOREIGN KEY (school_id) REFERENCES schools(id)"
            ")");

        await db.execute("CREATE TABLE absent("
            "id INTEGER PRIMARY KEY AUTOINCREMENT,"
            "school_id INTEGER NOT NULL,"
            "absence_count INTEGER NOT NULL,"
            "total_students INTEGER NOT NULL,"
            "attendance_count INTEGER NOT NULL,"
            "percentage_absence REAL,"
            "created_at Text,"
            "average_absence REAL,"
            "FOREIGN KEY (school_id) REFERENCES schools(id)"
            ")");

      },
    );
  }
}
