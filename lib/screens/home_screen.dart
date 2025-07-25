// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grade.dart';
import '../widgets/nav_bar.dart';
import '../screens/settings_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/assignments_screen.dart';
import '../screens/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Grade> grades = [];
  Map<String, dynamic> stats = {};
  String userName = 'Student';
  int notificationCount = 0;
  
  // Loading states
  bool isLoadingStats = true;
  bool isLoadingGrades = true;
  bool isLoadingProfile = true;
  bool isLoadingNotifications = true;
  
  // Error states
  String statsError = '';
  String gradesError = '';
  String profileError = '';
  
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
    _fetchUserProfile();
    _fetchStats();
    _fetchGrades();
    _fetchNotificationCount();
  }

  Map<String, String> _getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      isLoadingProfile = true;
      profileError = '';
    });

    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/users/parent/profile'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          userName = responseData['name'] ?? 'Student';
          isLoadingProfile = false;
        });
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      setState(() {
        profileError = 'Failed to load profile';
        userName = 'Student';
        isLoadingProfile = false;
      });
    }
  }

  Future<void> _fetchNotificationCount() async {
    setState(() {
      isLoadingNotifications = true;
    });

    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/announcements'),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          notificationCount = data.length;
          isLoadingNotifications = false;
        });
      } else {
        setState(() {
          notificationCount = 0;
          isLoadingNotifications = false;
        });
      }
    } catch (e) {
      setState(() {
        notificationCount = 0;
        isLoadingNotifications = false;
      });
    }
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget _buildNotificationBell() {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
        ),
        if (notificationCount > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                notificationCount > 99 ? '99+' : notificationCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionError(String message, VoidCallback onRetry) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 32,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Unable to load data',
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
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLoading() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: const Color(0xFF3B82F6),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Professional App Bar
              SliverAppBar(
                expandedHeight: 120,
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
                          Color(0xFF3B82F6),
                          Color(0xFF2563EB),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 80, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${_getGreeting()}!',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLoadingProfile ? 'Loading...' : userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  _buildNotificationBell(),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats Cards
                      if (isLoadingStats)
                        _buildSectionLoading()
                      else if (statsError.isNotEmpty)
                        _buildSectionError(statsError, _fetchStats)
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
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
                                  child: _buildStatCard(
                                    'Attendance',
                                    stats['attendance_rate'] ?? '0%',
                                    Icons.calendar_today_outlined,
                                    const Color(0xFF10B981),
                                    true,
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
                                  child: _buildStatCard(
                                    'Assignments',
                                    '${stats['assignments_completed'] ?? '0'}/${stats['assignments_total'] ?? '0'}',
                                    Icons.assignment_outlined,
                                    const Color(0xFFF59E0B),
                                    false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 32),
                      
                      // Academic Performance Section
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.school_outlined,
                              color: Color(0xFF3B82F6),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Academic Performance',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      if (isLoadingGrades)
                        _buildSectionLoading()
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
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: grades.asMap().entries.map((entry) {
                              int index = entry.key;
                              Grade grade = entry.value;
                              bool isLast = index == grades.length - 1;
                              return _buildGradeCard(grade, isLast);
                            }).toList(),
                          ),
                        ),
                      
                      const SizedBox(height: 100), // Bottom padding for nav bar
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isFirst) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeCard(Grade grade, bool isLast) {
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
      padding: const EdgeInsets.all(16),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getGradeColor(grade.grade).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              getSubjectIcon(grade.subject),
              color: getGradeColor(grade.grade),
              size: 20,
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
                    fontSize: 15,
                    color: Color(0xFF1F2937),
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: getGradeColor(grade.grade).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              _getShortGrade(grade.grade),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
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

  Widget _buildEmptyState(String title, String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
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
}