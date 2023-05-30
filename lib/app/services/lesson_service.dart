import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String user;
  final double rating;
  final double price;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.user,
    required this.rating,
    required this.price,
  });
}

class LessonService {
  final CollectionReference lessonsCollection =
      FirebaseFirestore.instance.collection('lessons');

  Future<List<Lesson>> getAllLessons() async {
    QuerySnapshot querySnapshot = await lessonsCollection.get();
    List<Lesson> lessons = [];

    querySnapshot.docs.forEach((doc) {
      lessons.add(Lesson(
        id: doc.id,
        title: doc.get('title'),
        description: doc.get('description'),
        imageUrl: doc.get('imageUrl'),
        user: doc.get('user'),
        rating: doc.get('rating').toDouble(),
        price: doc.get('price').toDouble(),
      ));
    });

    return lessons;
  }

  Future<void> addLesson(Lesson lesson) async {
    await lessonsCollection.add({
      'title': lesson.title,
      'description': lesson.description,
      'imageUrl': lesson.imageUrl,
      'user': lesson.user,
      'rating': lesson.rating,
      'price': lesson.price,
    });
  }
}
