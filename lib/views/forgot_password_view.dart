import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todos_bloc_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_event.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_state.dart';
import 'package:todos_bloc_app/utilities/dialogs/error_dialog.dart';
import 'package:todos_bloc_app/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              'context.loc.forgot_password_view_generic_error',
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('context.loc.forgot_password'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'context.loc.forgot_password_view_prompt',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _controller,
                  // decoration: InputDecoration(
                  //   hintText: 'context.loc.email_text_field_placeholder',
                  // ),
                  decoration: InputDecoration(
                    // hintText: context.loc.password_text_field_placeholder,
                    label: Text('context.loc.email_text_field_placeholder'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStatePropertyAll(
                            Size(MediaQuery.sizeOf(context).width, 54))),
                    onPressed: () {
                      final email = _controller.text;
                      context
                          .read<AuthBloc>()
                          .add(AuthEventForgotPassword(email: email));
                    },
                    child: Text(
                      'context.loc.forgot_password_view_send_me_link',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: Text(
                    'context.loc.forgot_password_view_back_to_login',
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
