import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {

  // ─── USER PROFILE ───
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? '';
  }

  static Future<void> saveInterests(List<String> interests) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('interests', json.encode(interests));
  }

  static Future<List<String>> getInterests() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('interests');
    if (data == null) return [];
    return List<String>.from(json.decode(data));
  }

  // ─── CHAT HISTORY ───
  static Future<void> saveChatMessage({
    required String userMessage,
    required String aiResponse,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('chat_history');
    List chats = existing != null ? json.decode(existing) : [];
    chats.insert(0, {
      'userMessage': userMessage,
      'aiResponse': aiResponse,
      'timestamp': DateTime.now().toIso8601String(),
    });
    if (chats.length > 50) chats = chats.sublist(0, 50);
    await prefs.setString('chat_history', json.encode(chats));
  }

  static Future<List<Map<String, dynamic>>> getChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('chat_history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  // ─── BOOK HISTORY ───
  static Future<void> saveBookHistory({
    required String title,
    required String author,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('book_history');
    List books = existing != null ? json.decode(existing) : [];
    books.removeWhere((b) => b['title'] == title);
    books.insert(0, {
      'title': title,
      'author': author,
      'viewedAt': DateTime.now().toIso8601String(),
    });
    await prefs.setString('book_history', json.encode(books));
  }

  static Future<List<Map<String, dynamic>>> getBookHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('book_history');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  // ─── FAVOURITE QUOTES ───
  static Future<void> saveFavouriteQuote({
    required String quote,
    required String author,
    required String book,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('favourite_quotes');
    List quotes = existing != null ? json.decode(existing) : [];
    quotes.removeWhere((q) => q['quote'] == quote);
    quotes.insert(0, {
      'quote': quote,
      'author': author,
      'book': book,
      'savedAt': DateTime.now().toIso8601String(),
    });
    await prefs.setString('favourite_quotes', json.encode(quotes));
  }

  static Future<List<Map<String, dynamic>>> getFavouriteQuotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('favourite_quotes');
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(data));
  }

  static Future<void> removeFavouriteQuote(String quote) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString('favourite_quotes');
    List quotes = existing != null ? json.decode(existing) : [];
    quotes.removeWhere((q) => q['quote'] == quote);
    await prefs.setString('favourite_quotes', json.encode(quotes));
  }

  // ─── CLEAR ALL DATA ───
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}