class Task {
  String title;
  String description;
  DateTime deadline;
  DateTime? exptectedTime;
  int priority;
  String status;
  DateTime createdAt;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    this.exptectedTime,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  Task copyWith({
    String? title,
    String? description,
    DateTime? deadline,
    DateTime? exptectedTime,
    int? priority,
    String? status,
    DateTime? createdAt,
  }) =>
      Task(
        title: title ?? this.title,
        description: description ?? this.description,
        deadline: deadline ?? this.deadline,
        exptectedTime: exptectedTime ?? this.exptectedTime,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        title: json["title"],
        description: json["description"],
        deadline: DateTime.parse(json["deadline"]),
        exptectedTime: json["exptectedTime"] == null
            ? null
            : DateTime.parse(json["exptectedTime"]),
        priority: json["priority"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toMap() => {
        "title": title,
        "description": description,
        "deadline": deadline.toIso8601String(),
        "exptectedTime": exptectedTime?.toIso8601String(),
        "priority": priority,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
      };
}

enum TaskPriority { low, medium, high, critical }

enum TaskStatus { incomplete, ongoing, complete }
