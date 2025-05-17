import 'package:presence_absence/DB/Controllers/operation_controller.dart';
import 'package:presence_absence/DB/db_settings.dart';
import 'package:presence_absence/Models/DB/school_model.dart';
import 'package:presence_absence/enum.dart';
import 'package:sqflite/sqflite.dart';

class SchoolDbController with DbOperation<SchoolModel> {
  final Database _database = DbSettings().database;

  @override
  Future<int?> create(SchoolModel schoolModel) async {
    var result = await _database.insert(
      AppTable.schools.name,
      schoolModel.toMap(),
    );
    return result > 0 ? result : null;
  }

  @override
  Future<bool> delete(schoolModel) async {
    var count = await _database.delete(
      AppTable.schools.name,
      where: 'id = ?',
      whereArgs: [schoolModel.id],
    );
    return count > 0;
  }


  Future<bool> clear() async {
    var count = await _database.delete(
      AppTable.schools.name,
    );
    return count > 0;
  }

  @override
  Future<List<SchoolModel>> read() async {
    List result = await _database.rawQuery(
      "SELECT * FROM ${AppTable.schools.name}",
    );
    List<SchoolModel> x = result.map((e) => SchoolModel.fromMap(e)).toList();
    return x;
  }

  @override
  Future<SchoolModel?> show(schoolModel) async {
    var result = await _database.rawQuery(
      "SELECT * FROM ${AppTable.schools.name} WHERE id = '${schoolModel.id}' ",
    );
    return result.isNotEmpty ? SchoolModel.fromMap(result.first) : null;
  }

  @override
  Future<bool> update(schoolModel) async {
    var count = await _database.update(
      AppTable.schools.name,
      schoolModel.toMap(),
      where: 'id = ?',
      whereArgs: [schoolModel.id],
    );
    return count > 0;
  }
}
