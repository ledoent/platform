import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

/// Reads shared content from the iOS App Group UserDefaults.
/// The native share extension writes JSON to the app group,
/// and this service reads/clears it.
class ShareHandler {
  static const _channel = MethodChannel('com.ledoweb.huly/share');

  /// Check for pending shared content from the share extension.
  /// Returns null if nothing is pending.
  static Future<SharedContent?> getPendingShare() async {
    try {
      final result = await _channel.invokeMethod<String>('getPendingShare');
      if (result == null || result.isEmpty) return null;
      final json = jsonDecode(result) as Map<String, dynamic>;
      return SharedContent(
        text: json['text'] as String?,
        url: json['url'] as String?,
      );
    } on PlatformException {
      return null;
    }
  }

  /// Clear pending share data after it has been consumed.
  static Future<void> clearPendingShare() async {
    try {
      await _channel.invokeMethod('clearPendingShare');
    } on PlatformException {
      // Ignore — share data may already be cleared.
    }
  }
}

class SharedContent {
  final String? text;
  final String? url;

  SharedContent({this.text, this.url});

  /// Build a title for the issue from shared content.
  String get suggestedTitle {
    if (text != null && text!.isNotEmpty) {
      final firstLine = text!.split('\n').first.trim();
      return firstLine.length > 100
          ? '${firstLine.substring(0, 100)}...'
          : firstLine;
    }
    if (url != null) return 'Shared: $url';
    return '';
  }

  /// Build a description for the issue from shared content.
  String get suggestedDescription {
    final parts = <String>[];
    if (text != null && text!.isNotEmpty) parts.add(text!);
    if (url != null && url!.isNotEmpty) parts.add(url!);
    return parts.join('\n\n');
  }
}
