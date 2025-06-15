// screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/grade.dart';
import '../models/feedback.dart';
import '../widgets/nav_bar.dart';
import '../screens/settings_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/assignments_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // CBC Curriculum rubric levels instead of letter grades
    final grades = [
      Grade(subject: 'Mathematics', grade: 'Exceeding Expectations', teacher: 'Mr. White'),
      Grade(subject: 'Kiswahili', grade: 'Meeting Expectations', teacher: 'Mrs. Wanjiku'),
      Grade(subject: 'English', grade: 'Exceeding Expectations', teacher: 'Ms. Johnson'),
      Grade(subject: 'Science & Technology', grade: 'Meeting Expectations', teacher: 'Mr. Kimani'),
      Grade(subject: 'Social Studies', grade: 'Approaching Expectations', teacher: 'Mrs. Ochieng'),
      Grade(subject: 'Creative Arts', grade: 'Meeting Expectations', teacher: 'Mr. Mwangi'),
    ];

    final feedbacks = [
      FeedbackItem(
        subject: 'Mathematics',
        teacher: 'Mr. White',
        message: 'Excellent problem-solving skills shown in algebra.',
        imageUrl: 'assets/images/math.png',
      ),
      FeedbackItem(
        subject: 'Science & Technology',
        teacher: 'Mr. Kimani',
        message: 'Great participation in laboratory experiments.',
        imageUrl: 'assets/images/science.png',
      ),
      FeedbackItem(
        subject: 'Creative Arts',
        teacher: 'Mr. Mwangi',
        message: 'Outstanding creativity in art projects.',
        imageUrl: 'assets/images/arts.png',
      ),
    ];

    final comments = [
      {
        'teacher': 'Class Teacher - Mrs. Njeri',
        'comment': 'Luna is showing remarkable progress in all learning areas. Her collaborative skills have improved significantly.',
        'date': '2 days ago',
      },
      {
        'teacher': 'Deputy Head Teacher',
        'comment': 'Excellent performance in the recent CBC assessment. Keep up the good work!',
        'date': '1 week ago',
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade600,
                        Colors.blue.shade400,
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Luna\'s Progress',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick Stats Cards with Navigation
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AttendanceScreen(),
                                ),
                              );
                            },
                            child: _buildStatCard(
                              'Attendance',
                              '95%',
                              Icons.calendar_today,
                              Colors.green,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AssignmentsScreen(),
                                ),
                              );
                            },
                            child: _buildStatCard(
                              'Assignments',
                              '12/15',
                              Icons.assignment,
                              Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // CBC Learning Areas Performance
                    _buildSectionHeader(
                      'CBC Learning Areas',
                      'Current Term Performance',
                      Icons.school,
                    ),
                    const SizedBox(height: 16),
                    
                    ...grades.map((grade) => _buildGradeCard(grade)).toList(),
                    
                    const SizedBox(height: 32),
                    
                    // Recent Feedback
                    _buildSectionHeader(
                      'Recent Feedback',
                      'From Teachers',
                      Icons.feedback,
                    ),
                    const SizedBox(height: 16),
                    
                    ...feedbacks.map((feedback) => _buildFeedbackCard(feedback)).toList(),
                    
                    const SizedBox(height: 32),
                    
                    // Teacher Comments
                    _buildSectionHeader(
                      'Teacher Comments',
                      'Latest Updates',
                      Icons.comment,
                    ),
                    const SizedBox(height: 16),
                    
                    ...comments.map((comment) => _buildCommentCard(comment)).toList(),
                    
                    const SizedBox(height: 100), // Bottom padding for nav bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.blue.shade600, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGradeCard(Grade grade) {
    Color getGradeColor(String gradeLevel) {
      switch (gradeLevel) {
        case 'Exceeding Expectations':
          return Colors.green;
        case 'Meeting Expectations':
          return Colors.blue;
        case 'Approaching Expectations':
          return Colors.orange;
        case 'Below Expectations':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: getGradeColor(grade.grade),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  grade.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grade.teacher,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: getGradeColor(grade.grade).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              grade.grade,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: getGradeColor(grade.grade),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard(FeedbackItem feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.star,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feedback.subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feedback.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feedback.teacher,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey.shade400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Map<String, String> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),

        border: Border(left: BorderSide(
          color: Colors.blue.shade300,
          width: 4,

        )),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comment['teacher']!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              Text(
                comment['date']!,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment['comment']!,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}