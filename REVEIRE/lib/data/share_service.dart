import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/quote.dart';

class ShareService {
  static Future<void> shareAsText(Quote quote, {BuildContext? context}) async {
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('"${quote.text}"');
    buffer.writeln();
    buffer.writeln('— ${quote.author}');
    if (quote.bookName != null && quote.bookName!.isNotEmpty) {
      buffer.writeln('📖 ${quote.bookName}');
    }
    buffer.writeln();
    buffer.writeln('#${quote.category} #Reverie #QuoteOfTheDay');

    await Share.share(buffer.toString(), subject: 'Quote by ${quote.author}');
  }

  static Future<void> copyToClipboard(BuildContext context, Quote quote) async {
    final text = '"${quote.text}"\n— ${quote.author}';

    await Clipboard.setData(ClipboardData(text: text));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Quote copied to clipboard'),
          backgroundColor: const Color(0xFF1A1207),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
