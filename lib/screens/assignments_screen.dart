// screens/assignments_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class Assignment {
  final String title;
  final String subject;
  final String teacher;
  final DateTime dueDate;
  final String status;
  final String description;

  Assignment({
    required this.title,
    required this.subject,
    required this.teacher,
    required this.dueDate,
    required this.status,
    required this.description,
  });

  bool get isExpired => DateTime.now().isAfter(dueDate) && status != 'Completed';
}

class AssignmentsScreen extends StatefulWidget {
  const AssignmentsScreen({super.key});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  String _selectedFilter = 'All';
  DateTime? _selectedDate;
  
  final List<Assignment> _assignments = [
    Assignment(
      title: 'Algebra Problems Set 3',
      subject: 'Mathematics',
      teacher: 'Mr. White',
      dueDate: DateTime(2025, 6, 5),
      status: 'Pending',
      description: 'Complete exercises 1-20 from Chapter 5',
    ),
    Assignment(
      title: 'Essay on Climate Change',
      subject: 'English',
      teacher: 'Ms. Johnson',
      dueDate: DateTime(2025, 6, 3),
      status: 'In Progress',
      description: 'Write a 500-word essay on climate change effects',
    ),
    Assignment(
      title: 'Science Project',
      subject: 'Science & Technology',
      teacher: 'Mr. Kimani',
      dueDate: DateTime(2025, 5, 28), // Past date - expired
      status: 'Pending',
      description: 'Build a simple electric circuit',
    ),
    Assignment(
      title: 'History Timeline',
      subject: 'Social Studies',
      teacher: 'Mrs. Ochieng',
      dueDate: DateTime(2025, 6, 8),
      status: 'Completed',
      description: 'Create timeline of Kenyan independence',
    ),
    Assignment(
      title: 'Kiswahili Composition',
      subject: 'Kiswahili',
      teacher: 'Mrs. Wanjiku',
      dueDate: DateTime(2025, 5, 30), // Past date - expired
      status: 'Pending',
      description: 'Andika insha kuhusu mazingira',
    ),
    Assignment(
      title: 'Art Portfolio',
      subject: 'Creative Arts',
      teacher: 'Mr. Mwangi',
      dueDate: DateTime(2025, 6, 10),
      status: 'In Progress',
      description: 'Complete 5 drawings using different techniques',
    ),
    Assignment(
      title: 'Math Quiz Preparation',
      subject: 'Mathematics',
      teacher: 'Mr. White',
      dueDate: DateTime(2025, 6, 1),
      status: 'Completed',
      description: 'Review chapters 1-4 for upcoming quiz',
    ),
  ];

  List<Assignment> get _filteredAssignments {
    List<Assignment> filtered = _assignments;
    
    // Filter by status
    if (_selectedFilter != 'All') {
      if (_selectedFilter == 'Expired') {
        filtered = filtered.where((assignment) => assignment.isExpired).toList();
      } else {
        filtered = filtered.where((assignment) => assignment.status == _selectedFilter).toList();
      }
    }
    
    // Filter by date if selected
    if (_selectedDate != null) {
      filtered = filtered.where((assignment) {
        return assignment.dueDate.year == _selectedDate!.year &&
               assignment.dueDate.month == _selectedDate!.month &&
               assignment.dueDate.day == _selectedDate!.day;
      }).toList();
    }
    
    // Sort by due date (earliest first)
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filteredAssignments = _filteredAssignments;
    final completedCount = _assignments.where((a) => a.status == 'Completed').length;
    final totalCount = _assignments.length;
    final expiredCount = _assignments.where((a) => a.isExpired).length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.shade600,
                    Colors.orange.shade400,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Assignments',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatChip('Total', totalCount.toString(), Colors.white),
                      const SizedBox(width: 12),
                      _buildStatChip('Completed', completedCount.toString(), Colors.green),
                      const SizedBox(width: 12),
                      _buildStatChip('Expired', expiredCount.toString(), Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            
            // Filters
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                children: [
                  // Status Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        'All',
                        'Pending',
                        'In Progress',
                        'Completed',
                        'Expired',
                      ].map((filter) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(filter),
                          selected: _selectedFilter == filter,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          selectedColor: Colors.orange.shade100,
                          checkmarkColor: Colors.orange,
                        ),
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date Filter
                  Row(
                    children: [
                      const Icon(Icons.date_range, size: 20),
                      const SizedBox(width: 8),
                      const Text('Filter by due date:'),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          _selectedDate == null 
                            ? 'Select Date' 
                            : _formatDate(_selectedDate!),
                          style: TextStyle(color: Colors.orange.shade600),
                        ),
                      ),
                      if (_selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Assignments List
            Expanded(
              child: filteredAssignments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No assignments found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredAssignments.length,
                    itemBuilder: (context, index) {
                      final assignment = filteredAssignments[index];
                      return _buildAssignmentCard(assignment);
                    },
                  ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 1),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color == Colors.white ? Colors.white : color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color == Colors.white ? Colors.white : color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(Assignment assignment) {
    final isExpired = assignment.isExpired;
    final daysUntilDue = assignment.dueDate.difference(DateTime.now()).inDays;
    
    Color getStatusColor() {
      if (isExpired) return Colors.red;
      switch (assignment.status) {
        case 'Completed':
          return Colors.green;
        case 'In Progress':
          return Colors.blue;
        case 'Pending':
          return Colors.orange;
        default:
          return Colors.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isExpired 
          ? Border.all(color: Colors.red.shade300, width: 2)
          : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    assignment.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isExpired ? 'EXPIRED' : assignment.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.subject, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  assignment.subject,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  assignment.teacher,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              assignment.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: isExpired ? Colors.red : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${_formatDate(assignment.dueDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isExpired ? Colors.red : Colors.grey.shade600,
                        fontWeight: isExpired ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                if (!isExpired && assignment.status != 'Completed')
                  Text(
                    daysUntilDue == 0 
                      ? 'Due Today!' 
                      : daysUntilDue > 0 
                        ? '$daysUntilDue days left'
                        : 'Overdue',
                    style: TextStyle(
                      fontSize: 12,
                      color: daysUntilDue <= 1 ? Colors.red : Colors.orange.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange.shade600,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
