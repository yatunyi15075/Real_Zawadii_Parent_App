// screens/feedback_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/nav_bar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<dynamic> communications = [];
  List<dynamic> filteredCommunications = [];
  bool loading = true;
  String searchTerm = '';
  int currentPage = 1;
  final int communicationsPerPage = 6;
  String sortKey = 'date';
  bool sortAscending = false;
  String? authToken;

  // Replace with your actual API URL
  static const String apiUrl = 'https://zawadi-project.onrender.com';

  @override
  void initState() {
    super.initState();
    _loadAuthToken();
  }

  Future<void> _loadAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('auth_token') ?? prefs.getString('token');
      
      if (authToken != null) {
        fetchCommunications();
      } else {
        setState(() {
          loading = false;
        });
        _showError('Authentication token not found. Please login again.');
      }
    } catch (error) {
      setState(() {
        loading = false;
      });
      _showError('Error loading authentication: $error');
    }
  }

  Future<void> fetchCommunications() async {
    if (authToken == null) {
      _showError('No authentication token available');
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      final response = await http.get(
        Uri.parse('$apiUrl/api/announcements'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          communications = data;
          filteredCommunications = data;
          _applySortingAndFiltering();
          loading = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          loading = false;
        });
        _showError('Authentication failed. Please login again.');
        // Optionally navigate to login screen
        // Navigator.pushReplacementNamed(context, '/login');
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching announcements: $error');
      setState(() {
        loading = false;
      });
      _showError('Error loading announcements: $error');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              if (authToken != null) {
                fetchCommunications();
              } else {
                _loadAuthToken();
              }
            },
          ),
        ),
      );
    }
  }

  void _applySortingAndFiltering() {
    // Filter communications based on search term
    List<dynamic> filtered = communications.where((communication) {
      final announcement = communication['announcement']?.toString().toLowerCase() ?? '';
      final section = communication['section']?.toString().toLowerCase() ?? '';
      return announcement.contains(searchTerm.toLowerCase()) ||
             section.contains(searchTerm.toLowerCase());
    }).toList();

    // Sort the filtered array
    filtered.sort((a, b) {
      dynamic aValue = a[sortKey];
      dynamic bValue = b[sortKey];
      
      if (aValue == null && bValue == null) return 0;
      if (aValue == null) return sortAscending ? -1 : 1;
      if (bValue == null) return sortAscending ? 1 : -1;
      
      int comparison = aValue.toString().compareTo(bValue.toString());
      return sortAscending ? comparison : -comparison;
    });

    setState(() {
      filteredCommunications = filtered;
      currentPage = 1; // Reset to first page when filtering
    });
  }

  void _handleSearch(String value) {
    setState(() {
      searchTerm = value;
    });
    _applySortingAndFiltering();
  }

  void _handleSort(String key) {
    setState(() {
      if (sortKey == key) {
        sortAscending = !sortAscending;
      } else {
        sortKey = key;
        sortAscending = true;
      }
    });
    _applySortingAndFiltering();
  }

  List<dynamic> get currentCommunications {
    final indexOfLastCommunication = currentPage * communicationsPerPage;
    final indexOfFirstCommunication = indexOfLastCommunication - communicationsPerPage;
    return filteredCommunications.sublist(
      indexOfFirstCommunication,
      indexOfLastCommunication > filteredCommunications.length
          ? filteredCommunications.length
          : indexOfLastCommunication,
    );
  }

  int get totalPages => (filteredCommunications.length / communicationsPerPage).ceil();

  void _changePage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date not specified';
    try {
      final date = DateTime.parse(dateString);
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return 'Date not specified';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'Communications',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      // Add refresh button
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: loading ? null : fetchCommunications,
                        tooltip: 'Refresh announcements',
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 56.0),
                    child: Text(
                      'View school announcements and communications',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header with search
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.campaign, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                'Announcements (${filteredCommunications.length} total)',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Search Bar
                          TextField(
                            onChanged: _handleSearch,
                            decoration: InputDecoration(
                              hintText: 'Search announcements...',
                              prefixIcon: const Icon(Icons.search, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Sort Controls
                          Row(
                            children: [
                              const Text('Sort by: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                              const SizedBox(width: 8),
                              _buildSortButton('Date', 'date'),
                              const SizedBox(width: 8),
                              _buildSortButton('Section', 'section'),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Expanded(
                      child: loading
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text(
                                    'Loading announcements...',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : authToken == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 64,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Authentication Required',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Please login to view announcements',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _loadAuthToken,
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                )
                              : filteredCommunications.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.campaign,
                                            size: 64,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'No announcements found',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            searchTerm.isNotEmpty
                                                ? 'No results matching "$searchTerm"'
                                                : 'No communications have been posted yet',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        // Communications List
                                        Expanded(
                                          child: ListView.builder(
                                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                            itemCount: currentCommunications.length,
                                            itemBuilder: (context, index) {
                                              final communication = currentCommunications[index];
                                              return _buildCommunicationCard(communication);
                                            },
                                          ),
                                        ),

                                        // Pagination
                                        if (filteredCommunications.length > communicationsPerPage)
                                          _buildPagination(),

                                        // Page info
                                        if (filteredCommunications.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Text(
                                              'Showing ${((currentPage - 1) * communicationsPerPage) + 1} to ${(currentPage * communicationsPerPage > filteredCommunications.length) ? filteredCommunications.length : currentPage * communicationsPerPage} of ${filteredCommunications.length} announcements',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                      ],
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortButton(String label, String key) {
    final isActive = sortKey == key;
    return GestureDetector(
      onTap: () => _handleSort(key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$label ${isActive ? (sortAscending ? '↑' : '↓') : ''}',
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.blue[700] : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationCard(Map<String, dynamic> communication) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    communication['announcement'] ?? 'No announcement',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    communication['section'] ?? 'General',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[100]!),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[400]),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(communication['createdAt'] ?? communication['date']),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Previous button
          IconButton(
            onPressed: currentPage > 1 ? () => _changePage(currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
            color: currentPage > 1 ? Colors.blue : Colors.grey,
          ),

          // Page numbers
          ...List.generate(
            totalPages > 5 ? 5 : totalPages,
            (index) {
              int pageNumber;
              if (totalPages <= 5) {
                pageNumber = index + 1;
              } else {
                if (currentPage <= 3) {
                  pageNumber = index + 1;
                } else if (currentPage >= totalPages - 2) {
                  pageNumber = totalPages - 4 + index;
                } else {
                  pageNumber = currentPage - 2 + index;
                }
              }

              return GestureDetector(
                onTap: () => _changePage(pageNumber),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: currentPage == pageNumber ? Colors.blue[100] : Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    pageNumber.toString(),
                    style: TextStyle(
                      color: currentPage == pageNumber ? Colors.blue[700] : Colors.grey[700],
                      fontWeight: currentPage == pageNumber ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),

          // Next button
          IconButton(
            onPressed: currentPage < totalPages ? () => _changePage(currentPage + 1) : null,
            icon: const Icon(Icons.chevron_right),
            color: currentPage < totalPages ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }
}