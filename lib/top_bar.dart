import 'package:apputvikling_prosjekt/square_button.dart';
import 'package:flutter/material.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.lists,
    required this.currentList,
    required this.onListChanged,
  });

  final List<String> lists;
  final String currentList;
  final void Function(String listName) onListChanged;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.currentList);
  }

  @override
  void didUpdateWidget(covariant TopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentList != controller.text) {
      controller.text = widget.currentList;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.45;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        SizedBox(
          width: width,
          child: DropdownMenu<String>(
            controller: controller,
            width: width,
            dropdownMenuEntries: widget.lists
                .map((e) => DropdownMenuEntry(value: e, label: e))
                .toList(),
            onSelected: (value) {
              if (value != null) {
                widget.onListChanged(value);
              }
            },
            textStyle: Theme.of(context).textTheme.bodyMedium,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            menuStyle: MenuStyle(
              padding: const WidgetStatePropertyAll(EdgeInsets.zero),
              maximumSize:
              WidgetStatePropertyAll(Size(width, double.infinity)),
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
