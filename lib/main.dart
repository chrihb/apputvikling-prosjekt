import 'package:apputvikling_prosjekt/input_field.dart';
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
  final List<TodoItem> itemList = [
    TodoItem('Milk', false),
    TodoItem('Eggs', true),
    TodoItem('Bread', false),
    TodoItem('Butter', false),
    TodoItem('Coffee', true),
    TodoItem('Pasta', false),
    TodoItem('Tomato Sauce', true),
    TodoItem('Apples', false),
    TodoItem('Bananas', false),
    TodoItem('Orange Juice', true),
    TodoItem('Cheese', false),
    TodoItem('Yogurt', true),
    TodoItem('Chicken', false),
    TodoItem('Rice', false),
    TodoItem('Beans', true),
    TodoItem('Cereal', false),
    TodoItem('Toothpaste', true),
    TodoItem('Soap', false),
    TodoItem('Shampoo', false),
    TodoItem('Detergent', true),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: TopBar(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ItemList(items: itemList),
              ),
            ),
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
