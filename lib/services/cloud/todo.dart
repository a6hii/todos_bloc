import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todos_bloc_app/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class Todo {
  final String documentId;
  final String ownerUserId;
  final String todoText;
  final String status;
  final Timestamp createdDate;
  final Timestamp lastUpdatedDate;
  const Todo({
    required this.documentId,
    required this.ownerUserId,
    required this.todoText,
    required this.status,
    required this.createdDate,
    required this.lastUpdatedDate,
  });

  Todo.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        todoText = snapshot.data()[todo] as String,
        status = snapshot.data()[todoStatus] as String,
        createdDate = snapshot.data()[todoCreatedAt] as Timestamp,
        lastUpdatedDate = snapshot.data()[updatedAt] as Timestamp;
}
