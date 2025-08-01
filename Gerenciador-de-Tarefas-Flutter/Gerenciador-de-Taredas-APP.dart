import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const TarefaListScreen(),
    );
  }
}

class Tarefa {
  String titulo;
  bool concluida;

  Tarefa({required this.titulo, this.concluida = false});
}

class TarefaListScreen extends StatefulWidget {
  const TarefaListScreen({super.key});

  @override
  State<TarefaListScreen> createState() => _TarefaListScreenState();
}

class _TarefaListScreenState extends State<TarefaListScreen> {
  List<Tarefa> _tarefas = [];
  TextEditingController _novaTarefaController = TextEditingController();

  void _adicionarTarefa() {
    if (_novaTarefaController.text.isNotEmpty) {
      setState(() {
        _tarefas.add(Tarefa(titulo: _novaTarefaController.text));
        _novaTarefaController.clear();
      });
    }
  }

  void _alternarConcluida(int index) {
    setState(() {
      _tarefas.elementAt(index).concluida = !_tarefas.elementAt(index).concluida;
    });
  }

  void _deletarTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
      ),
      body: _tarefas.isEmpty
          ? const Center(
              child: Text('Nenhuma tarefa adicionada.'),
            )
          : ListView.builder(
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas.elementAt(index);
                return ListTile(
                  leading: Checkbox(
                    value: tarefa.concluida,
                    onChanged: (bool? value) {
                      _alternarConcluida(index);
                    },
                  ),
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      decoration: tarefa.concluida
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deletarTarefa(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Adicionar Nova Tarefa'),
                content: TextField(
                  controller: _novaTarefaController,
                  decoration: const InputDecoration(
                    labelText: 'Título da Tarefa',
                  ),
                  onSubmitted: (_) => _adicionarTarefa(),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Adicionar'),
                    onPressed: () {
                      _adicionarTarefa();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}