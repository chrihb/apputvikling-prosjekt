import 'package:apputvikling_prosjekt/stateless/input_field.dart';
import 'package:apputvikling_prosjekt/stateless/popup.dart';
import 'package:apputvikling_prosjekt/util/storage.dart';
import 'package:apputvikling_prosjekt/data/todo_item.dart';
import 'package:apputvikling_prosjekt/stateless/top_bar.dart';
import 'package:apputvikling_prosjekt/stateless/item_list.dart';
import 'package:flutter/material.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final controller = TextEditingController();

  Map<String, List<TodoItem>> allLists = {};
  String currentList = 'My To-Do List';

  @override
  void initState() {
    super.initState();
    Storage.loadAll().then((loaded) {
      setState(() {
        allLists = loaded;
        allLists.putIfAbsent(currentList, () => []);
      });
    });
  }

  void saveAll() => Storage.saveAll(allLists);

  Future<void> handleSubmit(String value) async {
    final input = value.trim();
    if (input.isEmpty) return;

    final newItem = TodoItem(input, false);
    setState(() => allLists[currentList]!.add(newItem));
    await Storage.saveItem(currentList, newItem);

    controller.clear();
  }

  // ─────────────── LIST MANAGEMENT ───────────────

  void createList(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || allLists.containsKey(trimmed)) return;

    setState(() {
      allLists[trimmed] = [];
      currentList = trimmed;
    });
    saveAll();
  }

  void renameList(String newName) {
    final trimmed = newName.trim();
    if (trimmed.isEmpty || allLists.containsKey(trimmed)) return;

    setState(() {
      final items = allLists.remove(currentList);
      allLists[trimmed] = items ?? [];
      currentList = trimmed;
    });
    saveAll();
  }

  void deleteList(String name) {
    if (allLists.length <= 1) return; // Prevent deleting the last list

    setState(() {
      allLists.remove(name);
      currentList = allLists.keys.first;
    });
    saveAll();
  }

  // ─────────────── BUILD UI ───────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TopBar(
                lists: allLists.keys.toList(),
                currentList: currentList,
                onListChanged: (selected) {
                  setState(() {
                    currentList = selected;
                    allLists.putIfAbsent(selected, () => []);
                  });
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
                    onConfirm: () => deleteList(currentList),
                  );
                },
                onRenameList: () {
                  Popup.showInput(
                    context,
                    title: "Rename List",
                    controller: TextEditingController(text: currentList),
                    onConfirm: (value) => renameList(value),
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ItemList(
                  items: allLists[currentList] ?? [],
                  onReorder: (oldIndex, newIndex) {
                    final list = allLists[currentList]!;
                    if (newIndex > oldIndex) newIndex--;
                    final item = list.removeAt(oldIndex);
                    list.insert(newIndex, item);
                    saveAll();
                    setState(() {});
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
