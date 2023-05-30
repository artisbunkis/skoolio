import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String lessonId;
  final Timestamp date;
  final String name;
  final String surname;
  final String phoneNumber;
  final String note;

  Booking({
    required this.lessonId,
    required this.date,
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.note,
  });
}
