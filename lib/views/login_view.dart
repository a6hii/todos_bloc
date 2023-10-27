import 'package:flutter/material.dart';

import 'package:todos_bloc_app/services/auth/auth_exceptions.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_event.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_state.dart';
import 'package:todos_bloc_app/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              ' context.loc.login_error_cannot_find_user',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
                context, ' context.loc.login_error_wrong_credentials,');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              ' context.loc.login_error_auth_error',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome "),
        ),
        body: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  // context.loc.login_view_prompt
                  "Please login to continue",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      // hintText: context.loc.email_text_field_placeholder,
                      label: Text('context.loc.email_text_field_placeholder'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      // hintText: context.loc.password_text_field_placeholder,
                      label:
                          Text('context.loc.password_text_field_placeholder'),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: Text(
                        // context.loc.login_view_forgot_password,
                        'Reset Password'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                            Size(MediaQuery.sizeOf(context).width, 54))),
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      context.read<AuthBloc>().add(
                            AuthEventLogIn(
                              email,
                              password,
                            ),
                          );
                    },
                    child: Text(
                      'context.loc.login',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                            Size(MediaQuery.sizeOf(context).width, 54))),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventShouldRegister(),
                          );
                    },
                    child: Text(
                      'context.loc.login_view_not_registered_yet',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
