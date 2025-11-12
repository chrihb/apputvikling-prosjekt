import '../data/todo_item.dart';
import '../data/todo_list.dart';

class Seeder {
  static List<TodoList> defaultSeed() => [
    TodoList('My To-Do List', [
      TodoItem('Milk', false),
      TodoItem('Eggs', true),
      TodoItem('Bread', false),
      TodoItem('Butter', false),
    ]),
  ];

  static List<TodoList> onLastDelete() => [
    TodoList('New List', []),
  ];
}
