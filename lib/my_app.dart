import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_bloc_app/constants/routes.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:todos_bloc_app/services/auth/auth_provider.dart';
import 'package:todos_bloc_app/views/todos/create_update_todo_view.dart';
import 'package:todos_bloc_app/views/profile/profile_view.dart';

import 'package:todos_bloc_app/helpers/loading/loading_screen.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_event.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_state.dart';
import 'package:todos_bloc_app/views/forgot_password_view.dart';
import 'package:todos_bloc_app/views/login_view.dart';
import 'package:todos_bloc_app/views/todos/todos_view.dart';
import 'package:todos_bloc_app/views/register_view.dart';
import 'package:todos_bloc_app/views/verify_email_view.dart';

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({super.key, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(authProvider),
        child: const HomePage(),
      ),
      routes: {
        profileViewRoute: (context) => const ProfileView(),
        createOrUpdateTodoRoute: (context) => const CreateUpdateTodoView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const TodosView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
