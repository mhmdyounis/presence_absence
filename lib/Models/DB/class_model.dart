class ClassRoom {
  int? id;
  int schoolId;
  int stageId;
  String className;
  int studentCount;

  ClassRoom({
    this.id,
    required this.schoolId,
    required this.stageId,
    required this.className,
    required this.studentCount,
  });

  factory ClassRoom.fromMap(Map<String, dynamic> map) {
    return ClassRoom(
      id: map['id'],
      schoolId: map['school_id'],
      stageId: map['stage_id'],
      className: map['class_name'],
      studentCount: map['student_count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'school_id': schoolId,
      'stage_id': stageId,
      'class_name': className,
      'student_count': studentCount,
    };
  }
}