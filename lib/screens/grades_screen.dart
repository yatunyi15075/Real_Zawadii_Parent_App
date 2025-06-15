// screens/grades_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class GradesScreen extends StatefulWidget {
  const GradesScreen({super.key});

  @override
  State<GradesScreen> createState() => _GradesScreenState();
}

class _GradesScreenState extends State<GradesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExamsTab(),
                  _buildAssessmentsTab(),
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Learning Progress',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.blue.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.school, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Grade 3',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Academic Year 2024-2025',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue.shade500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        tabs: const [
          Tab(
            icon: Icon(Icons.quiz),
            text: 'Exams',
          ),
          Tab(
            icon: Icon(Icons.assignment),
            text: 'Assessments',
          ),
        ],
      ),
    );
  }

  Widget _buildExamsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildExamSection(
            'Termly Results',
            Icons.calendar_month,
            Colors.green,
            [
              {'subject': 'Mathematics', 'score': '85', 'grade': 'A'},
              {'subject': 'English', 'score': '78', 'grade': 'B+'},
              {'subject': 'Science', 'score': '92', 'grade': 'A'},
              {'subject': 'Social Studies', 'score': '76', 'grade': 'B'},
              {'subject': 'Kiswahili', 'score': '88', 'grade': 'A'},
            ],
          ),
          const SizedBox(height: 20),
          _buildExamSection(
            'Yearly Results',
            Icons.calendar_today,
            Colors.purple,
            [
              {'subject': 'Mathematics', 'score': '83', 'grade': 'A'},
              {'subject': 'English', 'score': '80', 'grade': 'A'},
              {'subject': 'Science', 'score': '89', 'grade': 'A'},
              {'subject': 'Social Studies', 'score': '77', 'grade': 'B+'},
              {'subject': 'Kiswahili', 'score': '86', 'grade': 'A'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildAssessmentSection(
            'Summative Assessment',
            Icons.fact_check,
            Colors.orange,
            [
              {'activity': 'Mathematics Project', 'level': 'Exceeding Expectations'},
              {'activity': 'Science Experiment', 'level': 'Meeting Expectations'},
              {'activity': 'English Composition', 'level': 'Exceeding Expectations'},
              {'activity': 'Social Studies Report', 'level': 'Meeting Expectations'},
            ],
          ),
          const SizedBox(height: 20),
          _buildAssessmentSection(
            'Formative Assessment',
            Icons.assignment_turned_in,
            Colors.teal,
            [
              {'activity': 'Daily Math Practice', 'level': 'Meeting Expectations'},
              {'activity': 'Reading Comprehension', 'level': 'Exceeding Expectations'},
              {'activity': 'Creative Writing', 'level': 'Approaching Expectations'},
              {'activity': 'Environmental Activities', 'level': 'Meeting Expectations'},
            ],
          ),
          const SizedBox(height: 20),
          _buildRubricLegend(),
        ],
      ),
    );
  }

  Widget _buildExamSection(String title, IconData icon, Color color, List<Map<String, String>> results) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
            itemBuilder: (context, index) {
              final result = results[index];
              return _buildExamResultRow(
                result['subject']!,
                result['score']!,
                result['grade']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExamResultRow(String subject, String score, String grade) {
    Color gradeColor = _getGradeColor(grade);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              subject,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '$score%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: gradeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: gradeColor.withOpacity(0.3)),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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

  Widget _buildAssessmentSection(String title, IconData icon, Color color, List<Map<String, String>> assessments) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assessments.length,
            separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200, height: 1),
            itemBuilder: (context, index) {
              final assessment = assessments[index];
              return _buildAssessmentRow(
                assessment['activity']!,
                assessment['level']!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentRow(String activity, String level) {
    Color levelColor = _getLevelColor(level);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: levelColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: levelColor.withOpacity(0.3)),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: levelColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRubricLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Assessment Levels Guide',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildRubricItem('Exceeding Expectations', 'Demonstrates exceptional competence', Colors.green),
          const SizedBox(height: 8),
          _buildRubricItem('Meeting Expectations', 'Demonstrates adequate competence', Colors.blue),
          const SizedBox(height: 8),
          _buildRubricItem('Approaching Expectations', 'Demonstrates developing competence', Colors.orange),
          const SizedBox(height: 8),
          _buildRubricItem('Below Expectations', 'Requires additional support', Colors.red),
        ],
      ),
    );
  }

  Widget _buildRubricItem(String level, String description, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: level,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: ' - $description',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      case 'D':
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
} 