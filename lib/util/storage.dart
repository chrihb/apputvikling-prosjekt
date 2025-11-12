import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:apputvikling_prosjekt/data/todo_item.dart';

class Storage {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/todos.json');
  }

  static Future<Map<String, List<TodoItem>>> loadAll() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        return raw.map((key, value) {
          final list = (value as List)
              .map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
              .toList();
          return MapEntry(key, list);
        });
      }
    } catch (_) {}
    return {};
  }

  static Future<void> saveAll(Map<String, List<TodoItem>> allLists) async {
    final file = await _getFile();
    final data = allLists.map((key, list) =>
        MapEntry(key, list.map((e) => e.toJson()).toList()));
    await file.writeAsString(jsonEncode(data));
  }

  static Future<void> saveItem(String listName, TodoItem newItem) async {
    final file = await _getFile();

    if (!await file.exists()) return;

    final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;

    if (!raw.containsKey(listName)) return;

    final list = (raw[listName] as List)
        .map((e) => TodoItem.fromJson(e as Map<String, dynamic>))
        .toList();

    list.add(newItem);

    raw[listName] = list.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(raw));
  }
}

