import 'package:flutter/material.dart';
import 'package:skoolio/app/models/lesson_model.dart';
import 'package:skoolio/app/screens/lesson_screen.dart';

class LessonListView extends StatefulWidget {
  final List<Lesson> lessons;

  const LessonListView({Key? key, required this.lessons}) : super(key: key);

  @override
  _LessonListViewState createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  List<Lesson> _getFilteredLessons() {
    if (_searchQuery.isEmpty) {
      return widget.lessons;
    }
    return widget.lessons
        .where((lesson) =>
            lesson.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            lesson.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Lesson> filteredLessons = _getFilteredLessons();

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search lessons',
              border: InputBorder.none,
            ),
          ),
          floating: true,
        ),
        SliverPadding(
          padding: EdgeInsets.all(16.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lesson = filteredLessons[index];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final cardHeight = constraints.maxHeight;
                    final imageHeight = cardHeight * 0.5;

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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.0),
                              ),
                              child: Image.asset(
                                lesson.imageUrl,
                                width: double.infinity,
                                height: imageHeight,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    lesson.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Text('By ${lesson.user}'),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        lesson.rating.toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '\$${lesson.price.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: filteredLessons.length,
            ),
          ),
        ),
      ],
    );
  }
}
