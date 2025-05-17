import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:presence_absence/DB/Controllers/school_db_controller.dart';
import 'package:presence_absence/Models/DB/school_model.dart';

class SchoolGetxController extends GetxController {
  static SchoolGetxController get to => Get.find<SchoolGetxController>();

  RxList<SchoolModel> schools = <SchoolModel>[].obs;
  Rx<SchoolModel> schoolMo = SchoolModel.first().obs ;

  RxBool loading = false.obs;

  RxInt id = 0.obs;
  Future<int?> create(SchoolModel schoolModel) async {
    int? result = await SchoolDbController().create(schoolModel);
    if(result != null) {
      schools.add(schoolModel);
      return result;
    }
    return null ;
  }


  Future<void> show(SchoolModel schoolModel)async{
    SchoolModel? school = await SchoolDbController().show(schoolModel) ;
    if(school != null){
      schoolMo.value = school ;
    }

  }

  Future<void> read() async {
    try {
      loading.value = true;
      schools.value = await SchoolDbController().read();
    } finally {
      loading.value = false;
    }
  }



  Future<bool> updateSchool(SchoolModel schoolModel) async {
    bool result = await SchoolDbController().update(schoolModel);
    if (result) {
      print("succses") ;
      int index = schools.indexWhere((element) => schoolModel.id == element.id);
      if(index != -1){
        schools.removeAt(index) ;
        schools.insert(index, schoolModel) ;
      }
    }
    else
      {print("false") ; }
    return result;
  }

  Future<void> delete(SchoolModel schoolModel) async {
    bool result = await SchoolDbController().delete(schoolModel);
    if (result) {
      print("delete is done");
    }
  }
}
