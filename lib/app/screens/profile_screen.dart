import 'package:flutter/material.dart';
import 'package:skoolio/app/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  Future<void> _signOut(BuildContext context) async {
    try {
      await _authService.signOut();
      // Redirect to sign-in page or desired screen
      // For example:
      Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      // Handle sign-out error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to the Profile Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
