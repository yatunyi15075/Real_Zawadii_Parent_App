// screens/assessments_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/nav_bar.dart';

class AssessmentsScreen extends StatefulWidget {
  const AssessmentsScreen({super.key});

  @override
  State<AssessmentsScreen> createState() => _AssessmentsScreenState();
}

class _AssessmentsScreenState extends State<AssessmentsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Filter states
  String selectedPeriod = 'This Week';
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  
  final List<String> periods = ['Today', 'This Week', 'This Month', 'Custom Range'];
  
  // Data and loading states
  List<Map<String, dynamic>> summativeAssessments = [];
  List<Map<String, dynamic>> formativeAssessments = [];
  bool isLoadingSummative = false;
  bool isLoadingFormative = false;
  String? errorMessage;


  static const String baseUrl = 'https://zawadi-project.onrender.com';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAssessments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Get stored authentication token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Store authentication token (call this when user logs in)
  Future<void> _storeAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Load assessments from API
  Future<void> _loadAssessments() async {
    await Future.wait([
      _loadSummativeAssessments(),
      _loadFormativeAssessments(),
    ]);
  }

  // Load summative assessments - matching React webapp API call
  Future<void> _loadSummativeAssessments() async {
    setState(() {
      isLoadingSummative = true;
      errorMessage = null;
    });

    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Using the same API endpoint as React webapp
      final response = await http.get(
        Uri.parse('$baseUrl/api/entered-marks/summative'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Transform data to match the same structure as React webapp
        setState(() {
          summativeAssessments = data.map((mark) => {
            'id': mark['id'],
            'studentName': mark['student_name'] ?? 'Student ID: ${mark['student_id']}',
            'classLevel': mark['class_level'],
            'admissionNumber': mark['admission_number'],
            'subject': mark['subject'],
            'topic': mark['topic'],
            'subtopic': mark['subtopic'],
            'assessmentType': mark['assessment_type'],
            'correctAnswers': mark['correct_answers'],
            'totalAnswers': mark['total_answers'],
            'performanceLevel': mark['performance_level'],
            'createdAt': mark['created_at'] != null 
                ? DateTime.parse(mark['created_at']) 
                : DateTime.now(),
            'score': mark['correct_answers'] != null && mark['total_answers'] != null
                ? '${((mark['correct_answers'] / mark['total_answers']) * 100).toStringAsFixed(1)}%'
                : 'N/A',
            'activity': '${mark['subject']} - ${mark['topic']}',
            'description': mark['subtopic'] ?? mark['topic'] ?? 'Assessment',
            'date': mark['created_at'] != null 
                ? DateTime.parse(mark['created_at']) 
                : DateTime.now(),
            'level': mark['performance_level'] ?? 'Not Assessed',
            'icon': _getSubjectIcon(mark['subject']),
          }).toList();
          isLoadingSummative = false;
        });
      } else {
        throw Exception('Failed to load summative assessments: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading summative assessments: ${e.toString()}';
        isLoadingSummative = false;
        summativeAssessments = [];
      });
    }
  }

  // Load formative assessments - matching React webapp API call
  Future<void> _loadFormativeAssessments() async {
    setState(() {
      isLoadingFormative = true;
      errorMessage = null;
    });

    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Using the same API endpoint as React webapp
      final response = await http.get(
        Uri.parse('$baseUrl/api/entered-marks/formative'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Transform data to match the same structure as React webapp
        setState(() {
          formativeAssessments = data.map((mark) => {
            'id': mark['id'],
            'studentName': mark['student_name'] ?? 'Student ID: ${mark['student_id']}',
            'classLevel': mark['class_level'],
            'admissionNumber': mark['admission_number'],
            'subject': mark['subject'],
            'topic': mark['topic'],
            'subtopic': mark['subtopic'],
            'assessmentType': mark['assessment_type'],
            'correctAnswers': mark['correct_answers'],
            'totalAnswers': mark['total_answers'],
            'performanceLevel': mark['performance_level'],
            'createdAt': mark['created_at'] != null 
                ? DateTime.parse(mark['created_at']) 
                : DateTime.now(),
            'score': mark['correct_answers'] != null && mark['total_answers'] != null
                ? '${((mark['correct_answers'] / mark['total_answers']) * 100).toStringAsFixed(1)}%'
                : 'N/A',
            'activity': '${mark['subject']} - ${mark['topic']}',
            'description': mark['subtopic'] ?? mark['topic'] ?? 'Assessment',
            'date': mark['created_at'] != null 
                ? DateTime.parse(mark['created_at']) 
                : DateTime.now(),
            'level': mark['performance_level'] ?? 'Not Assessed',
            'icon': _getSubjectIcon(mark['subject']),
          }).toList();
          isLoadingFormative = false;
        });
      } else {
        throw Exception('Failed to load formative assessments: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading formative assessments: ${e.toString()}';
        isLoadingFormative = false;
        formativeAssessments = [];
      });
    }
  }

  // Get icon based on subject - matching the webapp logic
  IconData _getSubjectIcon(String? subject) {
    switch ((subject ?? '').toLowerCase()) {
      case 'mathematics':
        return Icons.calculate_outlined;
      case 'science':
        return Icons.science_outlined;
      case 'english':
        return Icons.edit_outlined;
      case 'kiswahili':
        return Icons.language_outlined;
      case 'social studies':
        return Icons.people_outline;
      case 'physical education':
        return Icons.sports_outlined;
      case 'art':
        return Icons.palette_outlined;
      case 'environmental science':
        return Icons.eco_outlined;
      default:
        return Icons.assignment_outlined;
    }
  }

  // Refresh assessments
  Future<void> _refreshAssessments() async {
    await _loadAssessments();
  }

  // Get level color - matching webapp logic
  Color _getLevelColor(String? level) {
    switch (level ?? '') {
      case 'Excellent':
        return const Color(0xFF10B981); // Green
      case 'Meets Expectation':
        return const Color(0xFF3B82F6); // Blue
      case 'Average':
        return const Color(0xFFF59E0B); // Yellow
      case 'Below Average':
        return const Color(0xFFEF4444); // Red
      case 'Exceeding Expectations':
        return const Color(0xFF10B981); // Green
      case 'Meeting Expectations':
        return const Color(0xFF3B82F6); // Blue
      case 'Approaching Expectations':
        return const Color(0xFFF59E0B); // Yellow
      case 'Below Expectations':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Get subject color - matching webapp logic
  Color _getSubjectColor(String? subject) {
    switch ((subject ?? '').toLowerCase()) {
      case 'mathematics':
        return const Color(0xFF8B5CF6); // Purple
      case 'science':
        return const Color(0xFF06B6D4); // Cyan
      case 'english':
        return const Color(0xFFF59E0B); // Amber
      case 'kiswahili':
        return const Color(0xFF10B981); // Emerald
      case 'social studies':
        return const Color(0xFFEC4899); // Pink
      case 'physical education':
        return const Color(0xFF84CC16); // Lime
      case 'art':
        return const Color(0xFF84CC16); // Lime
      case 'environmental science':
        return const Color(0xFF10B981); // Emerald
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  // Filter assessments by period
  List<Map<String, dynamic>> _filterAssessmentsByPeriod(List<Map<String, dynamic>> assessments) {
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    switch (selectedPeriod) {
      case 'Today':
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case 'This Week':
        startDate = now.subtract(Duration(days: now.weekday - 1));
        startDate = DateTime(startDate.year, startDate.month, startDate.day);
        break;
      case 'This Month':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case 'Custom Range':
        if (selectedStartDate != null && selectedEndDate != null) {
          startDate = selectedStartDate!;
          endDate = selectedEndDate!;
        } else {
          return assessments;
        }
        break;
      default:
        return assessments;
    }

    return assessments.where((assessment) {
      final assessmentDate = assessment['date'] as DateTime?;
      if (assessmentDate == null) return false;
      return assessmentDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
             assessmentDate.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Date range picker
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: selectedStartDate != null && selectedEndDate != null
          ? DateTimeRange(start: selectedStartDate!, end: selectedEndDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6366F1),
              brightness: Brightness.light,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        selectedStartDate = picked.start;
        selectedEndDate = picked.end;
      });
    }
  }

  // Show assessment details - matching webapp modal
  void _showAssessmentDetails(Map<String, dynamic> assessment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.assessment,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Assessment Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Student Info
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Student Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E40AF),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildDetailRow('Name', assessment['studentName'] ?? 'N/A'),
                            _buildDetailRow('ID', assessment['admissionNumber']?.toString() ?? 'N/A'),
                            _buildDetailRow('Class', assessment['classLevel']?.toString() ?? 'N/A'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Assessment Details
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assessment Details',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow('Subject', assessment['subject'] ?? 'N/A'),
                                _buildDetailRow('Type', assessment['assessmentType'] ?? 'N/A'),
                                _buildDetailRow('Topic', assessment['topic'] ?? 'N/A'),
                                if (assessment['subtopic'] != null)
                                  _buildDetailRow('Subtopic', assessment['subtopic']),
                                _buildDetailRow('Date', _formatDate(assessment['date'])),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Performance',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1F2937),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _buildDetailRow('Score', '${assessment['correctAnswers']}/${assessment['totalAnswers']}'),
                                _buildDetailRow('Percentage', assessment['score'] ?? 'N/A'),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Level: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF374151),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getLevelColor(assessment['performanceLevel']).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        assessment['performanceLevel'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _getLevelColor(assessment['performanceLevel']),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildFilterSection() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                  color: const Color(0xFF6366F1).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.tune,
                  color: const Color(0xFF6366F1),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Filter Assessments',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: periods.map((period) {
              final isSelected = selectedPeriod == period;
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedPeriod = period;
                    if (period == 'Custom Range') {
                      _selectDateRange();
                    } else {
                      selectedStartDate = null;
                      selectedEndDate = null;
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF6366F1)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF6366F1)
                          : const Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    period,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF374151),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (selectedPeriod == 'Custom Range' && selectedStartDate != null && selectedEndDate != null)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBAE6FD)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    size: 16,
                    color: const Color(0xFF0284C7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year} - ${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}',
                    style: const TextStyle(
                      color: Color(0xFF0284C7),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard(Map<String, dynamic> assessment) {
    final String activity = assessment['activity']?.toString() ?? 'Unknown Activity';
    final String subject = assessment['subject']?.toString() ?? 'Unknown Subject';
    final String level = assessment['level']?.toString() ?? 'Not Assessed';
    final String description = assessment['description']?.toString() ?? 'No description available';
    final String score = assessment['score']?.toString() ?? 'N/A';
    final DateTime date = assessment['date'] as DateTime? ?? DateTime.now();
    final IconData icon = assessment['icon'] as IconData? ?? Icons.assignment_outlined;
    
    final subjectColor = _getSubjectColor(subject);
    final levelColor = _getLevelColor(level);
    
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showAssessmentDetails(assessment),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: subjectColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: subjectColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subject,
                          style: TextStyle(
                            fontSize: 14,
                            color: subjectColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: levelColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      score,
                      style: TextStyle(
                        color: levelColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      level,
                      style: TextStyle(
                        color: levelColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(date),
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage ?? 'Unable to load assessments',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshAssessments,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
}
Widget _buildEmptyState(String message) {
  return Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.assessment_outlined,
              size: 36,
              color: const Color(0xFF9CA3AF),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No assessments found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAssessmentsList(List<Map<String, dynamic>> assessments, bool isLoading) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    final filteredAssessments = _filterAssessmentsByPeriod(assessments);

    if (filteredAssessments.isEmpty) {
      return _buildEmptyState('No assessments found for the selected period.');
    }

    return RefreshIndicator(
      color: const Color(0xFF6366F1),
      onRefresh: _refreshAssessments,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: filteredAssessments.length,
        itemBuilder: (context, index) {
          return _buildAssessmentCard(filteredAssessments[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Assessments',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAssessments,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: const Color(0xFF6366F1),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Summative'),
                Tab(text: 'Formative'),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAssessmentsList(summativeAssessments, isLoadingSummative),
                _buildAssessmentsList(formativeAssessments, isLoadingFormative),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }
}
