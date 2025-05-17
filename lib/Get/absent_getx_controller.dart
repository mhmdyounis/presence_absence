import 'package:get/get.dart';
import 'package:presence_absence/Cache/cache_controller.dart';
import 'package:presence_absence/DB/Controllers/absence_db_controller.dart';
import 'package:presence_absence/Models/DB/absence_model.dart';

class AbsentGetxController extends GetxController {
  static AbsentGetxController get to => Get.find<AbsentGetxController>();
  RxBool loading = false.obs;

  RxList<AbsentModel> absents = <AbsentModel>[].obs;

  RxList<AbsentModel> schoolAbsencesByDate = <AbsentModel>[].obs;


  Future<void> read() async {
    try {
      loading.value = true ;
      absents.value = await AbsenceDbController().read();
    } finally {
      loading.value = false ;
    }
  }

  Future<int?> create(AbsentModel absentModel) async {
    int? result = await AbsenceDbController().create(absentModel);
    if (result != null) {
      absents.add(absentModel);
    }
    return result;
  }


  Future<bool> updateAbsent(AbsentModel absentModel) async {
    bool result = await AbsenceDbController().update(absentModel);
    if (result) {
      int index = absents.indexWhere((element) =>
      absentModel.id == element.id,);
      if (index != -1) {
        absents.removeAt(index);
        absents.insert(index, absentModel);
      }
    }
    return result;
  }


  Future<void> getSchoolAbsencesByDate(AbsentModel absentModel) async {
    schoolAbsencesByDate.value =
    await AbsenceDbController().schoolAbsencesByDate(absentModel);
  }
}