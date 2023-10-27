import 'package:flutter/material.dart';
import 'package:todos_bloc_app/my_app.dart';
import 'package:todos_bloc_app/services/auth/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthService.firebase();

  // Initialize Firebase
  await authProvider.initialize();

  runApp(MyApp(
    authProvider: authProvider,
  ));
}
