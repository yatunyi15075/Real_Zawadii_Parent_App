// screens/attendance_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample attendance data
    final attendanceData = [
      {'date': 'May 20, 2025', 'status': 'Present', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981)},
      {'date': 'May 19, 2025', 'status': 'Present', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981)},
      {'date': 'May 18, 2025', 'status': 'Absent', 'icon': Icons.cancel_rounded, 'color': const Color(0xFFEF4444)},
      {'date': 'May 17, 2025', 'status': 'Present', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981)},
      {'date': 'May 16, 2025', 'status': 'Late', 'icon': Icons.access_time_rounded, 'color': const Color(0xFFF59E0B)},
      {'date': 'May 15, 2025', 'status': 'Present', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981)},
      {'date': 'May 14, 2025', 'status': 'Present', 'icon': Icons.check_circle_rounded, 'color': const Color(0xFF10B981)},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Attendance',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Term Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_today_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Term 2',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '2024-2025 Academic Year',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Attendance Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildModernAttendanceSummary(
                        'Present', 
                        '85%', 
                        const Color(0xFF10B981),
                        Icons.trending_up_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernAttendanceSummary(
                        'Late', 
                        '10%', 
                        const Color(0xFFF59E0B),
                        Icons.access_time_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModernAttendanceSummary(
                        'Absent', 
                        '5%', 
                        const Color(0xFFEF4444),
                        Icons.trending_down_rounded,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Recent Attendance Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Attendance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.filter_list_rounded,
                        size: 18,
                        color: Color(0xFF6366F1),
                      ),
                      label: const Text(
                        'Filter',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Attendance List
                ...attendanceData.map((data) => _buildModernAttendanceItem(data)).toList(),
                const SizedBox(height: 80), // Space for bottom navigation
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }

  Widget _buildModernAttendanceSummary(String label, String percentage, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            percentage,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernAttendanceItem(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (data['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              data['icon'] as IconData,
              color: data['color'] as Color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['date'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatusDescription(data['status'] as String),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: (data['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              data['status'] as String,
              style: TextStyle(
                color: data['color'] as Color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'Present':
        return 'On time arrival';
      case 'Late':
        return 'Arrived after start time';
      case 'Absent':
        return 'Did not attend';
      default:
        return '';
    }
  }
}