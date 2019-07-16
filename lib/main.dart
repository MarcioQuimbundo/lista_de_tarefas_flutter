import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.amber
    ),
  ));
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _toDoController = TextEditingController();
  List _toDoList = [];

  void _addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _toDoController.text;
      _toDoController.text = "";
      newTodo["ok"] = false;
      _toDoList.add(newTodo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "Lista de Tarefas",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.amberAccent,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _toDoController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: "Nova Tarefa",
                          labelStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  RaisedButton(
                    onPressed: _addTodo,
                    color: Colors.amber,
                    child: Text("Add", style: TextStyle(color: Colors.black),),
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: _toDoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    onChanged: (bool check) {
                      setState(() {
                        _toDoList[index]["ok"] = check;
                        _saveData();
                      });
                    },
                    title: Text(_toDoList[index]["title"], style: TextStyle(color: Colors.white)),
                    value: _toDoList[index]["ok"],
                    secondary: CircleAvatar(
                      backgroundColor: Colors.amber,
                      child: Icon(
                          _toDoList[index]["ok"] ? Icons.check : Icons.error, color: Colors.black,),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
