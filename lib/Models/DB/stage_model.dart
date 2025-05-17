class Stage {
  int? id;
  String stageName;

  Stage({
    this.id,
    required this.stageName,
  });

  factory Stage.fromMap(Map<String, dynamic> map) {
    return Stage(
      id: map['id'],
      stageName: map['stage_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stage_name': stageName,
    };

  }
}