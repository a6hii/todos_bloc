import 'package:flutter/material.dart';

import 'package:todos_bloc_app/services/auth/auth_bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_bloc_app/services/auth/auth_bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'We'
                  've sent you an email verification. Please open it to verify your account. If you haven'
                  't received a verification email yet, press the button below!',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text(
                'Send email verification',
              ),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: const Text(
                'Restart',
              ),
            )
          ],
        ),
      ),
    );
  }
}
