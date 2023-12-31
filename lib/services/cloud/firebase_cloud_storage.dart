import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos_bloc_app/services/cloud/todo.dart';
import 'package:todos_bloc_app/services/cloud/cloud_storage_constants.dart';
import 'package:todos_bloc_app/services/cloud/cloud_storage_exceptions.dart';

enum TodoStatus { todo, done }

class FirebaseCloudStorage {
  final todos = FirebaseFirestore.instance.collection('todos');

  Future<void> deleteTodo({required String documentId}) async {
    try {
      await todos.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteTodoException();
    }
  }

  Future<void> updatetodo({
    required String documentId,
    String? text,
    String? status,
  }) async {
    try {
      await todos.doc(documentId).update({
        if (text != null) todo: text,
        if (status != null) 'status': status,
        updatedAt: Timestamp.now(),
      });
    } catch (e) {
      throw CouldNotUpdateTodoException();
    }
  }

  Future<void> updateStatus({
    required String documentId,
    required TodoStatus status,
  }) async {
    try {
      await todos.doc(documentId).update({
        status: status.toString(),
        updatedAt: Timestamp.now(),
      });
    } catch (e) {
      throw CouldNotUpdateTodoException();
    }
  }

  Stream<Iterable<Todo>> allTodos({required String ownerUserId}) {
    final allTodos = todos
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => Todo.fromSnapshot(doc)));
    return allTodos;
  }

  Future<Todo> createNewTodo({required String ownerUserId}) async {
    final document = await todos.add({
      ownerUserIdFieldName: ownerUserId,
      todo: '',
      todoStatus: TodoStatus.todo.name.toString(),
      todoCreatedAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    });
    final fetchedTodo = await document.get();
    return Todo(
      documentId: fetchedTodo.id,
      ownerUserId: ownerUserId,
      todoText: '',
      status: TodoStatus.todo.name.toString(),
      createdDate: Timestamp.now(),
      lastUpdatedDate: Timestamp.now(),
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
