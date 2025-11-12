import 'todo_list.dart';

class TodoData {
  List<TodoList> lists;
  String? currentListId;

  TodoData({
    required this.lists,
    this.currentListId,
  });

  Map<String, dynamic> toJson() => {
    'currentListId': currentListId,
    'lists': lists.map((e) => e.toJson()).toList(),
  };

  factory TodoData.fromJson(Map<String, dynamic> json) => TodoData(
    currentListId: json['currentListId'],
    lists: (json['lists'] as List<dynamic>)
        .map((e) => TodoList.fromJson(e))
        .toList(),
  );
}
