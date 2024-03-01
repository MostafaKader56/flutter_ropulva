class TaskModel {
  String? id;
  String title;
  bool isDone;
  DateTime dateTime;
  TaskModel({
    this.id,
    required this.title,
    this.isDone = false,
    required this.dateTime,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        title: json['title'],
        isDone: json['isDone'],
        dateTime: DateTime.parse(json['dateTime']).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'isDone': isDone,
        'dateTime': dateTime.toUtc().toIso8601String(),
      };
}
