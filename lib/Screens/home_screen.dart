import 'package:book_library/controller/network_services.dart';
import 'package:book_library/model/books_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookList extends StatefulWidget {
  const BookList({super.key});

  @override
  BookListState createState() => BookListState();
}

class BookListState extends State<BookList> {
  final NetworkService _networkService = NetworkService();
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = _networkService.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return BookCard(book: snapshot.data![index]);
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  BookCardState createState() => BookCardState();
}

class BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover image
            widget.book.coverId != -1
                ? CachedNetworkImage(
                    imageUrl:
                        'https://covers.openlibrary.org/b/id/${widget.book.coverId}-M.jpg',
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Container(
                    width: 80,
                    height: 120,
                    color: Colors.grey,
                    child: const Center(child: Text('No Cover')),
                  ),
            const SizedBox(width: 16),
            // Book Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('by ${widget.book.author}'),
                  const SizedBox(height: 4),
                  Text('Published: ${widget.book.publishedYear}'),
                  const SizedBox(height: 8),
                  // Read/Unread Button
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.book.isRead = !widget.book.isRead;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.book.isRead
                          ? Colors.green
                          : Colors.transparent,
                      side: BorderSide(
                          width: 1.0,
                          color: widget.book.isRead
                              ? Colors.transparent
                              : Colors.grey),
                    ),
                    child: Text(widget.book.isRead ? 'Read' : 'Unread'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
