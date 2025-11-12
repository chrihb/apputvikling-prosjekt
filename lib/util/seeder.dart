import '../model/todo_item.dart';
import '../model/todo_list.dart';


// Simple Seeder Factory, one for a default list when the app is initialized,
// and one for when the last list is deleted
class Seeder {
  static List<TodoList> defaultSeed() => [
    TodoList('My To-Do List', [
      TodoItem('Milk', false),
      TodoItem('Eggs', true),
      TodoItem('Bread', false),
      TodoItem('Butter', false),
    ]),
  ];

  static List<TodoList> onLastDelete() => [TodoList('New List', [])];
}
