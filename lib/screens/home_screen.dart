// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grade.dart';
import '../models/feedback.dart';
import '../widgets/nav_bar.dart';
import '../screens/settings_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/assignments_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Grade> grades = [];
  List<FeedbackItem> feedbacks = [];
  List<Map<String, String>> comments = [];
  Map<String, dynamic> stats = {};
  
  // Individual loading states for each section
  bool isLoadingStats = true;
  bool isLoadingGrades = true;
  bool isLoadingFeedbacks = true;
  bool isLoadingComments = true;
  
  // Individual error states for each section
  String statsError = '';
  String gradesError = '';
  String feedbacksError = '';
  String commentsError = '';
  
  String? authToken;

  // Replace with your actual API base URL
  static const String API_BASE_URL = 'https://zawadi-project.onrender.com';

  @override
  void initState() {
    super.initState();
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    await _getAuthToken();
    await _loadData();
  }

  Future<void> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token');
  }

  Future<void> _loadData() async {
    // Load all data sections independently
    _fetchStats();
    _fetchGrades();
    _fetchFeedbacks();
    _fetchComments();
  }

  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  Future<void> _fetchGrades() async {
    setState(() {
      isLoadingGrades = true;
      gradesError = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/grades'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['grades'] ?? [];

        setState(() {
          grades = data.map((item) => Grade(
            subject: item['subject'] ?? 'Unknown Subject',
            grade: item['grade'] ?? 'No Grade',
            teacher: item['teacher'] ?? 'Unknown Teacher',
          )).toList();
          isLoadingGrades = false;
        });
      } else {
        throw Exception('Failed to load grades: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching grades: $e');
      setState(() {
        gradesError = 'Failed to load academic performance data';
        isLoadingGrades = false;
      });
    }
  }

  Future<void> _fetchFeedbacks() async {
    setState(() {
      isLoadingFeedbacks = true;
      feedbacksError = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/feedbacks'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['feedbacks'] ?? [];

        setState(() {
          feedbacks = data.map((item) => FeedbackItem(
            subject: item['subject'] ?? 'Unknown Subject',
            teacher: item['teacher'] ?? 'Unknown Teacher',
            message: item['message'] ?? 'No message available',
            imageUrl: item['imageUrl'] ?? 'assets/images/default.png',
          )).toList();
          isLoadingFeedbacks = false;
        });
      } else {
        throw Exception('Failed to load feedbacks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching feedbacks: $e');
      setState(() {
        feedbacksError = 'Failed to load teacher feedback';
        isLoadingFeedbacks = false;
      });
    }
  }

  Future<void> _fetchComments() async {
    setState(() {
      isLoadingComments = true;
      commentsError = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/comments'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['comments'] ?? [];

        setState(() {
          comments = data.map((item) => {
            'teacher': (item['teacher'] ?? 'Unknown Teacher').toString(),
            'comment': (item['comment'] ?? 'No comment available').toString(),
            'date': (item['date'] ?? 'Unknown date').toString(),
          }).toList();
          isLoadingComments = false;
        });
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        commentsError = 'Failed to load latest updates';
        isLoadingComments = false;
      });
    }
  }

  Future<void> _fetchStats() async {
    setState(() {
      isLoadingStats = true;
      statsError = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/stats'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final Map<String, dynamic> data = responseData['stats'] ?? {};

        setState(() {
          stats = {
            'attendance_rate': data['attendance_rate'] ?? '0%',
            'attendance_trend': data['attendance_trend'] ?? 'No data',
            'assignments_completed': data['assignments_completed'] ?? '0',
            'assignments_total': data['assignments_total'] ?? '0',
            'assignments_pending': data['assignments_pending'] ?? '0',
          };
          isLoadingStats = false;
        });
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stats: $e');
      setState(() {
        statsError = 'Failed to load statistics';
        isLoadingStats = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  // Build error state for individual sections
  Widget _buildSectionError(String message, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.shade100,
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
        children: [
          Icon(
            Icons.error_outline,
            size: 40,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // Build loading state for individual sections
  Widget _buildSectionLoading(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
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
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: const Color(0xFF2563EB),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Enhanced App Bar
              SliverAppBar(
                expandedHeight: 150,
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
                        // Content
                        Positioned(
                          left: 24,
                          right: 80,
                          bottom: 24,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Good Morning!',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Academic Journey',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                ),
                                maxLines: 1,
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
                      // Quick Stats Cards
                      if (isLoadingStats)
                        _buildSectionLoading('Loading your statistics...')
                      else if (statsError.isNotEmpty)
                        _buildSectionError(statsError, _fetchStats)
                      else
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
                                    stats['attendance_rate'] ?? '0%',
                                    Icons.calendar_today_outlined,
                                    const Color(0xFF10B981),
                                    const Color(0xFFD1FAE5),
                                    stats['attendance_trend'] ?? 'No data',
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
                                    '${stats['assignments_completed'] ?? '0'}/${stats['assignments_total'] ?? '0'}',
                                    Icons.assignment_outlined,
                                    const Color(0xFFF59E0B),
                                    const Color(0xFFFEF3C7),
                                    '${stats['assignments_pending'] ?? '0'} pending',
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
                      
                      if (isLoadingGrades)
                        _buildSectionLoading('Loading academic performance...')
                      else if (gradesError.isNotEmpty)
                        _buildSectionError(gradesError, _fetchGrades)
                      else if (grades.isEmpty)
                        _buildEmptyState(
                          'No grades available',
                          'Academic performance data will appear here once available.',
                          Icons.school_outlined,
                        )
                      else
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
                      
                      if (isLoadingFeedbacks)
                        _buildSectionLoading('Loading teacher feedback...')
                      else if (feedbacksError.isNotEmpty)
                        _buildSectionError(feedbacksError, _fetchFeedbacks)
                      else if (feedbacks.isEmpty)
                        _buildEmptyState(
                          'No feedback available',
                          'Teacher feedback will appear here once available.',
                          Icons.star_outline,
                        )
                      else
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
                      
                      if (isLoadingComments)
                        _buildSectionLoading('Loading latest updates...')
                      else if (commentsError.isNotEmpty)
                        _buildSectionError(commentsError, _fetchComments)
                      else if (comments.isEmpty)
                        _buildEmptyState(
                          'No updates available',
                          'Latest comments and updates will appear here.',
                          Icons.chat_bubble_outline,
                        )
                      else
                        ...comments.map((comment) => _buildEnhancedCommentCard(comment)).toList(),
                      
                      const SizedBox(height: 120), // Bottom padding for nav bar
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 0),
    );
  }

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
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
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chat_bubble,
                  color: Colors.purple.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['teacher'] ?? 'Unknown Teacher',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment['date'] ?? 'Unknown date',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade100,
                width: 1,
              ),
            ),
            child: Text(
              comment['comment'] ?? 'No comment available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}