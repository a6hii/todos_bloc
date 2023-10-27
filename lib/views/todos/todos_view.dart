import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:todos_bloc_app/constants/routes.dart';
import 'package:todos_bloc_app/enums/menu_action.dart';
import 'package:todos_bloc_app/services/auth/auth_service.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_event.dart';
import 'package:todos_bloc_app/services/cloud/todo.dart';
import 'package:todos_bloc_app/services/cloud/firebase_cloud_storage.dart';
import 'package:todos_bloc_app/utilities/dialogs/logout_dialog.dart';
import 'package:todos_bloc_app/views/todos/todos_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class SingleTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) {
    return Ticker(onTick);
  }
}

class TodosView extends StatefulWidget {
  // final AuthUser authuser;
  const TodosView({super.key});

  @override
  _TodosViewState createState() => _TodosViewState();
}

class _TodosViewState extends State<TodosView> {
  late final FirebaseCloudStorage _todosService;
  String get userId => AuthService.firebase().currentUser!.id;
  final _tabController = TabController(
    length: 2,
    vsync: SingleTickerProvider(),
  );

  @override
  void initState() {
    _todosService = FirebaseCloudStorage();
    _tabController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hi"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateTodoRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.profile:
                  Navigator.of(context).pushNamed(profileViewRoute);
                  break;
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout && context.mounted) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.profile,
                  child: Text('Profile'),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Todos',
            ),
            Tab(
              text: 'Done',
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          StreamBuilder(
            stream: _todosService.allTodos(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allTodos = snapshot.data as Iterable<Todo>;

                    return TodosListView(
                      todos: allTodos.where((element) =>
                          element.status == TodoStatus.todo.name.toString()),
                      onDeleteNote: (todo) async {
                        await _todosService.deleteTodo(
                            documentId: todo.documentId);
                      },
                      onTap: (todo) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateTodoRoute,
                          arguments: todo,
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          //Done todos:
          StreamBuilder(
            stream: _todosService.allTodos(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allTodos = snapshot.data as Iterable<Todo>;

                    return TodosListView(
                      todos: allTodos.where((element) =>
                          element.status == TodoStatus.done.name.toString()),
                      onDeleteNote: (todo) async {
                        await _todosService.deleteTodo(
                            documentId: todo.documentId);
                      },
                      onTap: (todo) {
                        Navigator.of(context).pushNamed(
                          createOrUpdateTodoRoute,
                          arguments: todo,
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
