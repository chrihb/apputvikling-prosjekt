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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(widget.items[index].label),
          value: widget.items[index].done,
          onChanged: (v) => setState(() => widget.items[index].done = v!),
        );
      },
    );
  }
}
