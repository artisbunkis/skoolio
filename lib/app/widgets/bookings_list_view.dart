import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skoolio/app/models/booking_model.dart';
import 'package:intl/intl.dart';

class BookingsListView extends StatelessWidget {
  final List<Booking> bookings;
  final String userEmail;

  BookingsListView({required this.bookings, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final formattedDate =
            DateFormat.yMMMd().format(booking.date.toDate()); // Format date
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.event,
                      size: 18.0,
                    ),
                    title: Text(
                      'Lesson:',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      booking.lessonId,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      size: 18.0,
                    ),
                    title: Text(
                      'Date:',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      formattedDate, // Use formatted date
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 18.0,
                    ),
                    title: Text(
                      'Name:',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      booking.name,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      size: 18.0,
                    ),
                    title: Text(
                      'Surname:',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      booking.surname,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      size: 18.0,
                    ),
                    title: Text(
                      'Phone Number:',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      booking.phoneNumber,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.note,
                      size: 18.0,
                    ),
                    title: Text(
                      'Note:',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      booking.note,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('lessons')
                        .doc(booking.lessonId)
                        .get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> lessonSnapshot) {
                      if (lessonSnapshot.hasError) {
                        return Text('Error: ${lessonSnapshot.error}');
                      }

                      if (lessonSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final lessonData =
                          lessonSnapshot.data?.data() as Map<String, dynamic>;

                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Title:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  lessonData['title'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Subject:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  lessonData['subject'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Description:',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  lessonData['description'],
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
