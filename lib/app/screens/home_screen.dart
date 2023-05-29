import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/screens/add_lesson_screen.dart';
import 'package:skoolio/app/screens/lesson_screen.dart';
import 'package:skoolio/app/widgets/lesson_list_view.dart';

class HomeScreen extends StatelessWidget {
  final List<Lesson> lessons = [
    Lesson(
      id: 1,
      title: "Math Lesson",
      user: "John Doe",
      rating: 4.5,
      price: 19.99,
      description: "Learn math concepts and problem-solving techniques.",
      imageUrl: "assets/images/lesson.jpg",
      subject: "Math",
    ),
    Lesson(
      id: 2,
      title: "History Lesson",
      user: "Jane Smith",
      rating: 4.2,
      price: 14.99,
      description: "Explore the fascinating world of history.",
      imageUrl: "assets/images/lesson.jpg",
      subject: "History",
    ),
    // Add more lessons here
  ];

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
            child: LessonListView(lessons: lessons),
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
