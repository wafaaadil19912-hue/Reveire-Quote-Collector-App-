import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // 🔑 Get your free key at https://openrouter.ai/keys
  static const String _apiKey =
      'YOUR_API_KEY_HERE'; // REPLACE WITH YOUR REAL KEY

  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'mistralai/mistral-7b-instruct:free';

  static Future<String> _ask(String prompt) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
        'HTTP-Referer': 'https://quotecollector.app',
        'X-Title': 'Quote Collector',
      },
      body: json.encode({
        'model': _model,
        'max_tokens': 1024,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['choices'][0]['message']['content'] as String).trim();
    } else {
      final error = json.decode(response.body);
      final msg = error['error']?['message'] ?? response.body;
      throw Exception('AIService error (${response.statusCode}): $msg');
    }
  }

  static String _clean(String raw) =>
      raw.replaceAll('```json', '').replaceAll('```', '').trim();

  static Future<List<Map<String, String>>> getSituationQuotes(
    String situation,
  ) async {
    final prompt =
        '''
You are a quote expert. The user is feeling or going through: "$situation"

Give exactly 7 relevant, powerful quotes for this situation.
Respond ONLY in this exact JSON format, nothing else, no extra text:
[
  {"quote": "quote text here", "author": "Author Name", "book": "Book Name or empty string"},
  {"quote": "quote text here", "author": "Author Name", "book": ""},
  {"quote": "quote text here", "author": "Author Name", "book": ""},
  {"quote": "quote text here", "author": "Author Name", "book": ""},
  {"quote": "quote text here", "author": "Author Name", "book": ""},
  {"quote": "quote text here", "author": "Author Name", "book": ""},
  {"quote": "quote text here", "author": "Author Name", "book": ""}
]
''';
    final result = await _ask(prompt);
    final List decoded = json.decode(_clean(result));
    return decoded
        .map(
          (e) => {
            'quote': (e['quote'] ?? '') as String,
            'author': (e['author'] ?? '') as String,
            'book': (e['book'] ?? '') as String,
          },
        )
        .toList();
  }

  static Future<Map<String, String>> getBookOverview(String bookName) async {
    final prompt =
        '''
Give a detailed overview of the book "$bookName".
Respond ONLY in this exact JSON format, nothing else, no extra text:
{
  "title": "exact book title",
  "author": "author name",
  "summary": "2-3 paragraph summary",
  "key_lessons": "5 key lessons, each on a new line starting with •",
  "why_read": "2-3 sentences on why someone should read this book",
  "genre": "genre of the book",
  "rating": "your rating out of 5 like 4.5/5"
}
''';
    final result = await _ask(prompt);
    final Map decoded = json.decode(_clean(result));
    return {
      'title': (decoded['title'] ?? '') as String,
      'author': (decoded['author'] ?? '') as String,
      'summary': (decoded['summary'] ?? '') as String,
      'key_lessons': (decoded['key_lessons'] ?? '') as String,
      'why_read': (decoded['why_read'] ?? '') as String,
      'genre': (decoded['genre'] ?? '') as String,
      'rating': (decoded['rating'] ?? '') as String,
    };
  }

  static Future<List<Map<String, String>>> getBookRecommendations(
    String interest,
  ) async {
    final prompt =
        '''
The user is interested in or feeling: "$interest"

Recommend exactly 6 books for them.
Respond ONLY in this exact JSON format, nothing else, no extra text:
[
  {"title": "Book Title", "author": "Author Name", "reason": "One sentence why this book fits", "genre": "Genre"},
  {"title": "Book Title", "author": "Author Name", "reason": "One sentence why this book fits", "genre": "Genre"},
  {"title": "Book Title", "author": "Author Name", "reason": "One sentence why this book fits", "genre": "Genre"},
  {"title": "Book Title", "author": "Author Name", "reason": "One sentence why this book fits", "genre": "Genre"},
  {"title": "Book Title", "author": "Author Name", "reason": "One sentence why this book fits", "genre": "Genre"},
  {"title": "Book Title", "author": "Author Name", "reason": "One sentence why this book fits", "genre": "Genre"}
]
''';
    final result = await _ask(prompt);
    final List decoded = json.decode(_clean(result));
    return decoded
        .map(
          (e) => {
            'title': (e['title'] ?? '') as String,
            'author': (e['author'] ?? '') as String,
            'reason': (e['reason'] ?? '') as String,
            'genre': (e['genre'] ?? '') as String,
          },
        )
        .toList();
  }
}
