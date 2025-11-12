import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../model/todo_data.dart';
import '../model/todo_list.dart';


// Helper Class for handling storage of the JSON file
class Storage {
  
  // Gets the todos.json file
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/todos.json');
  }

  // Loads all lists from storage
  static Future<TodoData> loadAll() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final raw =
            jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        return TodoData.fromJson(raw);
      }
    } catch (_) {}
    return TodoData(lists: []);
  }

  // Saves all lists to storage
  static Future<void> saveAll(TodoData data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data.toJson()));
  }

  // Used during init. Loads lists from storage, or seeds with default list
  static Future<TodoData> loadAllOrSeed(
    List<TodoList> Function() seedFactory,
  ) async {
    final file = await _getFile();
    if (await file.exists()) {
      return loadAll();
    } else {
      final seed = TodoData(
        lists: seedFactory(),
        currentListId: seedFactory().first.id,
      );
      await saveAll(seed);
      return seed;
    }
  }

  // Creates a clean JSON file with just the given seed
  static Future<void> overwriteSeed(List<TodoList> Function() seedFactory) async {
    final lists = seedFactory();
    final seed = TodoData(lists: lists, currentListId: lists.first.id);

    final file = await _getFile();
    await file.writeAsString(jsonEncode(seed.toJson()));
  }
}
