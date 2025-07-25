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

class _GradebooksScreenState extends State<GradebooksScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Filter states
  String selectedTerm = 'Term 1';
  String selectedYear = '2024';
  
  final List<String> terms = ['Term 1', 'Term 2', 'Term 3'];
  final List<String> years = ['2024', '2023', '2022'];

  // API data
  List<Map<String, dynamic>> reports = [];
  Map<String, String> students = {};
  Map<String, String> schools = {};
  bool isLoading = true;
  String? error;

  // Add your backend URL here - same as web app
  static const String baseUrl = 'https://zawadi-project.onrender.com'; // Replace with your actual backend URL

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _fetchReports() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final token = await _getToken();
      if (token == null) {
        setState(() {
          error = 'No authentication token found';
          isLoading = false;
        });
        return;
      }

      // Fetch termly reports with term filter if needed
      String apiUrl = '$baseUrl/api/termly-gradebook-reports';
      if (selectedTerm.isNotEmpty) {
        apiUrl += '?term=${Uri.encodeComponent(selectedTerm)}';
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> reportsData = json.decode(response.body);
        
        // Extract unique student and school IDs for additional data fetching
        final studentIds = <String>{};
        final schoolIds = <String>{};
        
        for (var report in reportsData) {
          if (report['studentId'] != null) {
            studentIds.add(report['studentId'].toString());
          }
          if (report['schoolId'] != null) {
            schoolIds.add(report['schoolId'].toString());
          }
        }

        // Fetch student data if needed
        if (studentIds.isNotEmpty) {
          await _fetchStudentData(studentIds, token);
        }

        // Fetch school data if needed
        if (schoolIds.isNotEmpty) {
          await _fetchSchoolData(schoolIds, token);
        }

        setState(() {
          reports = reportsData.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          error = 'Session expired. Please log in again.';
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load grade data. Please try again later.';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Network error: $e');
      setState(() {
        error = 'Network error. Please check your connection.';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchStudentData(Set<String> studentIds, String token) async {
    try {
      final studentResponse = await http.get(
        Uri.parse('$baseUrl/api/students?ids=${studentIds.join(',')}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (studentResponse.statusCode == 200) {
        final List<dynamic> studentsData = json.decode(studentResponse.body);
        final Map<String, String> studentMap = {};
        for (var student in studentsData) {
          studentMap[student['id'].toString()] = student['name'] ?? 'Unknown Student';
        }
        students = studentMap;
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> _fetchSchoolData(Set<String> schoolIds, String token) async {
    try {
      final schoolResponse = await http.get(
        Uri.parse('$baseUrl/api/schools?ids=${schoolIds.join(',')}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (schoolResponse.statusCode == 200) {
        final List<dynamic> schoolsData = json.decode(schoolResponse.body);
        final Map<String, String> schoolMap = {};
        for (var school in schoolsData) {
          schoolMap[school['id'].toString()] = school['name'] ?? 'Unknown School';
        }
        schools = schoolMap;
      }
    } catch (e) {
      print('Error fetching schools: $e');
    }
  }

  Map<String, dynamic>? _getSelectedReport() {
    if (reports.isEmpty) return null;
    
    final termReports = reports.where((report) => 
      report['term'] == selectedTerm && 
      report['year'].toString() == selectedYear
    ).toList();
    
    return termReports.isNotEmpty ? termReports.first : null;
  }

  List<Map<String, dynamic>> _getSubjectsFromReport(Map<String, dynamic> report) {
    final subjects = report['subjects'];
    if (subjects == null) return [];

    List<Map<String, dynamic>> subjectList = [];
    
    try {
      Map<String, dynamic> subjectsData;
      if (subjects is String) {
        subjectsData = json.decode(subjects);
      } else {
        subjectsData = subjects;
      }

      subjectsData.forEach((name, subjectInfo) {
        final competencies = <Map<String, dynamic>>[];
        
        // Handle different possible structures of subject data
        dynamic score;
        dynamic remarks;
        
        if (subjectInfo is Map) {
          score = subjectInfo['score'] ?? subjectInfo['grade'] ?? 0;
          remarks = subjectInfo['remarks'] ?? subjectInfo['comment'] ?? '';
        } else {
          score = subjectInfo;
          remarks = '';
        }
        
        if (score != null) {
          competencies.add({
            'area': 'Overall Score',
            'grade': score.toString(),
            'comment': remarks.toString()
          });
        }
        
        subjectList.add({
          'name': name,
          'score': score?.toString() ?? '0',
          'grade': _getGradeFromScore(score?.toString() ?? '0'),
          'competencies': competencies
        });
      });
    } catch (e) {
      print('Error parsing subjects: $e');
      
      // Fallback: if subjects is a simple structure, handle it differently
      if (subjects is Map) {
        subjects.forEach((name, value) {
          subjectList.add({
            'name': name.toString(),
            'score': value.toString(),
            'grade': _getGradeFromScore(value.toString()),
            'competencies': []
          });
        });
      }
    }

    return subjectList;
  }

  String _getGradeFromScore(String scoreStr) {
    final score = double.tryParse(scoreStr) ?? 0;
    if (score >= 90) return 'A';
    if (score >= 80) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C+';
    if (score >= 50) return 'C';
    if (score >= 40) return 'D';
    return 'F';
  }

  String _getStudentName(String? studentId) {
    if (studentId == null) return 'Unknown Student';
    return students[studentId] ?? 'Student ID: $studentId';
  }

  String _getSchoolName(String? schoolId) {
    if (schoolId == null) return 'Unknown School';
    return schools[schoolId] ?? 'School ID: $schoolId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTermlyTab(),
                  _buildYearlyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF667EEA).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Academic Reports',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your performance across terms',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.school_outlined,
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
                        reports.isNotEmpty ? _getSchoolName(reports.first['schoolId']?.toString()) : 'Loading...',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Comprehensive academic performance overview',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF64748B).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: const Color(0xFF1E293B),
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_view_month_outlined, size: 20),
                SizedBox(width: 8),
                Text('Termly'),
              ],
            ),
          ),
          Tab(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 20),
                SizedBox(width: 8),
                Text('Annual'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermlyTab() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading grade book data...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchReports,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        _buildTermlyFilters(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: _buildGradebookSection(),
          ),
        ),
      ],
    );
  }

  Widget _buildYearlyTab() {
    // For now, showing the same data as termly
    // You can modify this to show yearly aggregated data
    return _buildTermlyTab();
  }

  Widget _buildTermlyFilters() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              'Select Term',
              selectedTerm,
              terms,
              Icons.calendar_view_month_outlined,
              (value) {
                setState(() => selectedTerm = value!);
                _fetchReports(); // Refresh data when term changes
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              'Academic Year',
              selectedYear,
              years,
              Icons.school_outlined,
              (value) {
                setState(() => selectedYear = value!);
                // You might want to refresh data here too if your backend supports year filtering
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    IconData icon,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF64748B),
            size: 20,
          ),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradebookSection() {
    final selectedReport = _getSelectedReport();
    
    if (selectedReport == null) {
      return _buildEmptyState();
    }

    final subjects = _getSubjectsFromReport(selectedReport);
    
    if (subjects.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64748B).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF059669).withOpacity(0.05),
                  const Color(0xFF059669).withOpacity(0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF059669).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.calendar_view_month_outlined,
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
                        '$selectedTerm Results',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${selectedReport['year']} - ${_getStudentName(selectedReport['studentId']?.toString())}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAverageScore(subjects, const Color(0xFF059669)),
              ],
            ),
          ),
          _buildResultsHeader(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subjects.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFF1F5F9),
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return _buildGradebookRow(
                subject['name'],
                subject['score'],
                subject['grade'],
                index == subjects.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Subject',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Score',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'Grade',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageScore(List<Map<String, dynamic>> subjects, Color accentColor) {
    if (subjects.isEmpty) return const SizedBox.shrink();
    
    double total = 0;
    int validSubjects = 0;
    
    for (var subject in subjects) {
      final score = double.tryParse(subject['score'].toString());
      if (score != null && score > 0) {
        total += score;
        validSubjects++;
      }
    }
    
    double average = validSubjects > 0 ? total / validSubjects : 0;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '${average.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
          const Text(
            'Average',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Results Available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Results for $selectedTerm $selectedYear are not yet available.\nPlease check back later or contact your teacher.',
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGradebookRow(String subject, String score, String grade, bool isLast) {
    Color gradeColor = _getGradeColor(grade);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: isLast ? const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ) : null,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: gradeColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$score%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF374151),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: gradeColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: gradeColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
        return const Color(0xFF059669); // Green
      case 'B+':
      case 'B':
        return const Color(0xFF0891B2); // Blue
      case 'C+':
      case 'C':
        return const Color(0xFFCA8A04); // Yellow
      case 'D':
        return const Color(0xFFEA580C); // Orange
      case 'F':
        return const Color(0xFFDC2626); // Red
      default:
        return const Color(0xFF64748B); // Gray
    }
  }
}