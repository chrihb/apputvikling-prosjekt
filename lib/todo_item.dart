import 'package:flutter/foundation.dart';

class TodoItem {
  final String id = UniqueKey().toString();
  String label;
  bool done;

  TodoItem(this.label, this.done);
}