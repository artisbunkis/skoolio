import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/models/subject_model.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _lessonsCollection =
      FirebaseFirestore.instance.collection('lessons');

  Stream<List<Lesson>> getLessonsFromFirestore() {
    return _firestore.collection('lessons').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Lesson(
          title: doc['title'] ?? '',
          user: doc['user'] ?? '',
          rating: doc['rating']?.toDouble() ?? 0.0,
          price: doc['price']?.toDouble() ?? 0.0,
          description: doc['description'] ?? '',
          imageUrl: doc['imageUrl'] ?? '',
          subject: doc['subject'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> addLessonToFirestore(Lesson lesson) async {
    await _lessonsCollection.add({
      'title': lesson.title,
      'user': lesson.user,
      'rating': lesson.rating,
      'price': lesson.price,
      'description': lesson.description,
      'imageUrl': lesson.imageUrl,
      'subject': lesson.subject,
    });
  }

  Stream<List<Subject>> getSubjectsFromFirestore() {
    return _firestore.collection('subjects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Subject(id: doc.id, name: data['name']);
      }).toList();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Lesson>> getLessonsByUserFromFirestore() {
    String? currentUserEmail = _auth.currentUser?.email;

    if (currentUserEmail != null) {
      return _firestore
          .collection('lessons')
          .where('user', isEqualTo: currentUserEmail)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Lesson(
            title: data['title'] as String,
            user: data['user'] as String,
            rating: data['rating'] as double,
            price: data['price'] as double,
            description: data['description'] as String,
            imageUrl: data['imageUrl'] as String,
            subject: data['subject'] as String,
          );
        }).toList();
      });
    } else {
      // Return an empty stream if the current user's email is null
      return Stream.value([]);
    }
  }
}
