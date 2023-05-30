import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/services/firestore_service.dart';

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
            return ListView.builder(
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                Lesson lesson = lessons[index];
                return ListTile(
                  title: Text(lesson.title),
                  subtitle: Text('By ${lesson.user}'),
                  // Other details of the lesson
                );
              },
            );
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
