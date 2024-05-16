class Task {
  String title;
  String? description;
  DateTime? deadline;
  int? exptectedDurationInMin;
  int priority;
  String status;
  DateTime createdAt;

  Task({
    required this.title,
    this.description,
    this.deadline,
    this.exptectedDurationInMin,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  Task copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    int? exptectedDurationInMin,
    int? priority,
    String? status,
    DateTime? createdAt,
  }) =>
      Task(
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        exptectedDurationInMin:
            exptectedDurationInMin ?? this.exptectedDurationInMin,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        title: json["title"],
        description: json["description"],
        deadline:
            json["deadline"] == null ? null : DateTime.parse(json["deadline"]),
        exptectedDurationInMin: json["exptectedDurationInMin"],
        priority: json["priority"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "deadline": deadline?.toIso8601String(),
        "exptectedDurationInMin": exptectedDurationInMin,
        "priority": priority,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
      };
}
