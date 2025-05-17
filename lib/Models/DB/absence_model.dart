class AbsentModel {
  int? id;
  int schoolId;
  int absenceCount;
  int attendanceCount;
  double? percentageOfAbsenc ;
  double? averageAbsence ;
  String? createdAt ;
  int totalStudent ;


  AbsentModel({
    this.id,
    required this.schoolId,
    required this.absenceCount,
    required this.attendanceCount,
    required this.totalStudent ,
    this.percentageOfAbsenc ,
    this.averageAbsence ,
    this.createdAt
  });

  factory AbsentModel.fromMap(Map<String, dynamic> map) {
    return AbsentModel(
      id: map['id'],
      schoolId: map['school_id'],
      absenceCount: map['absence_count'],
      attendanceCount: map['attendance_count'],
      percentageOfAbsenc: map['percentage_absence'] ,
      averageAbsence: map['average_absence'] ,
      createdAt: map["created_at"],
        totalStudent : map["total_students"] ?? 0
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school_id': schoolId,
      'absence_count': absenceCount,
      'attendance_count': attendanceCount,
      'percentage_absence' : percentageOfAbsenc ,
      'average_absence' : averageAbsence ,
      'created_at' : createdAt,
      'total_students' : totalStudent
    };
  }
}