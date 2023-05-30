import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/screens/lesson_screen.dart';

class UserLessonListView extends StatelessWidget {
  final List<Lesson> lessons;

  UserLessonListView({required this.lessons});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonScreen(lesson: lesson),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text('By ${lesson.user}'),
                SizedBox(height: 8.0),
                Text('Rating: ${lesson.rating.toStringAsFixed(1)}'),
                SizedBox(height: 8.0),
                Text('Price: \$${lesson.price.toStringAsFixed(2)}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
