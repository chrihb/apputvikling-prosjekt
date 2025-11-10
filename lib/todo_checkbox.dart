import 'package:apputvikling_prosjekt/todo_item.dart';
import 'package:flutter/material.dart';

class TodoCheckbox extends StatelessWidget {
  const TodoCheckbox({super.key, required this.item, required this.list, required this.onChanged,});

  final List<TodoItem> list;
  final TodoItem item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: item.done,
          onChanged: (v) {
            item.done = v!;
            onChanged();
          },
        ),
        Expanded(
          child: Text(
            item.label,
            style: TextStyle(
              decoration:
              item.done ? TextDecoration.lineThrough : TextDecoration.none,
              color: item.done ? Colors.grey : null,
            ),
          ),
        ),
        if (item.done)
          IconButton(
            onPressed: () {
              list.remove(item);
              onChanged();
            },
            icon: const Icon(Icons.delete),
          ),
      ],
    );
  }
}