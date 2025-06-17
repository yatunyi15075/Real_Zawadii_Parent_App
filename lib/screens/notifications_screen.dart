// screens/notifications_screen.dart
import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../widgets/nav_bar.dart';
import '../screens/settings_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data with enhanced notification items
    final notifications = [
      NotificationItem(
        title: 'School closure today',
        timeAgo: '2h ago',
        isRead: false,
        icon: Icons.warning_amber_rounded,
      ),
      NotificationItem(
        title: 'Parent-Teacher Conference',
        timeAgo: '4h ago',
        isRead: true,
        icon: Icons.event_outlined,
      ),
      NotificationItem(
        title: 'New announcement from Principal',
        timeAgo: '5h ago',
        isRead: true,
        icon: Icons.campaign_outlined,
      ),
      NotificationItem(
        title: 'Winter break starts next week',
        timeAgo: '6h ago',
        isRead: true,
        icon: Icons.ac_unit_outlined,
      ),
      NotificationItem(
        title: 'Parent-Teacher Conference',
        timeAgo: '8h ago',
        isRead: true,
        icon: Icons.event_outlined,
      ),
      NotificationItem(
        title: 'Assignment deadline reminder',
        timeAgo: '1d ago',
        isRead: true,
        icon: Icons.assignment_outlined,
      ),
    ];

    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          if (unreadCount > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$unreadCount new',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.settings_outlined,
                            color: Color(0xFF64748B),
                            size: 22,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsScreen(),
                              ),
                            );
                          },
                          tooltip: 'Settings',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: notifications.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 3),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    Color iconColor;
    Color iconBgColor;
    
    // Dynamic color based on notification type
    switch (notification.icon) {
      case Icons.warning_amber_rounded:
        iconColor = const Color(0xFFF59E0B);
        iconBgColor = const Color(0xFFFEF3C7);
        break;
      case Icons.event_outlined:
        iconColor = const Color(0xFF3B82F6);
        iconBgColor = const Color(0xFFDBEAFE);
        break;
      case Icons.campaign_outlined:
        iconColor = const Color(0xFF8B5CF6);
        iconBgColor = const Color(0xFFEDE9FE);
        break;
      case Icons.ac_unit_outlined:
        iconColor = const Color(0xFF06B6D4);
        iconBgColor = const Color(0xFFCFFAFE);
        break;
      case Icons.assignment_outlined:
        iconColor = const Color(0xFF10B981);
        iconBgColor = const Color(0xFFD1FAE5);
        break;
      default:
        iconColor = const Color(0xFF6B7280);
        iconBgColor = const Color(0xFFF3F4F6);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notification.isRead 
              ? Colors.transparent 
              : const Color(0xFFEF4444).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle notification tap
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: notification.isRead 
                                    ? FontWeight.w500 
                                    : FontWeight.w600,
                                color: const Color(0xFF0F172A),
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action Button
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFF94A3B8),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.notifications_none_outlined,
              size: 40,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'When you receive notifications,\nthey\'ll appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}