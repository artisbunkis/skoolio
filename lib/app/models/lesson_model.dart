class Lesson {
  final int id;
  final String title;
  final String user;
  final double rating;
  final double price;
  final String description;
  final String imageUrl;
  final String subject;

  Lesson({
    required this.id,
    required this.title,
    required this.user,
    required this.rating,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.subject,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      user: json['user'],
      rating: json['rating'].toDouble(),
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      subject: json['subject'],
    );
  }
}
