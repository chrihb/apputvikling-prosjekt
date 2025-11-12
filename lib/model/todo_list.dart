import 'package:flutter/foundation.dart';

import 'todo_item.dart';

// Model for a list
class TodoList {
  String id;
  String name;
  List<TodoItem> items;

  TodoList(this.name, [List<TodoItem>? items])
    : id = UniqueKey().toString(),
      items = items ?? [];

  TodoList.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      items = (json['items'] as List<dynamic>)
          .map((e) => TodoItem.fromJson(e))
          .toList();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'items': items.map((e) => e.toJson()).toList(),
  };
}
