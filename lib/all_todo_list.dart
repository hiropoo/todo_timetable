import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_timetable/todo.dart';

part 'all_todo_list.g.dart';

@Riverpod(keepAlive: true)
class AllTodoListNotifier extends _$AllTodoListNotifier {
  
  @override
  Future<List<Todo>> build() async{
    return await loadTodo();
  }



  /// Todoを追加するメソッド
  Future addTodo(Todo todo) async{
    if(state.asData == null) await loadTodo();
    state.asData!.value.add(todo);
    saveTodo();
  }

  /// Todoを削除するメソッド
  Future removeTodo(Todo todo) async{
    if (state.asData == null) await loadTodo();

    // 削除するTodoのindexを取得 (idで比較)
    int index = state.asData!.value.indexWhere((todoInList) => todo.id == todoInList.id);

    if (index != -1) {
      state.asData!.value.removeAt(index);
    }
    saveTodo();
  }

  /// Todoを更新するメソッド
  Future updateTodo(Todo oldTodo, Todo newTodo) async{
    // 更新するTodoのindexを取得 (idで比較)
    int index = state.asData!.value
        .indexWhere((todoInList) => oldTodo.id == todoInList.id);

    if (index != -1) {
      state.asData!.value[index] = newTodo;
    }
    saveTodo();
  }

  /// TodoのisDoneを更新するメソッド
  Future updateIsDone(Todo todo) async{
    // 更新するTodoのindexを取得 (idで比較)
    int index = state.asData!.value
        .indexWhere((todoInList) => todo.id == todoInList.id);

    if (index != -1) {
      state.asData!.value[index].isDone = !state.asData!.value[index].isDone;
    }
    saveTodo();
  }

  /// Todoのリストを残り時間でソートするメソッド
  Future sortTodoByDeadline() async{
    if (state.asData == null) await loadTodo();
    state.asData!.value.sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  // // SharedPreferencesからTodoListを読み込むメソッド
  Future<List<Todo>> loadTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final todoListJson = prefs.getStringList('allTodoList') ?? [];

    // json形式のリストをTodoListに変換
    List<Todo> allTodoList = todoListJson.map((todoJson) {
      return Todo.fromJson(json.decode(todoJson));
    }).toList();

    return allTodoList;
  }

  // // SharedPreferencesに更新されたTodoListを保存するメソッド
  Future saveTodo() async {
    // TodoListをjson形式のリストに変換
    List<String> todoListJson = state.asData!.value.map((todo) {
      return json.encode(todo.toJson());
    }).toList();

    // SharedPreferencesに保存
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('allTodoList', todoListJson); // todoListを保存
  }
}
