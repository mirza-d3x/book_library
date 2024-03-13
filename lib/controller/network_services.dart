import 'dart:developer';

import 'package:book_library/model/books_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(
        'https://openlibrary.org/people/mekBot/books/already-read.json'));

    log("[RESPONSE] code: ${response.statusCode} Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['entries'] as List;

      return jsonData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> searchBooks(String query) async {
    final response = await http
        .get(Uri.parse('https://openlibrary.org/search.json?title=$query'));
    log("[RESPONSE] code: ${response.statusCode} Body: ${response.body}");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body)['docs'] as List;
      return jsonData.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search books');
    }
  }
}
