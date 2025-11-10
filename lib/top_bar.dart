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
    final width = MediaQuery.of(context).size.width * 0.45;


    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 16,
        children: [
      SizedBox(
      width: width,
      child: DropdownMenu<ListEntries>(
        width: width,
        dropdownMenuEntries: ListEntries.entries,
        initialSelection: ListEntries.item1,
        textStyle: Theme.of(context).textTheme.bodyMedium,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        menuStyle: MenuStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          maximumSize: WidgetStatePropertyAll(Size(width, double.infinity)),
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
          elevation: const WidgetStatePropertyAll(3),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          shadowColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
          ),
        ),
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
