// models/notification.dart
import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String timeAgo;
  bool isRead;
  final IconData icon;
  final String section;
  final String? date;

  NotificationItem({
    required this.id,
    required this.title,
    required this.timeAgo,
    required this.isRead,
    required this.icon,
    this.section = '',
    this.date,
  });

  // Factory constructor to create from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      title: json['announcement'] ?? 'No title',
      timeAgo: '', // Will be calculated separately
      isRead: json['isRead'] ?? false,
      icon: Icons.notifications_outlined, // Will be set based on section
      section: json['section'] ?? 'General',
      date: json['date'],
    );
  }

  // Convert to JSON (useful for local storage or API calls)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timeAgo': timeAgo,
      'isRead': isRead,
      'section': section,
      'date': date,
    };
  }
}