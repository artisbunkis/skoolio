import 'package:flutter/material.dart';
import 'package:skoolio/app/services/auth_service.dart';

class SignInScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Sign In with Google'),
          onPressed: () async {
            await _authService.signInWithGoogle();
            // Navigate to the home screen after successful sign in
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
    );
  }
}
