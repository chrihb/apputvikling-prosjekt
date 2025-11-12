import 'package:flutter/material.dart';

import '../model/todo_list.dart';
import '../stateless/square_button.dart';

// The top bar of the application. Hosts the dropdown and list buttons
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.lists,
    required this.currentList,
    required this.onListChanged,
    required this.onCreateList,
    required this.onRenameList,
    required this.onDeleteList,
  });

  final VoidCallback onCreateList;
  final VoidCallback onRenameList;
  final VoidCallback onDeleteList;
  final List<TodoList> lists;
  final TodoList? currentList;
  final void Function(TodoList list) onListChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.of(context).size.width * 0.45;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        SizedBox(
          width: width,
          child: DropdownMenu<TodoList>(
            initialSelection: currentList,
            width: width,
            dropdownMenuEntries: lists
                .map((list) => DropdownMenuEntry(value: list, label: list.name))
                .toList(),
            onSelected: (value) {
              if (value != null) onListChanged(value);
            },
            textStyle: Theme.of(context).textTheme.bodyMedium,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: scheme.surfaceContainerHigh,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            menuStyle: MenuStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              maximumSize: WidgetStatePropertyAll(Size(width, double.infinity)),
              backgroundColor: WidgetStatePropertyAll(
                scheme.surfaceContainerHigh,
              ),
              elevation: const WidgetStatePropertyAll(3),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              shadowColor: WidgetStatePropertyAll(
                scheme.shadow.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),


        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 8,
            children: [
              SquareButton(
                icon: const Icon(Icons.edit),
                onPressed: onRenameList,
              ),
              SquareButton(
                icon: const Icon(Icons.add),
                onPressed: onCreateList,
              ),
              SquareButton(
                icon: const Icon(Icons.delete),
                onPressed: onDeleteList,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
