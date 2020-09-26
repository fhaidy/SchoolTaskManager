import 'package:SchoolTaskManager/models/Tarefa.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'TarefaForm.dart';

class TarefaList extends StatelessWidget {
  final List<Tarefa> tarefas;
  final void Function(String) onRemove;
  final void Function(String, String, String, DateTime) addTarefa;
  final void Function(String, String, String, String, DateTime) updateTarefa;
  TarefaList(this.tarefas, this.onRemove, this.addTarefa, this.updateTarefa);

  _openTarefaForm(BuildContext context, Tarefa tarefa) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TarefaForm(addTarefa, updateTarefa, true, tarefa),
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 760,
      child: tarefas.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Nenhuma Tarefa Cadastrada',
                    style: Theme.of(context).primaryTextTheme.headline5),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (ctx, index) => Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  title: Text(
                    tarefas[index].titulo,
                    style: Theme.of(context).primaryTextTheme.headline5,
                  ),
                  subtitle: Text(
                    DateFormat('dd MMMM').format(tarefas[index].dataEntrega),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[300]),
                    onPressed: () => onRemove(tarefas[index].id),
                  ),
                  onTap: () => _openTarefaForm(context, tarefas[index]),
                ),
              ),
            ),
    );
  }
}
