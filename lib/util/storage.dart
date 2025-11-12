import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../data/todo_list.dart';
import '../data/todo_data.dart';

class Storage {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/todos.json');
  }

  static Future<TodoData> loadAll() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        return TodoData.fromJson(raw);
      }
    } catch (_) {}
    return TodoData(lists: []);
  }

  static Future<void> saveAll(TodoData data) async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(data.toJson()));
  }

  static Future<TodoData> loadAllOrSeed(List<TodoList> Function() seedFactory) async {
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

  static Future<void> justSeed(List<TodoList> Function() seedFactory) async {
    final lists = seedFactory();
    final seed = TodoData(
      lists: lists,
      currentListId: lists.first.id,
    );

    final file = await _getFile();
    await file.writeAsString(jsonEncode(seed.toJson()));
  }
}
