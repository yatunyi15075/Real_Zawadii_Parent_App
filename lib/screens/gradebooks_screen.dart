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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Grade 3 • Class of 2025',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
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
    return Column(
      children: [
        _buildTermlyFilters(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: _buildGradebookSection(
              '$selectedTerm Results',
              selectedYear,
              Icons.calendar_view_month_outlined,
              const Color(0xFF059669),
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
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: _buildGradebookSection(
              'Annual Results',
              selectedYear,
              Icons.calendar_today_outlined,
              const Color(0xFF7C3AED),
              _getYearlyResults(),
            ),
          ),
        ),
      ],
    );
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
              (value) => setState(() => selectedTerm = value!),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              'Academic Year',
              selectedYear,
              years,
              Icons.school_outlined,
              (value) => setState(() => selectedYear = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyFilters() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: _buildFilterDropdown(
        'Academic Year',
        selectedYear,
        years,
        Icons.school_outlined,
        (value) => setState(() => selectedYear = value!),
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

  List<Map<String, String>> _getTermlyResults() {
    return termlyResults[selectedTerm]?[selectedYear] ?? [];
  }

  List<Map<String, String>> _getYearlyResults() {
    return yearlyResults[selectedYear] ?? [];
  }

  Widget _buildGradebookSection(
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
    List<Map<String, String>> results,
  ) {
    if (results.isEmpty) {
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
                  accentColor.withOpacity(0.05),
                  accentColor.withOpacity(0.02),
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
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildAverageScore(results, accentColor),
              ],
            ),
          ),
          _buildResultsHeader(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            separatorBuilder: (context, index) => const Divider(
              color: Color(0xFFF1F5F9),
              height: 1,
              thickness: 1,
            ),
            itemBuilder: (context, index) {
              final result = results[index];
              return _buildGradebookRow(
                result['subject']!,
                result['score']!,
                result['grade']!,
                index == results.length - 1,
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

  Widget _buildAverageScore(List<Map<String, String>> results, Color accentColor) {
    if (results.isEmpty) return const SizedBox.shrink();
    
    double total = 0;
    for (var result in results) {
      total += double.tryParse(result['score']!) ?? 0;
    }
    double average = total / results.length;
    
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
          const Text(
            'Results for the selected period are not yet available.\nPlease check back later or contact your teacher.',
            style: TextStyle(
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
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: gradeColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  grade,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: gradeColor,
                    letterSpacing: 0.5,
                  ),
                ),
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
        return const Color(0xFF059669);
      case 'B+':
      case 'B':
        return const Color(0xFF3B82F6);
      case 'C+':
      case 'C':
        return const Color(0xFFF59E0B);
      case 'D':
      case 'E':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }
}