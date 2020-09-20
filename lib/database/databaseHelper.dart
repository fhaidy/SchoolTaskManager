import 'package:SchoolTaskManager/models/Tarefa.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'tarefas.db';
  static const _databaseVersion = 1;

  //singleton class
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String dbPath = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tarefas(id TEXT PRIMARY KEY, titulo TEXT, materia TEXT, descricao TEXT, dataEntrega DATETIME)
      ''');
  }

  Future<int> insertTarefa(Tarefa tarefa) async {
    Database db = await database;
    return await db.insert("tarefas", tarefa.toMap());
  }

  Future<int> updateTarefa(Tarefa tarefa) async {
    Database db = await database;
    return await db.update("tarefas", tarefa.toMap(),
        where: 'id=?', whereArgs: [tarefa.id]);
  }

  Future<int> deleteTarefa(String id) async {
    Database db = await database;
    return await db.delete("tarefas", where: 'id=?', whereArgs: [id]);
  }

  Future<List<Tarefa>> fetchTarefas() async {
    Database db = await database;
    List<Map> contacts = await db.query("tarefas");
    return contacts.length == 0
        ? []
        : contacts.map((x) => Tarefa.fromMap(x)).toList();
  }
}
