import 'dart:convert';

class Quote {
  final String id;
  final String text;
  final String author;
  final String bookName;
  final String category;
  bool isFavorite;
  final DateTime createdAt;

  Quote({
    required this.id,
    required this.text,
    required this.author,
    this.bookName = '',
    required this.category,
    this.isFavorite = false,
    required this.createdAt,
  });

  Quote copyWith({
    String? id,
    String? text,
    String? author,
    String? bookName,
    String? category,
    bool? isFavorite,
    DateTime? createdAt,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      bookName: bookName ?? this.bookName,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'bookName': bookName,
      'category': category,
      'isFavorite': isFavorite,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Quote.fromMap(Map<String, dynamic> map) {
    return Quote(
      id: map['id'],
      text: map['text'],
      author: map['author'],
      bookName: map['bookName'] ?? '',
      category: map['category'],
      isFavorite: map['isFavorite'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());
  factory Quote.fromJson(String source) =>
      Quote.fromMap(json.decode(source));
}