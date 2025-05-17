class SchoolModel {
  int? id;
  String schoolName = "";
  String educationalStage = "";
  int totalStudents = 0;
  SchoolModel({
    this.id,
    required this.schoolName,
    required this.educationalStage,
    required this.totalStudents,
  });
  SchoolModel.first() ;

   SchoolModel.fromMap(Map<String, dynamic> map) {
      id =  map['id'] ;
      schoolName= map['school_name'];
      educationalStage = map['educational_stage'] ;
      totalStudents = map['total_students'] ;

  }

  Map<String, dynamic> toMap() {
     Map<String ,dynamic> map = {
       'id': id,
       'school_name': schoolName,
       'educational_stage': educationalStage,
       'total_students': totalStudents
     } ;
   return map ;
  }
}