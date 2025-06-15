// screens/gradebooks_screen.dart
import 'package:flutter/material.dart';
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
  String selectedYear = '2024-2025';
  
  final List<String> terms = ['Term 1', 'Term 2', 'Term 3'];
  final List<String> years = ['2024-2025', '2023-2024', '2022-2023'];

  // Sample data - in real app this would come from API/database
  final Map<String, Map<String, List<Map<String, String>>>> termlyResults = {
    'Term 1': {
      '2024-2025': [
        {'subject': 'Mathematics', 'score': '85', 'grade': 'A'},
        {'subject': 'English', 'score': '78', 'grade': 'B+'},
        {'subject': 'Science', 'score': '92', 'grade': 'A'},
        {'subject': 'Social Studies', 'score': '76', 'grade': 'B'},
        {'subject': 'Kiswahili', 'score': '88', 'grade': 'A'},
      ],
      '2023-2024': [
        {'subject': 'Mathematics', 'score': '82', 'grade': 'A'},
        {'subject': 'English', 'score': '75', 'grade': 'B'},
        {'subject': 'Science', 'score': '89', 'grade': 'A'},
        {'subject': 'Social Studies', 'score': '73', 'grade': 'B'},
        {'subject': 'Kiswahili', 'score': '85', 'grade': 'A'},
      ],
    },
    'Term 2': {
      '2024-2025': [
        {'subject': 'Mathematics', 'score': '87', 'grade': 'A'},
        {'subject': 'English', 'score': '80', 'grade': 'A'},
        {'subject': 'Science', 'score': '94', 'grade': 'A'},
        {'subject': 'Social Studies', 'score': '78', 'grade': 'B+'},
        {'subject': 'Kiswahili', 'score': '90', 'grade': 'A'},
      ],
    },
    'Term 3': {
      '2024-2025': [
        {'subject': 'Mathematics', 'score': '89', 'grade': 'A'},
        {'subject': 'English', 'score': '82', 'grade': 'A'},
        {'subject': 'Science', 'score': '96', 'grade': 'A'},
        {'subject': 'Social Studies', 'score': '80', 'grade': 'A'},
        {'subject': 'Kiswahili', 'score': '92', 'grade': 'A'},
      ],
    },
  };

  final Map<String, List<Map<String, String>>> yearlyResults = {
    '2024-2025': [
      {'subject': 'Mathematics', 'score': '87', 'grade': 'A'},
      {'subject': 'English', 'score': '80', 'grade': 'A'},
      {'subject': 'Science', 'score': '94', 'grade': 'A'},
      {'subject': 'Social Studies', 'score': '78', 'grade': 'B+'},
      {'subject': 'Kiswahili', 'score': '90', 'grade': 'A'},
    ],
    '2023-2024': [
      {'subject': 'Mathematics', 'score': '83', 'grade': 'A'},
      {'subject': 'English', 'score': '77', 'grade': 'B+'},
      {'subject': 'Science', 'score': '91', 'grade': 'A'},
      {'subject': 'Social Studies', 'score': '75', 'grade': 'B'},
      {'subject': 'Kiswahili', 'score': '86', 'grade': 'A'},
    ],
  };

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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gradebooks',
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grade 3',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Academic Performance Overview',
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
            icon: Icon(Icons.calendar_month),
            text: 'Termly Results',
          ),
          Tab(
            icon: Icon(Icons.calendar_today),
            text: 'Yearly Results',
          ),
        ],
      ),
    );
  }

  Widget _buildTermlyTab() {
    return Column(
      children: [
        _buildTermlyFilters(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildGradebookSection(
              'Term $selectedTerm Results - $selectedYear',
              Icons.calendar_month,
              Colors.green,
              _getTermlyResults(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYearlyTab() {
    return Column(
      children: [
        _buildYearlyFilters(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildGradebookSection(
              'Annual Results - $selectedYear',
              Icons.calendar_today,
              Colors.purple,
              _getYearlyResults(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermlyFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              'Term',
              selectedTerm,
              terms,
              (value) => setState(() => selectedTerm = value!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterDropdown(
              'Academic Year',
              selectedYear,
              years,
              (value) => setState(() => selectedYear = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: _buildFilterDropdown(
        'Academic Year',
        selectedYear,
        years,
        (value) => setState(() => selectedYear = value!),
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          hint: Text(
            label,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getTermlyResults() {
    return termlyResults[selectedTerm]?[selectedYear] ?? [];
  }

  List<Map<String, String>> _getYearlyResults() {
    return yearlyResults[selectedYear] ?? [];
  }

  Widget _buildGradebookSection(String title, IconData icon, Color color, List<Map<String, String>> results) {
    if (results.isEmpty) {
      return _buildEmptyState();
    }

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
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
                _buildAverageScore(results),
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
              return _buildGradebookRow(
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

  Widget _buildAverageScore(List<Map<String, String>> results) {
    if (results.isEmpty) return const SizedBox.shrink();
    
    double total = 0;
    for (var result in results) {
      total += double.tryParse(result['score']!) ?? 0;
    }
    double average = total / results.length;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        'Avg: ${average.toStringAsFixed(1)}%',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Results Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Results for the selected period are not yet available.',
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

  Widget _buildGradebookRow(String subject, String score, String grade) {
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
}