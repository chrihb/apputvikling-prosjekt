import 'package:flutter/foundation.dart';

// Model for a singular item entry
class TodoItem {
  String id;
  String label;
  bool done;

  TodoItem(this.label, this.done) : id = UniqueKey().toString();

  TodoItem.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      label = json['label'],
      done = json['done'];

  Map<String, dynamic> toJson() => {'id': id, 'label': label, 'done': done};
}
