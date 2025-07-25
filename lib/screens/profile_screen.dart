// screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _error;
  Map<String, dynamic>? _parentInfo;

  // Replace with your actual backend URL
  static const String API_BASE_URL = 'https://zawadi-project.onrender.com';

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        // Navigate to login screen if no token
        Navigator.of(context).pushReplacementNamed('/parent/signin');
        return;
      }

      // Check for cached data (optional, similar to web app)
      final cachedData = prefs.getString('parentInfo');
      final timestampStr = prefs.getString('dataTimestamp');
      
      if (cachedData != null && timestampStr != null) {
        final timestamp = int.tryParse(timestampStr);
        final now = DateTime.now().millisecondsSinceEpoch;
        const oneHour = 1000 * 60 * 60;
        
        if (timestamp != null && now - timestamp < oneHour) {
          // Use cached data
          final data = json.decode(cachedData);
          _updateProfileData(data);
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      // Fetch from backend
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/users/parent/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _updateProfileData(data);
        
        // Cache the data
        await prefs.setString('parentInfo', json.encode(data));
        await prefs.setString('dataTimestamp', DateTime.now().millisecondsSinceEpoch.toString());
        
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        // Token expired, navigate to login
        await prefs.clear();
        Navigator.of(context).pushReplacementNamed('/parent/signin');
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to fetch profile details. Please try again later.';
        _isLoading = false;
      });
      print('Error fetching profile: $e');
    }
  }

  void _updateProfileData(Map<String, dynamic> data) {
    _parentInfo = data;
    setState(() {});
  }

  String _getInitials() {
    if (_parentInfo?['username'] == null || _parentInfo!['username'].isEmpty) {
      return 'U';
    }
    
    final username = _parentInfo!['username'].toString();
    final names = username.split(' ');
    
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else {
      return names[0][0].toUpperCase();
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushReplacementNamed('/parent/signin');
  }

  Future<void> _refreshProfile() async {
    // Clear cache and refetch
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('parentInfo');
    await prefs.remove('dataTimestamp');
    await _fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Information'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _refreshProfile,
            tooltip: 'Refresh Profile',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _refreshProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Error message
                    if (_error != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border(
                            left: BorderSide(color: Colors.red.shade500, width: 4),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error, color: Colors.red.shade500),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 20),
                    
                    // Profile Picture with initials
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            _getInitials(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile picture feature coming soon!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    
                    // Welcome message
                    Text(
                      'Welcome, ${_parentInfo?['username'] ?? 'User'}!',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Parent Dashboard',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Profile Information Cards
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Information',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            
                            _buildInfoTile(
                              icon: Icons.person_outline,
                              title: 'Username',
                              value: _parentInfo?['username'] ?? 'Not provided',
                            ),
                            const Divider(height: 24),
                            
                            _buildInfoTile(
                              icon: Icons.email_outlined,
                              title: 'Email',
                              value: _parentInfo?['email'] ?? 'Not provided',
                            ),
                            const Divider(height: 24),
                            
                            _buildInfoTile(
                              icon: Icons.badge_outlined,
                              title: 'Role',
                              value: _parentInfo?['role']?.toString().toUpperCase() ?? 'Not specified',
                            ),
                            const Divider(height: 24),
                            
                            _buildInfoTile(
                              icon: Icons.school_outlined,
                              title: 'School',
                              value: _parentInfo?['schoolName'] ?? 'Not specified',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _refreshProfile,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Refresh'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _handleLogout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Information note
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border(
                          left: BorderSide(color: Colors.blue.shade500, width: 4),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade600),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Profile Updates',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'To update your profile information, please contact your school administrator.',
                                  style: TextStyle(
                                    color: Colors.blue.shade600,
                                    fontSize: 14,
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
              ),
            ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}