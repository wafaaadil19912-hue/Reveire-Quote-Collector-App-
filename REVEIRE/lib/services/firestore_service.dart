import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => FirebaseAuth.instance.currentUser!.uid;

  // Save AI-generated book recommendation
  Future<void> saveBookRecommendation({
    required String title,
    required String author,
    required String reason,
    required String genre,
  }) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('savedBookRecommendations')
        .add({
          'title': title,
          'author': author,
          'reason': reason,
          'genre': genre,
          'savedAt': Timestamp.now(),
        });
  }

  // Get saved book recommendations
  Stream<QuerySnapshot> getSavedBookRecommendations() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('savedBookRecommendations')
        .orderBy('savedAt', descending: true)
        .snapshots();
  }

  // Save AI-generated quote
  Future<void> saveAIQuote({
    required String quote,
    required String author,
    required String book,
    required String situation,
  }) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('savedAIQuotes')
        .add({
          'quote': quote,
          'author': author,
          'book': book,
          'situation': situation,
          'savedAt': Timestamp.now(),
        });
  }

  // Save user's personal quote
  Future<void> saveUserQuote({
    required String quote,
    required String author,
    required String bookName,
    required String category,
  }) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('myQuotes')
        .add({
          'quote': quote,
          'author': author,
          'bookName': bookName,
          'category': category,
          'createdAt': Timestamp.now(),
          'isFavorite': false,
        });
  }

  // Toggle favorite status
  Future<void> toggleFavorite(String quoteId, bool isFavorite) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('myQuotes')
        .doc(quoteId)
        .update({'isFavorite': isFavorite});
  }

  // Delete quote
  Future<void> deleteQuote(String quoteId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('myQuotes')
        .doc(quoteId)
        .delete();
  }

  // Get user's quotes
  Stream<QuerySnapshot> getUserQuotes() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('myQuotes')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
