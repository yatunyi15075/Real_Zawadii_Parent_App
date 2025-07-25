// screens/attendance_screen.dart 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/nav_bar.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> attendanceData = [];
  Map<String, List<Map<String, dynamic>>> weeklyGroupedData = {};
  bool isLoading = false;
  String? errorMessage;
  String searchTerm = '';
  DateTime selectedWeekStart = DateTime.now();
  
  static const String baseUrl = 'https://zawadi-project.onrender.com';

  @override
  void initState() {
    super.initState();
    selectedWeekStart = _getStartOfWeek(DateTime.now());
    _loadAttendanceData();
  }

  // Get start of week (Monday)
  DateTime _getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(date.year, date.month, date.day).subtract(Duration(days: daysFromMonday));
  }

  // Get end of week (Sunday)
  DateTime _getEndOfWeek(DateTime startOfWeek) {
    return startOfWeek.add(const Duration(days: 6));
  }

  // Get stored authentication token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Load attendance from API
  Future<void> _loadAttendanceData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/attendance-records'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        
        // Handle both array and object responses
        List<dynamic> data;
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map && responseData.containsKey('data')) {
          data = responseData['data'] is List ? responseData['data'] : [];
        } else {
          data = [];
        }

        setState(() {
          attendanceData = data.map((item) => {
            'id': item['id']?.toString() ?? '',
            'student_id': item['student_id']?.toString() ?? '',
            'student_name': item['student_name']?.toString() ?? 'Unknown Student',
            'attendance_date': item['attendance_date']?.toString() ?? '',
            'status': item['status']?.toString() ?? 'Unknown',
            'created_at': item['createdAt']?.toString() ?? item['created_at']?.toString() ?? '',
            'icon': _getIconForStatus(item['status']?.toString() ?? ''),
            'color': _getColorForStatus(item['status']?.toString() ?? ''),
          }).toList();
          
          _groupDataByWeeks();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load attendance data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading attendance data: ${e.toString()}';
        isLoading = false;
        attendanceData = [];
      });
    }
  }

  // Group attendance data by weeks and students
  void _groupDataByWeeks() {
    weeklyGroupedData = {};
    
    // Filter by search term first
    final filteredData = attendanceData.where((entry) {
      if (searchTerm.isEmpty) return true;
      final studentName = entry['student_name'].toString().toLowerCase();
      return studentName.contains(searchTerm.toLowerCase());
    }).toList();

    // Group by student first, then by weeks
    Map<String, List<Map<String, dynamic>>> studentData = {};
    for (var entry in filteredData) {
      final studentName = entry['student_name'];
      if (!studentData.containsKey(studentName)) {
        studentData[studentName] = [];
      }
      studentData[studentName]!.add(entry);
    }

    // For each student, group their attendance by weeks
    studentData.forEach((studentName, records) {
      Map<String, List<Map<String, dynamic>>> studentWeeks = {};
      
      for (var record in records) {
        try {
          final recordDate = DateTime.parse(record['attendance_date']);
          final weekStart = _getStartOfWeek(recordDate);
          final weekKey = '${weekStart.day}/${weekStart.month}/${weekStart.year}';
          
          if (!studentWeeks.containsKey(weekKey)) {
            studentWeeks[weekKey] = [];
          }
          studentWeeks[weekKey]!.add(record);
        } catch (e) {
          // Skip invalid dates
          continue;
        }
      }

      // Sort each week's records by date
      studentWeeks.forEach((week, weekRecords) {
        weekRecords.sort((a, b) {
          try {
            final dateA = DateTime.parse(a['attendance_date']);
            final dateB = DateTime.parse(b['attendance_date']);
            return dateA.compareTo(dateB);
          } catch (e) {
            return 0;
          }
        });
      });

      weeklyGroupedData[studentName] = studentWeeks.entries
          .map((entry) => {
                'weekStart': entry.key,
                'records': entry.value,
              })
          .toList()
        ..sort((a, b) {
          // Sort weeks by date (newest first)
          try {
            final dateA = DateTime.parse((a['records'] as List).first['attendance_date']);
            final dateB = DateTime.parse((b['records'] as List).first['attendance_date']);
            return dateB.compareTo(dateA);
          } catch (e) {
            return 0;
          }
        });
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
    } catch (e) {
      return dateString ?? 'N/A';
    }
  }

  String _formatWeekRange(List<Map<String, dynamic>> weekRecords) {
    if (weekRecords.isEmpty) return '';
    
    try {
      final dates = weekRecords
          .map((record) => DateTime.parse(record['attendance_date']))
          .toList()
        ..sort();
      
      final startDate = dates.first;
      final endDate = dates.last;
      
      const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      
      if (startDate.month == endDate.month) {
        return '${startDate.day}-${endDate.day} ${months[startDate.month - 1]}, ${startDate.year}';
      } else {
        return '${startDate.day} ${months[startDate.month - 1]} - ${endDate.day} ${months[endDate.month - 1]}, ${startDate.year}';
      }
    } catch (e) {
      return 'Week';
    }
  }

  IconData _getIconForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle_rounded;
      case 'absent':
        return Icons.cancel_rounded;
      case 'absent with apology':
        return Icons.info_outline_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Color _getColorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return const Color(0xFF10B981); // Green
      case 'absent':
        return const Color(0xFFEF4444); // Red
      case 'absent with apology':
        return const Color(0xFFF59E0B); // Orange
      default:
        return const Color(0xFF64748B); // Gray
    }
  }

  // Calculate weekly statistics
  Map<String, int> _calculateWeeklyStats(List<Map<String, dynamic>> weekRecords) {
    int present = 0, absent = 0, absentWithApology = 0;
    
    for (var record in weekRecords) {
      switch (record['status'].toString().toLowerCase()) {
        case 'present':
          present++;
          break;
        case 'absent':
          absent++;
          break;
        case 'absent with apology':
          absentWithApology++;
          break;
      }
    }
    
    return {
      'present': present,
      'absent': absent,
      'absentWithApology': absentWithApology,
      'total': weekRecords.length,
    };
  }

  // Refresh attendance data
  Future<void> _refreshAttendance() async {
    await _loadAttendanceData();
  }

  Widget _buildSearchAndLegend() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
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
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) {
              setState(() {
                searchTerm = value;
                _groupDataByWeeks();
              });
            },
            decoration: InputDecoration(
              hintText: 'Search by student name...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 20),
          
          // Legend
          const Text(
            'Status Legend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildLegendItem(Icons.check_circle_rounded, 'Present', const Color(0xFF10B981)),
              _buildLegendItem(Icons.cancel_rounded, 'Absent', const Color(0xFFEF4444)),
              _buildLegendItem(Icons.info_outline_rounded, 'With Apology', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentWeeklyCard(String studentName, List<Map<String, dynamic>> studentWeeks) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Student Header
          Container(
            width: double.infinity,
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${studentWeeks.length} week${studentWeeks.length != 1 ? 's' : ''} of records',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Weekly Records
          ...studentWeeks.map((weekData) {
            final weekRecords = weekData['records'] as List<Map<String, dynamic>>;
            final stats = _calculateWeeklyStats(weekRecords);
            final attendanceRate = stats['total']! > 0 ? (stats['present']! / stats['total']!) * 100 : 0.0;
            
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Week Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatWeekRange(weekRecords),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF374151),
                              ),
                            ),
                            Text(
                              '${attendanceRate.toStringAsFixed(1)}% attendance',
                              style: TextStyle(
                                fontSize: 14,
                                color: attendanceRate >= 80 ? const Color(0xFF10B981) : 
                                       attendanceRate >= 60 ? const Color(0xFFF59E0B) : const Color(0xFFEF4444),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Quick stats
                      Row(
                        children: [
                          _buildQuickStat('P', stats['present']!, const Color(0xFF10B981)),
                          const SizedBox(width: 8),
                          _buildQuickStat('A', stats['absent']!, const Color(0xFFEF4444)),
                          if (stats['absentWithApology']! > 0) ...[
                            const SizedBox(width: 8),
                            _buildQuickStat('W', stats['absentWithApology']!, const Color(0xFFF59E0B)),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Daily Records
                  ...weekRecords.map((record) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE5E7EB), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: (record['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            record['icon'] as IconData,
                            color: record['color'] as Color,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formatDate(record['attendance_date']),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF374151),
                                ),
                              ),
                              Text(
                                record['status'],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: record['color'] as Color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
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
              child: const Icon(
                Icons.error_outline,
                size: 48,
                color: Color(0xFFEF4444),
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
              errorMessage ?? 'Unable to load attendance data',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _refreshAttendance,
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

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.calendar_today,
                size: 48,
                color: Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              searchTerm.isNotEmpty ? 'No results found' : 'No attendance records',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              searchTerm.isNotEmpty 
                  ? 'No results for "$searchTerm"'
                  : 'No attendance data is available at the moment.',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Attendance Records',
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
            onPressed: _refreshAttendance,
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingState()
          : errorMessage != null
              ? _buildErrorState()
              : RefreshIndicator(
                  color: const Color(0xFF6366F1),
                  onRefresh: _refreshAttendance,
                  child: weeklyGroupedData.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              _buildSearchAndLegend(),
                              ...weeklyGroupedData.entries.map((entry) =>
                                  _buildStudentWeeklyCard(entry.key, entry.value)),
                              const SizedBox(height: 20), // Bottom padding
                            ],
                          ),
                        ),
                ),
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }
}