import 'package:apputvikling_prosjekt/todo_item.dart';
import 'package:flutter/material.dart';
import 'item_list.dart';

class ItemField extends StatefulWidget {
  const ItemField({super.key});

  @override
  State<ItemField> createState() => _ItemFieldState();
}

class _ItemFieldState extends State<ItemField> {

  final List<TodoItem> itemList1 = [
    TodoItem('Milk', false),
    TodoItem('Eggs', false),
  ];

  final List<TodoItem> itemList2 = [
    TodoItem('Flour', true),
    TodoItem('Coca-Cola', true),
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ItemList(items: itemList1),
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 20,
            indent: 16,
            endIndent: 16,
          ),

          ItemList(items: itemList2)
        ],
      ),
    );
  }
}