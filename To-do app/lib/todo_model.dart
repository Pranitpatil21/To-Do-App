class TodoModel {
  int? id; // Added id for SQLite primary key
  String title;
  String description;
  String date;

  TodoModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
    );
  }
}
