import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;

  LessonScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: Column(
        children: [
          // Display the lesson details here
          Text('Title: ${lesson.title}'),
          Text('User: ${lesson.user}'),
          Text('Rating: ${lesson.rating}'),
          Text('Price: \$${lesson.price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
