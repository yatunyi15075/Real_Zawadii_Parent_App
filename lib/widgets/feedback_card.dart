// widgets/feedback_card.dart
import 'package:flutter/material.dart';
import '../models/feedback.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackItem feedback; // Changed from Feedback to FeedbackItem
  final VoidCallback? onTap;

  const FeedbackCard({
    super.key,
    required this.feedback,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                feedback.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[200],
                    child: Icon(
                      _getSubjectIcon(feedback.subject),
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feedback.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    feedback.teacher,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _truncateMessage(feedback.message),
                    style: TextStyle(
                      fontSize: 12,
                      color: _getMessageColor(feedback.message),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null) const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
        return Icons.calculate;
      case 'reading':
      case 'english':
      case 'literature':
        return Icons.menu_book;
      case 'science':
        return Icons.science;
      case 'history':
      case 'social studies':
        return Icons.history_edu;
      case 'art':
        return Icons.palette;
      case 'music':
        return Icons.music_note;
      case 'physical education':
      case 'pe':
        return Icons.sports_basketball;
      default:
        return Icons.book;
    }
  }

  Color _getMessageColor(String message) {
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('great') || 
        lowerMessage.contains('excellent') || 
        lowerMessage.contains('good job')) {
      return Colors.green;
    } else if (lowerMessage.contains('please') || 
               lowerMessage.contains('see me') || 
               lowerMessage.contains('attention')) {
      return Colors.red[400]!;
    } else {
      return Colors.grey[700]!;
    }
  }

  String _truncateMessage(String message) {
    if (message.length <= 50) return message;
    return message.substring(0, 47) + '...';
  }
}