import 'package:flutter/material.dart';
import 'dart:async';
import 'package:palestine_console/palestine_console.dart';
import '../models/model_todo.dart';
import "../providers/provider_todo.dart";

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Todo> todos = [];
  TodoProvider todoProvider = TodoProvider();
  bool isLoading = true;

  Future initDb() async {
    await todoProvider.initDb().then((value) async {
      todos = await todoProvider.getTodos();
    });
  }

  //* initState에 isloading이 될 것 같음
  @override
  void initState() {
    super.initState();
    // Timer 씌워도 변하는거 없음
    initDb().then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todo app"),
          actions: [
            InkWell(
              onTap: () {},
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.book),
                    Text("뉴스"),
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Text(
            "+",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  String title = "";
                  String description = "";
                  return AlertDialog(
                    title: Text("할 일 추가히기"),
                    content: Container(
                      height: 200,
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              title = value;
                            },
                            decoration: InputDecoration(
                              labelText: "제목",
                            ),
                          ),
                          TextField(
                            onChanged: (value) {
                              description = value;
                            },
                            decoration: InputDecoration(
                              labelText: "설명",
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            //* 새로워진 Todos 기반으로 다시 빌드해야하므로 setState()를 사용한다
                            Print.white("ADD");
                            await todoProvider.addTodo(
                                Todo(title: title, description: description));
                            List<Todo> newTodos = await todoProvider.getTodos();
                            setState(() {
                              todos = newTodos;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("추가")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("취소")),
                    ],
                  );
                });
          },
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(todos[index].title),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text("할 일 보기"),
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Text('제목 : ' + todos[index].title),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child:
                                      Text('설명 : ' + todos[index].description),
                                ),
                              ],
                            );
                          });
                    },
                    trailing: SizedBox(
                        width: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    //* 수정
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String title = todos[index].title;
                                          String description =
                                              todos[index].description;
                                          todos[index].description;
                                          return AlertDialog(
                                            title: Text("할 일 수정히기"),
                                            content: Container(
                                              height: 200,
                                              child: Column(
                                                children: [
                                                  TextField(
                                                    onChanged: (value) {
                                                      title = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: "제목",
                                                      hintText:
                                                          todos[index].title,
                                                    ),
                                                  ),
                                                  TextField(
                                                    onChanged: (value) {
                                                      description = value;
                                                    },
                                                    decoration: InputDecoration(
                                                      labelText: "설명",
                                                      hintText: todos[index]
                                                          .description,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    //* 새로워진 Todos 기반으로 다시 빌드해야하므로 setState()를 사용한다
                                                    print("UPDATE");
                                                    todoProvider.updateTodo(
                                                        Todo(
                                                            id: todos[index].id,
                                                            title: title,
                                                            description:
                                                                description));
                                                    List<Todo> newTodos =
                                                        await todoProvider
                                                            .getTodos();
                                                    setState(() {
                                                      todos = newTodos;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("수정")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("취소")),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(Icons.edit),
                                )),
                            Container(
                                padding: EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    //* 삭제
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("할 일 삭제하기"),
                                            content: Container(
                                              child: Text("삭제하시겠습니까?"),
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text("삭제"),
                                                onPressed: () async {
                                                  todoProvider.deleteTodo(
                                                      todos[index].id ?? 0);
                                                  List<Todo> newTodos =
                                                      await todoProvider
                                                          .getTodos();
                                                  setState(() {
                                                    todos = newTodos;
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text("취소"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(Icons.delete),
                                )),
                          ],
                        )),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: todos.length));
  }
}
