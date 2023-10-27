import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todos_bloc_app/services/auth/auth_exceptions.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_event.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_state.dart';
import 'package:todos_bloc_app/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _name = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'This password is not secure enough. Please choose another password!',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'This email is already registered to another user. Please choose another email!',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Failed to register. Please try again later!',
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'The email address you entered appears to be invalid. Please try another email address!',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Please Register'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'New user? Please register to continue!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 24),
                  child: TextField(
                    controller: _name,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text('Your name'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      label: Text('Password'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            fixedSize: MaterialStatePropertyAll(
                                Size(MediaQuery.sizeOf(context).width, 54))),
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          final username = _name.text;

                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  username,
                                  email,
                                  password,
                                ),
                              );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        child: const Text(
                          'Already registered? Login here!',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
