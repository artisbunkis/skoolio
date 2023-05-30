import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/models/subject_model.dart';
import 'package:skoolio/app/services/auth_service.dart';
import 'package:skoolio/app/services/firestore_service.dart';

class AddLessonScreen extends StatefulWidget {
  @override
  _AddLessonScreenState createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  late String _title;
  late String _description;
  late Subject _selectedSubject = Subject(id: '', name: 'Select Subject');
  late double _price;
  late String _currentUser = ''; // Replace with actual user information

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = await _authService.getCurrentUser();
    if (user != null) {
      setState(() {
        _currentUser = user.email ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lesson'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the lesson title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<Subject>(
                value: _selectedSubject,
                items: _buildDropdownItems(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubject = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.name == 'Select Subject') {
                    return 'Please select a subject';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the lesson description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the lesson price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Lesson newLesson = Lesson(
                      title: _title,
                      user: _currentUser,
                      rating: 0.0,
                      price: _price,
                      description: _description,
                      imageUrl: '',
                      subject: _selectedSubject.name,
                    );

                    _firestoreService.addLessonToFirestore(
                        newLesson); // Save the new lesson to Firestore

                    Navigator.pop(context,
                        newLesson); // Return the new lesson to the previous screen
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Subject>> _buildDropdownItems() {
    List<DropdownMenuItem<Subject>> items = [];
    items.add(
      DropdownMenuItem(
        value: _selectedSubject,
        child: Text(_selectedSubject.name),
      ),
    );

    // Fetch subjects from Firestore and add them to the dropdown menu
    _firestoreService.getSubjectsFromFirestore().listen((subjects) {
      setState(() {
        items.addAll(subjects.map((subject) => DropdownMenuItem(
              value: subject,
              child: Text(subject.name),
            )));
      });
    });

    return items;
  }
}
