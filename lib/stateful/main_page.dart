import 'package:flutter/material.dart';

import '../model/todo_data.dart';
import '../model/todo_item.dart';
import '../model/todo_list.dart';
import '../stateless/input_field.dart';
import '../stateless/item_list.dart';
import '../stateless/popup.dart';
import '../stateless/top_bar.dart';
import '../util/seeder.dart';
import '../util/storage.dart';

// Main page of the application.
// This is the only stateful widget in the application,
// which keeps all the logic in one place
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();


  TodoData data = TodoData(lists: []);


  // Getter for current list
  TodoList? get currentList {
    if (data.lists.isEmpty) return null;
    return data.lists.firstWhere(
      (l) => l.id == data.currentListId,
      orElse: () => data.lists.first,
    );
  }

  @override
  void initState() {
    super.initState();
    Storage.loadAllOrSeed(Seeder.defaultSeed).then((loaded) {
      setState(() => data = loaded);
    });
    debugPrint("State initialized");
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void saveAll() => Storage.saveAll(data);

  Future<void> handleSubmit(String value) async {
    final input = value.trim();
    if (input.isEmpty || currentList == null) return;

    final newItem = TodoItem(input, false);
    setState(() => currentList!.items.add(newItem));
    saveAll();
    controller.clear();

    FocusScope.of(context).requestFocus(focusNode);
    debugPrint("New item added");
  }

  void createList(String name) {
    var baseName = name.trim().isEmpty ? 'New List' : name.trim();
    var uniqueName = baseName;
    int counter = 2;

    // Keeps incrementing until the name is unique
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
    debugPrint("New list created");
  }

  void renameList(String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || currentList == null) return;

    setState(() => currentList!.name = trimmed);
    saveAll();
    debugPrint("List renamed");
  }

  Future<void> deleteList(TodoList list) async {
    if (data.lists.length <= 1) {
      // If this was the last list, reset to the seed
      await Storage.overwriteSeed(Seeder.onLastDelete);
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
    debugPrint("List deleted");
  }

  void handleReorder(int oldIndex, int newIndex) {
    if (currentList == null) return;
    if (newIndex > oldIndex) newIndex -= 1;

    final full = currentList!.items;

    // Gets positions and items of the unchecked subset
    final uncheckedPositions = <int>[];
    final uncheckedItems = <TodoItem>[];
    for (int i = 0; i < full.length; i++) {
      if (!full[i].done) {
        uncheckedPositions.add(i);
        uncheckedItems.add(full[i]);
      }
    }

    // Reorders inside the subset.
    final moved = uncheckedItems.removeAt(oldIndex);
    uncheckedItems.insert(newIndex, moved);

    // Write the reordered subset back into the full list.
    for (int j = 0; j < uncheckedPositions.length; j++) {
      full[uncheckedPositions[j]] = uncheckedItems[j];
    }

    setState(() {});
    saveAll();

    debugPrint("Reorder Successful");
  }

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
                      handleReorder(oldIndex, newIndex);
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
