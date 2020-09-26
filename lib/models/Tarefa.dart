import 'package:flutter/foundation.dart';

class Tarefa {
  String id;
  String titulo;
  String materia;
  String descricao;
  DateTime dataEntrega;

  Tarefa({
    @required this.id,
    @required this.titulo,
    @required this.materia,
    @required this.descricao,
    @required this.dataEntrega,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'materia': materia,
      'descricao': descricao,
      'dataEntrega': dataEntrega.toIso8601String(),
    };
  }

  Tarefa.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    titulo = map["titulo"];
    materia = map["materia"];
    descricao = map["descricao"];
    dataEntrega = DateTime.parse(map["dataEntrega"]);
  }

  static Tarefa mockTarefa() {
    return Tarefa(
        id: "",
        titulo: "",
        materia: "",
        descricao: "",
        dataEntrega: DateTime.now());
  }

  @override
  String toString() {
    return 'Dog{id: $id, titulo: $titulo, materia: $materia,' +
        'descricao: $descricao, dataEntrega: ${dataEntrega.toIso8601String()}';
  }
}
