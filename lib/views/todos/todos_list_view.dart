import 'package:flutter/material.dart';
import 'package:todos_bloc_app/constants/routes.dart';
import 'package:todos_bloc_app/services/cloud/todo.dart';
import 'package:todos_bloc_app/utilities/dialogs/delete_dialog.dart';

typedef TodoCallback = void Function(Todo todo);

class TodosListView extends StatelessWidget {
  final Iterable<Todo> todos;
  final TodoCallback onDeleteNote;
  final TodoCallback onTap;

  const TodosListView({
    Key? key,
    required this.todos,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return todos.isEmpty
        ? Center(
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(createOrUpdateTodoRoute);
                },
                child: const Text(
                  "Create a todo!",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                )))
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos.elementAt(index);
              return ListTile(
                onTap: () {
                  onTap(todo);
                },
                title: Text(
                  todo.todoText,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(todo);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              );
            },
          );
  }
}
