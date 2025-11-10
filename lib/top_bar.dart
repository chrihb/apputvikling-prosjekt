import 'dart:collection';

import 'package:apputvikling_prosjekt/square_button.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

typedef ListEntry = DropdownMenuEntry<ListEntries>;

enum ListEntries {
  item1("Item 1"),
  item2("Item 2"),
  item3("Item 3"),
  item4("Item 4"),;

  const ListEntries(this.label);
  final String label;

  static final List<ListEntry> entries = UnmodifiableListView<ListEntry>(
    values.map<ListEntry>(
          (ListEntries entry) => ListEntry(
        value: entry,
        label: entry.label,
      ),
    ),
  );
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.45;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 16,
        children: [
          SizedBox(
            width: width,
            child: DropdownMenu(
              width: width,
              dropdownMenuEntries: ListEntries.entries,
              initialSelection: ListEntries.item1,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              spacing: 8,
              children: const [
                SquareButton(icon: Icon(Icons.edit)),
                SquareButton(icon: Icon(Icons.add)),
                SquareButton(icon: Icon(Icons.delete)),
              ],
            ),
          ),
        ],
    );
  }
}
