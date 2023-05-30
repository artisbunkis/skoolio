import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookLessonScreen extends StatefulWidget {
  final String lessonId;

  BookLessonScreen({required this.lessonId});

  @override
  _BookLessonScreenState createState() => _BookLessonScreenState();
}

class _BookLessonScreenState extends State<BookLessonScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneNumberController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Lesson'),
      ),
      body: Column(
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('lessons')
                .doc(widget.lessonId)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the lesson details here
                    Text('Title: ${data['title']}'),
                    Text('User: ${data['user']}'),
                    Text('Rating: ${data['rating']}'),
                    Text('Price: \$${data['price'].toStringAsFixed(2)}'),
                    SizedBox(height: 16.0),
                    // Input form for booking details
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              _selectedDate != null
                                  ? 'Selected Date: $_selectedDate'
                                  : 'Select Date',
                            ),
                          ),
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(labelText: 'Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _surnameController,
                            decoration: InputDecoration(labelText: 'Surname'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your surname';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _phoneNumberController,
                            decoration:
                                InputDecoration(labelText: 'Phone Number'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _noteController,
                            decoration: InputDecoration(labelText: 'Note'),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Save the booking details to the 'bookings' collection
                                FirebaseFirestore.instance
                                    .collection('bookings')
                                    .add({
                                  'lessonId': widget.lessonId,
                                  'date': _selectedDate,
                                  'name': _nameController.text,
                                  'surname': _surnameController.text,
                                  'phoneNumber': _phoneNumberController.text,
                                  'note': _noteController.text,
                                });

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (Route<dynamic> route) => false,
                                );
                              }
                            },
                            child: Text('Book Lesson'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
