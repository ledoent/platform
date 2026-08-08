/// Escape HTML special characters for safe embedding in markup.
String escapeHtml(String text) {
  return text
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');
}

/// Strip HTML tags and trim whitespace.
String stripHtml(String html) {
  return html.replaceAll(RegExp(r'<[^>]*>'), '').trim();
}

/// Format a millisecond timestamp to a short date/time string.
String formatTimestamp(int? timestamp) {
  if (timestamp == null) return '';
  final dt = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
}
