import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TarefaForm extends StatefulWidget {
  final void Function(String, String, String, DateTime) onSubmit;

  TarefaForm(this.onSubmit);

  @override
  _TarefaFormState createState() => _TarefaFormState();
}

class _TarefaFormState extends State<TarefaForm> {
  final _tituloController = TextEditingController();
  final _materiaController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime _dataEntrega = DateTime.now();

  _submitForm() {
    final titulo = _tituloController.text;
    final materia = _materiaController.text;
    final descricao = _descricaoController.text;
    if (titulo.isNotEmpty &&
        materia.isNotEmpty &&
        descricao.isNotEmpty &&
        _dataEntrega != null)
      widget.onSubmit(titulo, materia, descricao, _dataEntrega);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2021),
    ).then((value) {
      if (value != null) {
        setState(() {
          _dataEntrega = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(labelText: 'Título'),
              onSubmitted: (_) => _submitForm(),
            ),
            TextField(
              controller: _materiaController,
              decoration: InputDecoration(labelText: 'Matéria'),
              onSubmitted: (_) => _submitForm(),
            ),
            TextField(
              controller: _descricaoController,
              maxLines: 4,
              decoration:
                  InputDecoration.collapsed(hintText: "Descreva a tarefa aqui"),
              onSubmitted: (_) => _submitForm(),
            ),
            Container(
              height: 70,
              child: Row(children: [
                Expanded(
                  child: Text(
                    _dataEntrega == null
                        ? 'Nenhuma Data selecionada !'
                        : 'Data Selecionada: ${DateFormat('dd/MM/y').format(_dataEntrega)}',
                  ),
                ),
                FlatButton(
                  onPressed: _showDatePicker,
                  child: Text(
                    'Alterar Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Theme.of(context).primaryColor,
                )
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: _submitForm,
                  color: Theme.of(context).primaryColor,
                  child: Text('Nova Transação'),
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
