import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/screens/book_lesson_screen.dart';

class LessonScreen extends StatelessWidget {
  final Lesson lesson;

  LessonScreen({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final currentUserEmail = snapshot.data?.email ?? '';

          final isCurrentUserLessonOwner = (lesson.user == currentUserEmail);

          return Column(
            children: [
              // Display the lesson details here
              Text('Title: ${lesson.title}'),
              Text('User: ${lesson.user}'),
              Text('Rating: ${lesson.rating}'),
              Text('Price: \$${lesson.price.toStringAsFixed(2)}'),
              SizedBox(height: 16.0),
              if (!isCurrentUserLessonOwner)
                ElevatedButton(
                  onPressed: () async {
                    final lessonDoc = await FirebaseFirestore.instance
                        .collection('lessons')
                        .where('title', isEqualTo: lesson.title)
                        .where('user', isEqualTo: lesson.user)
                        .limit(1)
                        .get();
                    final lessonId = lessonDoc.docs.first.id;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookLessonScreen(
                          lessonId: lessonId,
                        ),
                      ),
                    );
                  },
                  child: Text('Book Lesson'),
                ),
            ],
          );
        },
      ),
    );
  }
}
