import 'package:flutter/material.dart';
import '../theme/huly_theme.dart';
import '../utils/html.dart';

/// Shared message bubble used in activity feeds and chat threads.
class MessageBubble extends StatelessWidget {
  final String authorName;
  final String messageHtml;
  final int? timestamp;
  final double avatarRadius;

  const MessageBubble({
    super.key,
    required this.authorName,
    required this.messageHtml,
    this.timestamp,
    this.avatarRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final text = stripHtml(messageHtml);
    final initial =
        authorName.isNotEmpty ? authorName[0].toUpperCase() : '?';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: avatarRadius,
            backgroundColor: HulyColors.inputFill,
            child: Text(
              initial,
              style: TextStyle(
                color: HulyColors.contentText,
                fontSize: avatarRadius - 2,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      authorName,
                      style: const TextStyle(
                        color: HulyColors.contentText,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatTimestamp(timestamp),
                      style: const TextStyle(
                        color: HulyColors.darkerText,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: HulyColors.contentText,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
