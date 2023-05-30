import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skoolio/app/models/booking_model.dart';
import 'package:skoolio/app/widgets/bookings_list_view.dart';

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late String _currentUserEmail;
  List<String> _currentUserLessons = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
    _getCurrentUserLessons(); // Fetch current user's lessons
  }

  Future<void> _getCurrentUserEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email!;
      });
    }
  }

  Future<void> _getCurrentUserLessons() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('lessons')
        .where('user', isEqualTo: _currentUserEmail)
        .get();
    final lessonIds = snapshot.docs.map((doc) => doc.id).toList();
    setState(() {
      _currentUserLessons = lessonIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('lessonId',
                whereIn:
                    _currentUserLessons.isNotEmpty ? _currentUserLessons : [''])
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No bookings found for your lessons.'));
          }

          List<Booking> bookings =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            return Booking(
              lessonId: data['lessonId'],
              date: (data['date'] as Timestamp),
              name: data['name'],
              surname: data['surname'],
              phoneNumber: data['phoneNumber'],
              note: data['note'],
            );
          }).toList();

          return BookingsListView(
              bookings: bookings, userEmail: _currentUserEmail);
        },
      ),
    );
  }
}
