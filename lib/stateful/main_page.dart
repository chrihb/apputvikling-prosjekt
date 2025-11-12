import 'package:apputvikling_prosjekt/data/todo_item.dart';
import 'package:apputvikling_prosjekt/stateless/input_field.dart';
import 'package:apputvikling_prosjekt/stateless/item_list.dart';
import 'package:apputvikling_prosjekt/stateless/popup.dart';
import 'package:apputvikling_prosjekt/stateless/top_bar.dart';
import 'package:apputvikling_prosjekt/util/storage.dart';
import 'package:flutter/material.dart';

import '../data/todo_data.dart';
import '../data/todo_list.dart';
import '../util/seeder.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  TodoData data = TodoData(lists: []);

  TodoList? get currentList {
    if (data.lists.isEmpty) return null;
    return data.lists.firstWhere(
      (l) => l.id == data.currentListId,
      orElse: () => data.lists.first,
    );
  }

  void saveAll() => Storage.saveAll(data);

  @override
  void initState() {
    super.initState();
    Storage.loadAllOrSeed(Seeder.defaultSeed).then((loaded) {
      setState(() => data = loaded);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> handleSubmit(String value) async {
    final input = value.trim();
    if (input.isEmpty || currentList == null) return;

    final newItem = TodoItem(input, false);
    setState(() => currentList!.items.add(newItem));
    saveAll();
    controller.clear();

    FocusScope.of(context).requestFocus(focusNode);
  }

  void createList(String name) {
    var baseName = name.trim().isEmpty ? 'New List' : name.trim();
    var uniqueName = baseName;
    int counter = 2;

    // Keep incrementing until the name is unique
    while (data.lists.any((l) => l.name == uniqueName)) {
      uniqueName = '$baseName$counter';
      counter++;
    }

    final newList = TodoList(uniqueName);
    setState(() {
      data.lists.add(newList);
      data.currentListId = newList.id;
    });
    saveAll();
  }

  void renameList(String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || currentList == null) return;

    setState(() => currentList!.name = trimmed);
    saveAll();
  }

  Future<void> deleteList(TodoList list) async {
    if (data.lists.length <= 1) {
      // If this was the last list, reset to the seed
      await Storage.justSeed(Seeder.onLastDelete);
      final seeded = await Storage.loadAll();

      setState(() {
        data = seeded;
      });
      return;
    }

    setState(() {
      data.lists.removeWhere((l) => l.id == list.id);
      data.currentListId = data.lists.first.id;
    });
    saveAll();
  }

  // ─────────────── BUILD UI ───────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TopBar(
                  lists: data.lists,
                  currentList: currentList,
                  onListChanged: (selected) {
                    setState(() => data.currentListId = selected.id);
                  },
                  onCreateList: () {
                    Popup.showInput(
                      context,
                      title: "New List",
                      controller: TextEditingController(),
                      onConfirm: (value) => createList(value),
                    );
                  },
                  onDeleteList: () {
                    Popup.showMessage(
                      context,
                      title: "Delete List",
                      message: "Are you sure you want to delete this list?",
                      onConfirm: () => deleteList(currentList!),
                    );
                  },
                  onRenameList: () {
                    Popup.showInput(
                      context,
                      title: "Rename List",
                      controller: TextEditingController(
                        text: currentList?.name,
                      ),
                      onConfirm: (value) => renameList(value),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ItemList(
                    items: currentList?.items ?? [],
                    onReorder: (oldIndex, newIndex) {
                      if (currentList == null) return;
                      if (newIndex > oldIndex) newIndex -= 1;

                      final full = currentList!.items;

                      // 1) Capture positions and items of the unchecked subset (as shown).
                      final uncheckedPositions = <int>[];
                      final uncheckedItems = <TodoItem>[];
                      for (int i = 0; i < full.length; i++) {
                        if (!full[i].done) {
                          uncheckedPositions.add(i);
                          uncheckedItems.add(full[i]);
                        }
                      }

                      // 2) Reorder inside the subset.
                      final moved = uncheckedItems.removeAt(oldIndex);
                      uncheckedItems.insert(newIndex, moved);

                      // 3) Write the reordered subset back into the full list.
                      for (int j = 0; j < uncheckedPositions.length; j++) {
                        full[uncheckedPositions[j]] = uncheckedItems[j];
                      }

                      setState(() {});
                      saveAll();
                    },

                    onChanged: () {
                      saveAll();
                      setState(() {});
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: InputField(
                  handleSubmit: handleSubmit,
                  controller: controller,
                  focusNode: focusNode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
