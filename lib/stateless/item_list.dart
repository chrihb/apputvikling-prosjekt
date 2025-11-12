import 'package:apputvikling_prosjekt/stateless/todo_checkbox.dart';
import 'package:apputvikling_prosjekt/data/todo_item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({
    super.key,
    required this.items,
    required this.onReorder,
    required this.onChanged,
  });

  final List<TodoItem> items;
  final void Function(int oldIndex, int newIndex) onReorder;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final unchecked = items.where((e) => !e.done).toList();
    final checked = items.where((e) => e.done).toList();

    if (items.isEmpty) {
      final scheme = Theme.of(context).colorScheme;
      final textTheme = Theme.of(context).textTheme;

      return Center(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Text(
            'Add an item to get started!',
            style: textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    } else {
      return ListView(
        shrinkWrap: true,
        children: [
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: onReorder,
              children: [
                for (final item in unchecked)
                  TodoCheckbox(
                    key: ValueKey(item.id),
                    item: item,
                    list: items,
                    onChanged: onChanged,
                  ),
              ],
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: (unchecked.isNotEmpty && checked.isNotEmpty)
                ? const Divider(key: ValueKey('divider'))
                : const SizedBox.shrink(key: ValueKey('no-divider')),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.topCenter,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final item in checked)
                  AnimatedSwitcher(
                    key: ValueKey(item.id),
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    ),
                    child: TodoCheckbox(
                      key: ValueKey('${item.id}-${item.done}'),
                      item: item,
                      list: items,
                      onChanged: onChanged,
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
