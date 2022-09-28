import 'package:flutter/material.dart';
import "dart:async";
import 'package:palestine_console/palestine_console.dart';
import "../models/model_todo.dart";
import "package:sqflite/sqflite.dart";
//* provider: 네트워크와의 통신을 담당
//* repository: 데이터베이스와의 통신을 담당

class TodoProvider {
  late Database db;

  Future initDb() async {
    db = await openDatabase("my_db.db");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS MyTodo (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT)");
    //* AutoIncrement에 이미 todos.length만큼 알아서 추가되는 것이 적혀져 있었습니다.
    //* LateInitializationError: Field 'id' has not been initialized 에러가 이 때문이 아니었습니다.
  }

  Future<List<Todo>> getTodos() async {
    List<Todo> todos = [];
    List<Map> maps =
        await db.query("MyTodo", columns: ["id", "title", "description"]);
    // 아무것도 없다면 어떻게 하지?
    maps.forEach((map) {
      todos.add(Todo.fromMap(map));
    });
    return todos;
  }

  Future<Todo?> getTodo(int id) async {
    List<Map> map = await db.query(
      "MyTodo",
      columns: ["id", "title", "description"],
      where: "id = ?",
      whereArgs: [id],
    );
    if (map.length > 0) {
      return Todo.fromMap(map[0]);
    }
  }

  Future addTodo(Todo todo) async {
    await db.insert("MyTodo", todo.toMap());
  }

  Future deleteTodo(int id) async {
    await db.delete(
      "MyTodo",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future updateTodo(Todo todo) async {
    await db.update(
      "MyTodo",
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
  }
}
