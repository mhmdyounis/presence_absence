
import 'package:presence_absence/DB/Controllers/operation_controller.dart';
import 'package:presence_absence/DB/db_settings.dart';
import 'package:presence_absence/Models/DB/absence_model.dart';
import 'package:presence_absence/enum.dart';
import 'package:sqflite/sqflite.dart';

class AbsenceDbController with DbOperation<AbsentModel> {
  final Database _database = DbSettings().database;

  @override
  Future<int?> create(AbsentModel absenceModel) async {
    var result = await _database.insert(
      AppTable.absent.name,
      absenceModel.toMap(),
    );
    return result > 0 ? result : null;
  }


  Future<List<AbsentModel>> schoolAbsencesByDate (AbsentModel absentModel)async{
    List<Map<String, dynamic>> listofMap = await _database.query(AppTable.absent.name,
        where: 'school_id = ?' ,
        whereArgs: [absentModel.schoolId],
        orderBy: 'created_at DESC' ,
    ) ;
    return listofMap.map((e) => AbsentModel.fromMap(e),).toList() ;
  }

  @override
  Future<bool> delete(model) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<AbsentModel>> read() async{
    List<Map<String, dynamic>> result = await _database.rawQuery(
      "SELECT * FROM ${AppTable.absent.name}",
    );
    return result.map((e) => AbsentModel.fromMap(e),).toList() ;
  }

  @override
  Future<AbsentModel> show(model) {
    // TODO: implement show
    throw UnimplementedError();
  }

  @override
  Future<bool> update(AbsentModel absenceModel) async {
    int result = await _database.update(
      AppTable.absent.name,
      absenceModel.toMap(),
      where: 'id = ?',
      whereArgs: [absenceModel.id],
    );
    return result > 0 ;
  }
}
