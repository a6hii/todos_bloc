class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateTodoException extends CloudStorageException {}

class CouldNotGetAllTodosException extends CloudStorageException {}

class CouldNotUpdateTodoException extends CloudStorageException {}

class CouldNotDeleteTodoException extends CloudStorageException {}
