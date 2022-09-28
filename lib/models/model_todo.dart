import 'package:palestine_console/palestine_console.dart';

class Todo {
  int? id;
  late String title;
  late String description;

  Todo({
    this.id,
    required this.title,
    required this.description,
  });

  //* Flutter에서는 json을 주로 Map<String, dynamic>로 표현한다
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
    };
  }

  //* db에서 직접 가져올 때는 Map<dynamic, dynamic>
  Todo.fromMap(Map<dynamic, dynamic>? map) {
    id = map?["id"];
    title = map?["title"];
    description = map?["description"];
  }

  @override
  String toString() {
    return "id: $id, title: $title, description: $description";
  }
}
