class Book {
  int coverId;
  String title;
  String author;
  int publishedYear;
  bool isRead;

  Book({
    required this.coverId,
    required this.title,
    required this.author,
    required this.publishedYear,
    this.isRead = false, // Default to unread
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      coverId: json['cover_i'] ?? -1, // Use -1 if the cover ID is missing
      title: json['title'],
      author: json['author_name']?.first ?? 'Unknown',
      publishedYear: json['publish_date'] != null 
          ? int.tryParse(json['publish_date'].first.substring(0, 4)) ?? 0
          : 0, // Handle potential parsing errors and missing publish dates
    );
  }
}
