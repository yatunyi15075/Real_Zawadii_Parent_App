// screens/help_center_screen.dart
import 'package:flutter/material.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<HelpItem> _helpItems = [
    HelpItem(
      category: 'Getting Started',
      title: 'How to set up your account',
      content: 'To set up your Parent Portal account:\n\n'
          '1. Download the app from your device\'s app store\n'
          '2. Tap "Create Account" on the login screen\n'
          '3. Enter your email address and create a password\n'
          '4. Verify your email address\n'
          '5. Enter the school code provided by your child\'s school\n'
          '6. Add your child\'s information to link their academic records\n\n'
          'If you need help finding your school code, contact your school\'s main office.',
      icon: Icons.account_circle,
    ),
    HelpItem(
      category: 'Getting Started',
      title: 'Adding your child to the account',
      content: 'To add your child to your Parent Portal account:\n\n'
          '1. Go to Settings > Profile Information\n'
          '2. Tap "Add Child"\n'
          '3. Enter your child\'s full name as registered at school\n'
          '4. Enter their student ID number\n'
          '5. Select their grade level\n'
          '6. Tap "Add Child"\n\n'
          'Note: You may need to wait for school approval before seeing academic information.',
      icon: Icons.person_add,
    ),
    HelpItem(
      category: 'Grades & Progress',
      title: 'How to view grades and assignments',
      content: 'To view your child\'s grades and assignments:\n\n'
          '1. Open the app and go to the Dashboard\n'
          '2. Tap on "Grades" to see current grades by subject\n'
          '3. Tap on any subject to see detailed assignment information\n'
          '4. Use the date filter to view grades from specific time periods\n\n'
          'Grades are updated in real-time as teachers enter them into the system.',
      icon: Icons.grade,
    ),
    HelpItem(
      category: 'Grades & Progress',
      title: 'Understanding the grade breakdown',
      content: 'Grade categories and their meanings:\n\n'
          '• A (90-100%): Excellent work\n'
          '• B (80-89%): Good work\n'
          '• C (70-79%): Satisfactory work\n'
          '• D (60-69%): Below average work\n'
          '• F (Below 60%): Failing grade\n\n'
          'Some assignments may show as "Not Graded" if the teacher hasn\'t entered a grade yet.',
      icon: Icons.analytics,
    ),
    HelpItem(
      category: 'Communication',
      title: 'How to message teachers',
      content: 'To send a message to your child\'s teacher:\n\n'
          '1. Go to the Messages tab\n'
          '2. Tap the "+" button to start a new conversation\n'
          '3. Select the teacher from the list\n'
          '4. Type your message and tap Send\n\n'
          'Teachers typically respond within 24-48 hours during school days.\n\n'
          'For urgent matters, contact the school office directly.',
      icon: Icons.message,
    ),
    HelpItem(
      category: 'Communication',
      title: 'Setting up notifications',
      content: 'To customize your notification settings:\n\n'
          '1. Go to Settings > Notifications\n'
          '2. Toggle notifications on/off\n'
          '3. Choose which types of notifications you want to receive:\n'
          '   • New grades posted\n'
          '   • Assignment due date reminders\n'
          '   • Messages from teachers\n'
          '   • School announcements\n\n'
          'You can also set quiet hours when you don\'t want to receive notifications.',
      icon: Icons.notifications,
    ),
    HelpItem(
      category: 'Technical Issues',
      title: 'App not loading or crashing',
      content: 'If the app is not working properly, try these steps:\n\n'
          '1. Force close the app and reopen it\n'
          '2. Check your internet connection\n'
          '3. Update the app to the latest version\n'
          '4. Restart your device\n'
          '5. Clear the app cache (Android only)\n\n'
          'If problems persist, contact our support team with details about your device and the issue.',
      icon: Icons.bug_report,
    ),
    HelpItem(
      category: 'Technical Issues',
      title: 'Forgot password',
      content: 'To reset your password:\n\n'
          '1. On the login screen, tap "Forgot Password?"\n'
          '2. Enter the email address associated with your account\n'
          '3. Check your email for a password reset link\n'
          '4. Click the link and follow the instructions to create a new password\n\n'
          'If you don\'t receive the email within 10 minutes, check your spam folder.',
      icon: Icons.lock_reset,
    ),
    HelpItem(
      category: 'Account Settings',
      title: 'Changing your email address',
      content: 'To change your email address:\n\n'
          '1. Go to Settings > Profile Information\n'
          '2. Tap on your current email address\n'
          '3. Enter your new email address\n'
          '4. Tap "Update Email"\n'
          '5. Verify the new email address by clicking the link sent to your new email\n\n'
          'Your login credentials will change to the new email address.',
      icon: Icons.email,
    ),
    HelpItem(
      category: 'Account Settings',
      title: 'Privacy and data settings',
      content: 'Your privacy is important to us. Here\'s what you should know:\n\n'
          '• Your data is encrypted and stored securely\n'
          '• Only you and authorized school personnel can access your child\'s information\n'
          '• You can request to download or delete your data at any time\n'
          '• We never sell or share your personal information\n\n'
          'To manage your privacy settings, go to Settings > Privacy.',
      icon: Icons.privacy_tip,
    ),
  ];

  List<HelpItem> get _filteredItems {
    if (_searchQuery.isEmpty) {
      return _helpItems;
    }
    return _helpItems.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Theme.of(context).primaryColor,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for help...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Quick Actions
          if (_searchQuery.isEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.chat,
                          title: 'Contact Support',
                          subtitle: 'Get help from our team',
                          onTap: () => _showContactDialog(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickActionCard(
                          icon: Icons.video_library,
                          title: 'Video Tutorials',
                          subtitle: 'Watch how-to videos',
                          onTap: () => _showComingSoonDialog(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          
          // Help Items
          Expanded(
            child: _filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching with different keywords',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _buildHelpItem(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(HelpItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            item.icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          item.category,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              item.content,
              style: const TextStyle(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Need more help? Contact our support team:'),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text('support@parentportal.com'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 8),
                  Text('+1 (555) 123-4567'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Mon-Fri, 8AM-6PM EST'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Coming Soon'),
          content: const Text(
            'Video tutorials are coming soon! In the meantime, you can find detailed written instructions above or contact our support team.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class HelpItem {
  final String category;
  final String title;
  final String content;
  final IconData icon;

  HelpItem({
    required this.category,
    required this.title,
    required this.content,
    required this.icon,
  });
}