import 'package:apputvikling_prosjekt/todo_item.dart';
import 'package:flutter/material.dart';

class TodoCheckbox extends StatelessWidget {
  const TodoCheckbox({
    super.key,
    required this.item,
    required this.list,
    required this.onChanged,
  });

  final List<TodoItem> list;
  final TodoItem item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final iconColor = scheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Checkbox(
            value: item.done,
            activeColor: iconColor,
            checkColor: scheme.surface,
            onChanged: (v) {
              item.done = v!;
              onChanged();
            },
          ),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                fontSize: 16,
                decoration: item.done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: item.done
                    ? scheme.onSurfaceVariant
                    : scheme.onSurface,
              ),
            ),
          ),
          if (item.done)
            IconButton(
              onPressed: () {
                list.remove(item);
                onChanged();
              },
              icon: Icon(Icons.delete, color: iconColor),
            ),
        ],
      ),
    );
  }
}
