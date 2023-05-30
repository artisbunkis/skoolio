import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/screens/lesson_screen.dart';
import 'package:skoolio/app/services/firestore_service.dart';
import 'package:skoolio/app/widgets/user_lesson_list_view.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: StreamBuilder<List<Lesson>>(
        stream: _firestoreService.getLessonsByUserFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Lesson> lessons = snapshot.data!;
            return UserLessonListView(lessons: lessons);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
