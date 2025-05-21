// models/notification.dart
import 'package:flutter/material.dart'; // Added this import for IconData

class NotificationItem {
  final String title;
  final String timeAgo;
  final bool isRead;
  final IconData icon;
  
  NotificationItem({
    required this.title,
    required this.timeAgo,
    required this.isRead,
    required this.icon,
  });
}