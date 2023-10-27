import 'package:flutter/material.dart';
import 'package:todos_bloc_app/services/auth/auth_service.dart';
import 'package:todos_bloc_app/utilities/generics/get_arguments.dart';
import 'package:todos_bloc_app/services/cloud/todo.dart';
import 'package:todos_bloc_app/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateTodoView extends StatefulWidget {
  const CreateUpdateTodoView({super.key});

  @override
  _CreateUpdateTodoViewState createState() => _CreateUpdateTodoViewState();
}

class _CreateUpdateTodoViewState extends State<CreateUpdateTodoView> {
  Todo? _todo;
  late final FirebaseCloudStorage _todosService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _todosService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final todo = _todo;
    if (todo == null) {
      return;
    }
    final text = _textController.text;
    await _todosService.updatetodo(
      documentId: todo.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<Todo> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<Todo>();

    if (widgetNote != null) {
      _todo = widgetNote;
      _textController.text = widgetNote.todoText;
      return widgetNote;
    }

    final existingNote = _todo;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _todosService.createNewTodo(ownerUserId: userId);
    _todo = newNote;
    return newNote;
  }

  Future<void> _deleteNoteIfTextIsEmpty() async {
    final note = _todo;
    if (_textController.text.isEmpty && note != null) {
      await _todosService.deleteTodo(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _todo;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _todosService.updatetodo(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _deleteNoteIfTextIsEmpty();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            _todo?.status == TodoStatus.todo.name.toString()
                ? 'Create a todo'
                : 'Completed',
          ),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: createOrGetExistingNote(context),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    _setupTextControllerListener();
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        maxLength: 1000,
                        enabled:
                            _todo?.status == TodoStatus.todo.name.toString(),
                        decoration: const InputDecoration(
                            hintText: 'Start typing...',
                            border: OutlineInputBorder()),
                      ),
                    );
                  default:
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                }
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_todo?.status == TodoStatus.todo.name.toString())
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: OutlinedButton(
                              style: ButtonStyle(
                                  fixedSize: MaterialStatePropertyAll(Size(
                                      MediaQuery.sizeOf(context).width, 54))),
                              onPressed: () async {
                                if (_todo != null) {
                                  if (_todo?.status !=
                                      TodoStatus.done.name.toString()) {
                                    await _todosService.updatetodo(
                                      documentId: _todo!.documentId,
                                      status: TodoStatus.done.name.toString(),
                                    );
                                  }
                                }
                                await _deleteNoteIfTextIsEmpty();
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text(
                                'Mark as done',
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                      ElevatedButton(
                          style: ButtonStyle(
                              fixedSize: MaterialStatePropertyAll(
                                  Size(MediaQuery.sizeOf(context).width, 54))),
                          onPressed: () async {
                            await _deleteNoteIfTextIsEmpty();

                            if (context.mounted) Navigator.of(context).pop();
                          },
                          child: Text(
                            _todo?.status == TodoStatus.todo.name.toString()
                                ? 'Save'
                                : 'Go back',
                            style: TextStyle(fontSize: 16),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
