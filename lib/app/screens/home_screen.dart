import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/screens/add_lesson_screen.dart';
import 'package:skoolio/app/screens/lesson_screen.dart';
import 'package:skoolio/app/services/firestore_service.dart';
import 'package:skoolio/app/widgets/lesson_list_view.dart';

class HomeScreen extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          SizedBox(height: 16.0),
          Text(
            'Featured Lessons',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: StreamBuilder<List<Lesson>>(
              stream: _firestoreService.getLessonsFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return LessonListView(lessons: snapshot.data!);
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLessonScreen(),
            ),
          ).then((newLesson) {
            if (newLesson != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonScreen(lesson: newLesson),
                ),
              );
            }
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
