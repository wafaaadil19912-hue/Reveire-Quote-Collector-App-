import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/quote.dart';

const _uuid = Uuid();

class QuotesProvider extends ChangeNotifier {
  List<Quote> _quotes = [];
  String _selectedCategory = 'All';

  List<Quote> get quotes => _quotes;
  String get selectedCategory => _selectedCategory;

  List<Quote> get filteredQuotes {
    if (_selectedCategory == 'All') return _quotes;
    if (_selectedCategory == 'Favorites')
      return _quotes.where((q) => q.isFavorite).toList();
    return _quotes.where((q) => q.category == _selectedCategory).toList();
  }

  List<Quote> get favorites => _quotes.where((q) => q.isFavorite).toList();

  QuotesProvider() {
    _loadQuotes();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void addQuote({
    required String text,
    required String author,
    required String bookName,
    required String category,
  }) {
    final quote = Quote(
      id: _uuid.v4(),
      text: text,
      author: author,
      bookName: bookName,
      category: category,
      createdAt: DateTime.now(),
    );
    _quotes.insert(0, quote);
    _saveQuotes();
    notifyListeners();
  }

  void editQuote(
    String id, {
    required String text,
    required String author,
    required String bookName,
    required String category,
  }) {
    final index = _quotes.indexWhere((q) => q.id == id);
    if (index != -1) {
      _quotes[index] = _quotes[index].copyWith(
        text: text,
        author: author,
        bookName: bookName,
        category: category,
      );
      _saveQuotes();
      notifyListeners();
    }
  }

  void deleteQuote(String id) {
    _quotes.removeWhere((q) => q.id == id);
    _saveQuotes();
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _quotes.indexWhere((q) => q.id == id);
    if (index != -1) {
      _quotes[index].isFavorite = !_quotes[index].isFavorite;
      _saveQuotes();
      notifyListeners();
    }
  }

  Future<void> _loadQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('quotes');

      print('📖 Loading quotes from storage...');

      if (data != null && data.isNotEmpty) {
        final List decoded = json.decode(data);
        _quotes = decoded.map((e) => Quote.fromMap(e)).toList();
        print('✅ Loaded ${_quotes.length} quotes from storage');
      } else {
        print('⚠️ No saved quotes found, loading defaults');
        _quotes = _defaultQuotes();
        // Save default quotes immediately
        await _saveQuotes();
      }
    } catch (e) {
      print('❌ Error loading quotes: $e');
      _quotes = _defaultQuotes();
    }
    notifyListeners();
  }

  Future<void> _saveQuotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = json.encode(_quotes.map((q) => q.toMap()).toList());
      await prefs.setString('quotes', data);
      print('💾 Saved ${_quotes.length} quotes to storage');
    } catch (e) {
      print('❌ Error saving quotes: $e');
    }
  }

  List<Quote> _defaultQuotes() => [
    Quote(
      id: _uuid.v4(),
      text: "The secret of getting ahead is getting started.",
      author: "Mark Twain",
      bookName: "",
      category: "Motivation",
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Quote(
      id: _uuid.v4(),
      text: "In the middle of every difficulty lies opportunity.",
      author: "Albert Einstein",
      bookName: "",
      category: "Resilience",
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Quote(
      id: _uuid.v4(),
      text: "The only way to do great work is to love what you do.",
      author: "Steve Jobs",
      bookName: "",
      category: "Chasing Dreams",
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Quote(
      id: _uuid.v4(),
      text: "An investment in knowledge pays the best interest.",
      author: "Benjamin Franklin",
      bookName: "Poor Richard's Almanack",
      category: "Study",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Quote(
      id: _uuid.v4(),
      text: "Life is what happens when you're busy making other plans.",
      author: "John Lennon",
      bookName: "",
      category: "Life",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Quote(
      id: _uuid.v4(),
      text: "The wisest mind has something yet to learn.",
      author: "George Santayana",
      bookName: "",
      category: "Wisdom",
      createdAt: DateTime.now(),
    ),
  ];
}
