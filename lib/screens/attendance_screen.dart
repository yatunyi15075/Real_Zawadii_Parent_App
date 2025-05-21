// screens/attendance_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample attendance data
    final attendanceData = [
      {'date': 'May 20, 2025', 'status': 'Present', 'icon': Icons.check_circle, 'color': Colors.green},
      {'date': 'May 19, 2025', 'status': 'Present', 'icon': Icons.check_circle, 'color': Colors.green},
      {'date': 'May 18, 2025', 'status': 'Absent', 'icon': Icons.cancel, 'color': Colors.red},
      {'date': 'May 17, 2025', 'status': 'Present', 'icon': Icons.check_circle, 'color': Colors.green},
      {'date': 'May 16, 2025', 'status': 'Late', 'icon': Icons.access_time, 'color': Colors.orange},
      {'date': 'May 15, 2025', 'status': 'Present', 'icon': Icons.check_circle, 'color': Colors.green},
      {'date': 'May 14, 2025', 'status': 'Present', 'icon': Icons.check_circle, 'color': Colors.green},
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.grey),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Term 2',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '2024-2025 Academic Year',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttendanceSummary('Present', '85%', Colors.green),
                  _buildAttendanceSummary('Late', '10%', Colors.orange),
                  _buildAttendanceSummary('Absent', '5%', Colors.red),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent Attendance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: attendanceData.length,
                  itemBuilder: (context, index) {
                    final data = attendanceData[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          data['icon'] as IconData,
                          color: data['color'] as Color,
                        ),
                        title: Text(data['date'] as String),
                        trailing: Text(
                          data['status'] as String,
                          style: TextStyle(
                            color: data['color'] as Color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }

  Widget _buildAttendanceSummary(String label, String percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              percentage,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}