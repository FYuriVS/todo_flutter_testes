import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/cubits/board_cubit.dart';
import 'package:todo/models/task.dart';
import 'package:todo/states/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPage();
}

class _BoardPage extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;
    Widget body = Container();

    if (state is EmptyBoardState) {
      body = const Center(
        key: Key('EmptyState'),
        child: Text('Adicione uma nova task'),
      );
    } else if (state is GettedTasksBoarsState) {
      final tasks = state.tasks;
      body = ListView.builder(
        key: const Key('GettedState'),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () {
              cubit.removeTask(task);
            },
            child: CheckboxListTile(
                value: task.check,
                title: Text(task.description),
                onChanged: (value) {
                  cubit.checkTask(task);
                }),
          );
        },
      );
    } else if (state is FailureBoardState) {
      body = const Center(
        key: Key('FailureState'),
        child: Text("Erro ao pegar as tasks"),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          addTaskDialog();
        },
      ),
    );
  }

  void addTaskDialog() {
    var description = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  final task =
                      Task(id: -1, description: description, check: false);
                  context.read<BoardCubit>().addTask(task);
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
            content: TextFormField(
              onChanged: (value) => description = value,
            ),
            title: const Text("Adicionar uma Tarefa"),
          );
        });
  }
}
