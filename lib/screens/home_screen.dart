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
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Enhanced App Bar - Fixed overflow issue
            SliverAppBar(
              expandedHeight: 150, // Increased height to accommodate content
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF3B82F6),
                        Color(0xFF60A5FA),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 40,
                        right: 20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      // Fixed content positioning and sizing
                      Positioned(
                        left: 24,
                        right: 80, // Leave space for settings button
                        bottom: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // Important: minimize column size
                          children: [
                            Text(
                              'Good Morning!',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14, // Reduced font size
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2), // Reduced spacing
                            Text(
                              'Luna\'s Academic Journey',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24, // Reduced font size
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                              maxLines: 1, // Ensure single line
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 20, top: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 22),
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Quick Stats Cards
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
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
                              child: _buildEnhancedStatCard(
                                'Attendance Rate',
                                '95%',
                                Icons.calendar_today_outlined,
                                const Color(0xFF10B981),
                                const Color(0xFFD1FAE5),
                                '+2% from last month',
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 80,
                            color: Colors.grey.shade100,
                          ),
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
                              child: _buildEnhancedStatCard(
                                'Assignments',
                                '12/15',
                                Icons.assignment_outlined,
                                const Color(0xFFF59E0B),
                                const Color(0xFFFEF3C7),
                                '3 pending',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // CBC Learning Areas Performance
                    _buildEnhancedSectionHeader(
                      'Academic Performance',
                      'CBC Learning Areas - Current Term',
                      Icons.school_outlined,
                      Colors.blue.shade600,
                    ),
                    const SizedBox(height: 20),
                    
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: grades.asMap().entries.map((entry) {
                          int index = entry.key;
                          Grade grade = entry.value;
                          bool isLast = index == grades.length - 1;
                          return _buildEnhancedGradeCard(grade, isLast);
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Recent Feedback
                    _buildEnhancedSectionHeader(
                      'Teacher Feedback',
                      'Recent highlights from your teachers',
                      Icons.star_outline,
                      Colors.amber.shade600,
                    ),
                    const SizedBox(height: 20),
                    
                    ...feedbacks.map((feedback) => _buildEnhancedFeedbackCard(feedback)).toList(),
                    
                    const SizedBox(height: 40),
                    
                    // Teacher Comments
                    _buildEnhancedSectionHeader(
                      'Latest Updates',
                      'Comments and observations',
                      Icons.chat_bubble_outline,
                      Colors.purple.shade600,
                    ),
                    const SizedBox(height: 20),
                    
                    ...comments.map((comment) => _buildEnhancedCommentCard(comment)).toList(),
                    
                    const SizedBox(height: 120), // Bottom padding for nav bar
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

  Widget _buildEnhancedStatCard(String title, String value, IconData icon, Color color, Color bgColor, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSectionHeader(String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedGradeCard(Grade grade, bool isLast) {
    Color getGradeColor(String gradeLevel) {
      switch (gradeLevel) {
        case 'Exceeding Expectations':
          return const Color(0xFF10B981);
        case 'Meeting Expectations':
          return const Color(0xFF3B82F6);
        case 'Approaching Expectations':
          return const Color(0xFFF59E0B);
        case 'Below Expectations':
          return const Color(0xFFEF4444);
        default:
          return Colors.grey;
      }
    }

    IconData getSubjectIcon(String subject) {
      switch (subject.toLowerCase()) {
        case 'mathematics':
          return Icons.calculate_outlined;
        case 'kiswahili':
          return Icons.translate_outlined;
        case 'english':
          return Icons.book_outlined;
        case 'science & technology':
          return Icons.science_outlined;
        case 'social studies':
          return Icons.public_outlined;
        case 'creative arts':
          return Icons.palette_outlined;
        default:
          return Icons.subject_outlined;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: isLast ? null : Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: getGradeColor(grade.grade).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              getSubjectIcon(grade.subject),
              color: getGradeColor(grade.grade),
              size: 24,
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
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  grade.teacher,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: getGradeColor(grade.grade).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: getGradeColor(grade.grade).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getShortGrade(grade.grade),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: getGradeColor(grade.grade),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getShortGrade(String grade) {
    switch (grade) {
      case 'Exceeding Expectations':
        return 'EXCEEDING';
      case 'Meeting Expectations':
        return 'MEETING';
      case 'Approaching Expectations':
        return 'APPROACHING';
      case 'Below Expectations':
        return 'BELOW';
      default:
        return grade.toUpperCase();
    }
  }

  Widget _buildEnhancedFeedbackCard(FeedbackItem feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade400,
                  Colors.amber.shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 24,
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
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  feedback.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'From ${feedback.teacher}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey.shade400,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedCommentCard(Map<String, String> comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.purple.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.purple.shade600,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  comment['teacher']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  comment['date']!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              comment['comment']!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}