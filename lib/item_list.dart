import 'package:apputvikling_prosjekt/todo_checkbox.dart';
import 'package:apputvikling_prosjekt/todo_item.dart';
import 'package:flutter/material.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key, required this.items});
  final List<TodoItem> items;

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  @override
  Widget build(BuildContext context) {
    final unchecked = widget.items.where((e) => !e.done).toList();
    final checked = widget.items.where((e) => e.done).toList();

    return ListView(
      shrinkWrap: true,
      children: [
        // 🔹 Unchecked section (Reorderable)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex--;
                final item = unchecked.removeAt(oldIndex);
                unchecked.insert(newIndex, item);
              });
            },
            children: [
              for (final item in unchecked)
                TodoCheckbox(
                  key: ValueKey(item.id), // unique id prevents flicker
                  item: item,
                  list: widget.items,
                  onChanged: () => setState(() {}),
                ),
            ],
          ),
        ),

        // 🔹 Animated divider between sections
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (unchecked.isNotEmpty && checked.isNotEmpty)
              ? const Divider(key: ValueKey('divider'))
              : const SizedBox.shrink(key: ValueKey('no-divider')),
        ),

        // 🔹 Checked section (non-reorderable)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final item in checked)
                TodoCheckbox(
                  key: ValueKey(item.id),
                  item: item,
                  list: widget.items,
                  onChanged: () => setState(() {}),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
