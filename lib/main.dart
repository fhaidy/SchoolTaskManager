import 'dart:math';
import 'package:flutter/material.dart';
import 'components/TarefaForm.dart';
import 'components/TarefaList.dart';
import 'database/databaseHelper.dart';
import 'models/Tarefa.dart';
import 'package:flutter/widgets.dart';

void main() async {
  runApp(SchoolTaskManager());
}

class SchoolTaskManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.orangeAccent,
        primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
              fontSize: 20.0, fontFamily: 'QuickSand', color: Colors.black),
          bodyText2: TextStyle(
              fontSize: 12.0, fontFamily: 'QuickSand', color: Colors.black),
          headline5: TextStyle(
              fontSize: 20.0, color: Colors.black, fontFamily: 'QuickSand'),
          headline6: TextStyle(
              fontSize: 20.0, color: Colors.white, fontFamily: 'QuickSand'),
          subtitle1: TextStyle(
              fontSize: 16.0, color: Colors.grey, fontFamily: 'QuickSand'),
          button: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final globalKey = GlobalKey<ScaffoldState>();
  DatabaseHelper _dbHelper;
  List<Tarefa> _tarefas = [];
  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _atualizarTarefas();
  }

  _atualizarTarefas() async {
    List<Tarefa> x = await _dbHelper.fetchTarefas();
    setState(() {
      _tarefas = x;
    });
  }

  _abrirModalTarefa(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TarefaForm(
          _adicionarTarefa, _atualizaTarefa, false, Tarefa.mockTarefa()),
      isDismissible: true,
    );
  }

  _adicionarTarefa(String titulo, String materia, String descricao,
      DateTime dataEntrega) async {
    await _dbHelper.insertTarefa(Tarefa(
      id: Random().nextDouble().toString(),
      titulo: titulo,
      materia: materia,
      descricao: descricao,
      dataEntrega: dataEntrega,
    ));
    await _atualizarTarefas();
    Navigator.of(this.context).pop();
    _showSnackBar('Tarefa Criada !');
  }

  _removeTarefa(String id) async {
    setState(() {
      _tarefas.removeWhere((element) => element.id == id);
    });
    await _dbHelper.deleteTarefa(id);
    await _atualizarTarefas();
    _showSnackBar('Tarefa Removida !');
  }

  void _showSnackBar(String text) {
    final snackBar = SnackBar(content: Text(text));
    globalKey.currentState.showSnackBar(snackBar);
  }

  _atualizaTarefa(String id, String titulo, String materia, String descricao,
      DateTime dataEntrega) async {
    await _dbHelper.updateTarefa(Tarefa(
      id: id,
      titulo: titulo,
      materia: materia,
      descricao: descricao,
      dataEntrega: dataEntrega,
    ));
    await _atualizarTarefas();
    Navigator.of(this.context).pop();
    _showSnackBar('Tarefa Atualizada !');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(title: Text("Gerenciador de Trabalhos"), actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _abrirModalTarefa(context),
        ),
      ]),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TarefaList(_tarefas.reversed.toList(), _removeTarefa,
                  _adicionarTarefa, _atualizaTarefa),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirModalTarefa(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
