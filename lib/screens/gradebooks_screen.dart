// screens/gradebooks_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/nav_bar.dart';

class GradebooksScreen extends StatefulWidget {
  const GradebooksScreen({super.key});

  @override
  State<GradebooksScreen> createState() => _GradebooksScreenState();
}

class _GradebooksScreenState extends State<GradebooksScreen> {
  List<Map<String, dynamic>> yearlyReports = [];
  List<Map<String, dynamic>> termlyReports = [];
  Map<String, dynamic>? selectedReport;
  bool isLoading = false;
  String? errorMessage;
  String selectedReportType = 'yearly'; // 'yearly' or 'termly'
  String selectedTerm = '';
  String selectedYear = '';
  Map<String, String> students = {};
  Map<String, String> schools = {};
  
  static const String baseUrl = 'https://zawadi-project.onrender.com';

  @override
  void initState() {
    super.initState();
    _loadGradebooks();
  }

  // Get stored authentication token
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Load gradebooks from API
  Future<void> _loadGradebooks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final token = await _getAuthToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      // Load yearly reports
      await _loadYearlyReports(token);
      
      // Load termly reports
      await _loadTermlyReports(token);
      
      // Load additional data (students and schools)
      await _loadAdditionalData(token);
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading gradebooks: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _loadYearlyReports(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/gradebook/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      yearlyReports = data.map((item) => Map<String, dynamic>.from(item)).toList();
      
      // Set default selected report if available
      if (yearlyReports.isNotEmpty) {
        final yearlyReport = yearlyReports.firstWhere(
          (report) => report['term'] == 'Yearly',
          orElse: () => yearlyReports.first,
        );
        selectedReport = yearlyReport;
      }
    }
  }

  Future<void> _loadTermlyReports(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/termly-gradebook-reports'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      termlyReports = data.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  Future<void> _loadAdditionalData(String token) async {
    // Get unique student and school IDs
    final allReports = [...yearlyReports, ...termlyReports];
    final studentIds = allReports.map((r) => r['studentId']?.toString()).where((id) => id != null).toSet();
    final schoolIds = allReports.map((r) => r['schoolId']?.toString()).where((id) => id != null).toSet();

    // Load students
    if (studentIds.isNotEmpty) {
      try {
        final studentResponse = await http.get(
          Uri.parse('$baseUrl/api/students?ids=${studentIds.join(',')}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        
        if (studentResponse.statusCode == 200) {
          final List<dynamic> studentData = json.decode(studentResponse.body);
          for (var student in studentData) {
            students[student['id'].toString()] = student['name'];
          }
        }
      } catch (e) {
        print('Error loading students: $e');
      }
    }

    // Load schools
    if (schoolIds.isNotEmpty) {
      try {
        final schoolResponse = await http.get(
          Uri.parse('$baseUrl/api/schools?ids=${schoolIds.join(',')}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        
        if (schoolResponse.statusCode == 200) {
          final List<dynamic> schoolData = json.decode(schoolResponse.body);
          for (var school in schoolData) {
            schools[school['id'].toString()] = school['name'];
          }
        }
      } catch (e) {
        print('Error loading schools: $e');
      }
    }
  }

  String _getStudentName(String? studentId) {
    if (studentId == null) return 'Unknown Student';
    return students[studentId] ?? 'Student ID: $studentId';
  }

  String _getSchoolName(String? schoolId) {
    if (schoolId == null) return 'Unknown School';
    return schools[schoolId] ?? 'School ID: $schoolId';
  }

  Color _getGradeColor(String? grade) {
    if (grade == null || grade.isEmpty) return Colors.grey;
    
    final firstChar = grade.toUpperCase()[0];
    switch (firstChar) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.blue;
      case 'C':
        return Colors.yellow[700]!;
      case 'D':
        return Colors.orange;
      case 'F':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _switchReportType(String type) {
    setState(() {
      selectedReportType = type;
      selectedReport = null;
      selectedTerm = '';
      selectedYear = '';
      
      if (type == 'yearly' && yearlyReports.isNotEmpty) {
        selectedReport = yearlyReports.first;
      }
    });
  }

  void _selectTerm(String term) {
    setState(() {
      selectedTerm = term;
      final termReports = termlyReports.where((r) => r['term'] == term).toList();
      if (termReports.isNotEmpty) {
        selectedReport = termReports.first;
      } else {
        selectedReport = null;
      }
    });
  }

  void _selectReport(Map<String, dynamic> report) {
    setState(() {
      selectedReport = report;
    });
  }

  Widget _buildReportTypeSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Report Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _switchReportType('yearly'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedReportType == 'yearly' 
                            ? const Color(0xFF6366F1) 
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Yearly Report',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedReportType == 'yearly' 
                              ? Colors.white 
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _switchReportType('termly'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedReportType == 'termly' 
                            ? const Color(0xFF6366F1) 
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Termly Report',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: selectedReportType == 'termly' 
                              ? Colors.white 
                              : const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSelector() {
    if (selectedReportType != 'termly') return const SizedBox.shrink();

    final availableTerms = termlyReports
        .map((r) => r['term']?.toString())
        .where((term) => term != null)
        .toSet()
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Term',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedTerm.isEmpty ? null : selectedTerm,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6366F1)),
                ),
              ),
              hint: const Text('Choose a term'),
              items: availableTerms.map((term) => DropdownMenuItem(
                value: term,
                child: Text(term!),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  _selectTerm(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard() {
    if (selectedReport == null) {
      return Container(
        margin: const EdgeInsets.all(16),
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
        child: const Padding(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 48,
                  color: Color(0xFF9CA3AF),
                ),
                SizedBox(height: 16),
                Text(
                  'No Report Selected',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Please select a report type and term to view the gradebook.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportHeader(),
            const SizedBox(height: 24),
            _buildSubjects(),
            if (selectedReport!['performanceSummary'] != null)
              _buildPerformanceSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Text(
            'Student Grade Book Report',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getSchoolName(selectedReport!['schoolId']?.toString()),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6366F1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${selectedReport!['term']} • ${selectedReport!['year']} Academic Year',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            _getStudentName(selectedReport!['studentId']?.toString()),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjects() {
    final subjects = selectedReport!['subjects'];
    if (subjects == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'No subjects found in this report',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ),
      );
    }

    List<dynamic> subjectsList = [];
    if (subjects is List) {
      subjectsList = subjects;
    } else if (subjects is Map) {
      // Convert map to list format
      subjectsList = (subjects as Map).entries.map((entry) {
        return {
          'subjectName': entry.key,
          'competencies': [
            {
              'competencyArea': 'Overall Score',
              'grade': entry.value['score']?.toString() ?? 'N/A',
              'comment': entry.value['remarks']?.toString() ?? '',
            }
          ]
        };
      }).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Academic Performance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 16),
        ...subjectsList.map((subject) => _buildSubjectCard(subject)).toList(),
      ],
    );
  }

  Widget _buildSubjectCard(Map<String, dynamic> subject) {
    final subjectName = subject['subjectName']?.toString() ?? 'Unknown Subject';
    final competencies = subject['competencies'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subjectName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (competencies.isEmpty)
              const Text(
                'No competencies recorded for this subject',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              )
            else
              ...competencies.map((competency) => _buildCompetencyRow(competency)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCompetencyRow(Map<String, dynamic> competency) {
    final area = competency['competencyArea']?.toString() ?? competency['area']?.toString() ?? 'Unknown Area';
    final grade = competency['grade']?.toString() ?? 'N/A';
    final comment = competency['comment']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              area,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getGradeColor(grade).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              grade,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getGradeColor(grade),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              comment.isEmpty ? '-' : comment,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary() {
    final summary = selectedReport!['performanceSummary']?.toString();
    if (summary == null || summary.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF10B981)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Overall Performance Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF065F46),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF065F46),
            ),
          ),
        ],
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
              errorMessage ?? 'Unable to load gradebooks',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadGradebooks,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Grade Books',
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
            onPressed: _loadGradebooks,
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingState()
          : errorMessage != null
              ? _buildErrorState()
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildReportTypeSelector(),
                      _buildTermSelector(),
                      _buildReportCard(),
                    ],
                  ),
                ),
      bottomNavigationBar: const NavBar(currentIndex: 3), // Adjust index as needed
    );
  }
}