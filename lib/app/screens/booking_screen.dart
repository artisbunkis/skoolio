import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Booking Screen!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}