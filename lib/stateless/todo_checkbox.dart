import 'package:flutter/material.dart';

import '../model/todo_item.dart';

// General purpose checkbox
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
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          FocusScope.of(context).unfocus();
          item.done = !item.done;
          onChanged();
        },
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
                  color: item.done ? scheme.onSurfaceVariant : scheme.onSurface,
                ),
              ),
            ),

            if (item.done)
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  FocusScope.of(context).unfocus();
                  list.remove(item);
                  onChanged();
                },
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Icon(Icons.delete, color: iconColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
