// models/feedback.dart
class FeedbackItem {
  final String subject;
  final String teacher;
  final String message;
  final String imageUrl;
  
  FeedbackItem({
    required this.subject,
    required this.teacher,
    required this.message,
    required this.imageUrl,
  });
}