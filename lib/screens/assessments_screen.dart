// screens/assessments_screen.dart
import 'package:flutter/material.dart';
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
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sample data - in real app this would come from API/database
  final List<Map<String, dynamic>> summativeAssessments = [
    {
      'activity': 'Mathematics Project',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'subject': 'Mathematics',
      'description': 'Problem-solving project on fractions',
      'score': '95%',
      'icon': Icons.calculate_outlined,
    },
    {
      'activity': 'Science Experiment',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'subject': 'Science',
      'description': 'Plant growth observation study',
      'score': '82%',
      'icon': Icons.science_outlined,
    },
    {
      'activity': 'English Composition',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'subject': 'English',
      'description': 'Creative story writing assignment',
      'score': '88%',
      'icon': Icons.edit_outlined,
    },
    {
      'activity': 'Social Studies Report',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'subject': 'Social Studies',
      'description': 'Community helpers research project',
      'score': '75%',
      'icon': Icons.people_outline,
    },
    {
      'activity': 'Art Portfolio Review',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'subject': 'Art',
      'description': 'Collection of artistic works',
      'score': '92%',
      'icon': Icons.palette_outlined,
    },
  ];

  final List<Map<String, dynamic>> formativeAssessments = [
    {
      'activity': 'Daily Math Practice',
      'level': 'Meeting Expectations',
      'date': DateTime.now(),
      'subject': 'Mathematics',
      'description': 'Multiplication tables quiz',
      'score': '78%',
      'icon': Icons.calculate_outlined,
    },
    {
      'activity': 'Reading Comprehension',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'subject': 'English',
      'description': 'Short story analysis',
      'score': '90%',
      'icon': Icons.menu_book_outlined,
    },
    {
      'activity': 'Science Observation',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'subject': 'Science',
      'description': 'Weather pattern recording',
      'score': '80%',
      'icon': Icons.cloud_outlined,
    },
    {
      'activity': 'Creative Writing',
      'level': 'Approaching Expectations',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'subject': 'English',
      'description': 'Daily journal entry',
      'score': '65%',
      'icon': Icons.create_outlined,
    },
    {
      'activity': 'Environmental Activities',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'subject': 'Environmental Science',
      'description': 'Recycling sorting activity',
      'score': '85%',
      'icon': Icons.eco_outlined,
    },
    {
      'activity': 'Mental Math Challenge',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'subject': 'Mathematics',
      'description': 'Speed calculation exercises',
      'score': '93%',
      'icon': Icons.psychology_outlined,
    },
  ];

  Color _getLevelColor(String? level) {
    switch (level ?? '') {
      case 'Exceeding Expectations':
        return const Color(0xFF10B981); // Emerald
      case 'Meeting Expectations':
        return const Color(0xFF3B82F6); // Blue
      case 'Approaching Expectations':
        return const Color(0xFFF59E0B); // Amber
      case 'Below Expectations':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  Color _getSubjectColor(String? subject) {
    switch ((subject ?? '').toLowerCase()) {
      case 'mathematics':
        return const Color(0xFF8B5CF6); // Purple
      case 'science':
        return const Color(0xFF06B6D4); // Cyan
      case 'english':
        return const Color(0xFFF59E0B); // Amber
      case 'social studies':
        return const Color(0xFFEC4899); // Pink
      case 'art':
        return const Color(0xFF84CC16); // Lime
      case 'environmental science':
        return const Color(0xFF10B981); // Emerald
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

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
    // Safe extraction with null checks and fallbacks
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
        onTap: () {
          // Handle tap - navigate to detail screen
        },
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
                        '${date.day}/${date.month}/${date.year}',
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

  Widget _buildAssessmentsList(List<Map<String, dynamic>> assessments) {
    final filteredAssessments = _filterAssessmentsByPeriod(assessments);
    
    if (filteredAssessments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.assessment_outlined,
                  size: 48,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'No assessments found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try adjusting your filter settings to see more results',
                style: TextStyle(
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

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: filteredAssessments.length,
      itemBuilder: (context, index) {
        return _buildAssessmentCard(filteredAssessments[index]);
      },
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
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Container(
            color: const Color(0xFF6366F1),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Summative'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Formative'),
                    ],
                  ),
                ),
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
                _buildAssessmentsList(summativeAssessments),
                _buildAssessmentsList(formativeAssessments),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(currentIndex: 2),
    );
  }
}