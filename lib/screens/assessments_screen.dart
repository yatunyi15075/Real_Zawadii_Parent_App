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
    },
    {
      'activity': 'Science Experiment',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'subject': 'Science',
      'description': 'Plant growth observation study',
    },
    {
      'activity': 'English Composition',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'subject': 'English',
      'description': 'Creative story writing assignment',
    },
    {
      'activity': 'Social Studies Report',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'subject': 'Social Studies',
      'description': 'Community helpers research project',
    },
    {
      'activity': 'Art Portfolio Review',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'subject': 'Art',
      'description': 'Collection of artistic works',
    },
  ];

  final List<Map<String, dynamic>> formativeAssessments = [
    {
      'activity': 'Daily Math Practice',
      'level': 'Meeting Expectations',
      'date': DateTime.now(),
      'subject': 'Mathematics',
      'description': 'Multiplication tables quiz',
    },
    {
      'activity': 'Reading Comprehension',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'subject': 'English',
      'description': 'Short story analysis',
    },
    {
      'activity': 'Science Observation',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'subject': 'Science',
      'description': 'Weather pattern recording',
    },
    {
      'activity': 'Creative Writing',
      'level': 'Approaching Expectations',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'subject': 'English',
      'description': 'Daily journal entry',
    },
    {
      'activity': 'Environmental Activities',
      'level': 'Meeting Expectations',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'subject': 'Environmental Science',
      'description': 'Recycling sorting activity',
    },
    {
      'activity': 'Mental Math Challenge',
      'level': 'Exceeding Expectations',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'subject': 'Mathematics',
      'description': 'Speed calculation exercises',
    },
  ];

  Color _getLevelColor(String level) {
    switch (level) {
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
          return assessments; // Return all if no custom range set
        }
        break;
      default:
        return assessments;
    }

    return assessments.where((assessment) {
      final assessmentDate = assessment['date'] as DateTime;
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Period:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            children: periods.map((period) {
              return ChoiceChip(
                label: Text(period),
                selected: selectedPeriod == period,
                onSelected: (selected) {
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
              );
            }).toList(),
          ),
          if (selectedPeriod == 'Custom Range' && selectedStartDate != null && selectedEndDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Selected Range: ${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year} - ${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssessmentCard(Map<String, dynamic> assessment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assessment['activity'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getLevelColor(assessment['level']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getLevelColor(assessment['level'])),
                  ),
                  child: Text(
                    assessment['level'],
                    style: TextStyle(
                      color: _getLevelColor(assessment['level']),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.subject,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  assessment['subject'],
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${assessment['date'].day}/${assessment['date'].month}/${assessment['date'].year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              assessment['description'],
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentsList(List<Map<String, dynamic>> assessments) {
    final filteredAssessments = _filterAssessmentsByPeriod(assessments);
    
    if (filteredAssessments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assessment_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No assessments found for the selected period',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAssessments.length,
      itemBuilder: (context, index) {
        return _buildAssessmentCard(filteredAssessments[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessments'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Summative'),
              Tab(text: 'Formative'),
            ],
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