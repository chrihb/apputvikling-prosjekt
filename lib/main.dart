import 'package:apputvikling_prosjekt/input_field.dart';
import 'package:apputvikling_prosjekt/storage.dart';
import 'package:apputvikling_prosjekt/todo_item.dart';
import 'package:apputvikling_prosjekt/top_bar.dart';
import 'package:flutter/material.dart';
import 'item_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'To-Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Remove 'const' because we pass a callback
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
              ),
            ),

            // 🔹 Main item list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ItemList(items: allLists[currentList] ?? []),
              ),
            ),

            // 🔹 Input field at the bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: InputField(),
            ),
          ],
        ),
      ),
    );
  }
}
