// screens/about_screen.dart
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.school,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Parent Portal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Description
            _buildSectionHeader('About the App'),
            const Text(
              'Parent Portal is designed to help parents stay connected with their child\'s education. Monitor progress, communicate with teachers, and stay informed about school activities all in one convenient app.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            
            // Features
            _buildSectionHeader('Key Features'),
            _buildFeatureItem(
              icon: Icons.dashboard,
              title: 'Dashboard Overview',
              description: 'Get a quick overview of your child\'s academic progress',
            ),
            _buildFeatureItem(
              icon: Icons.assignment,
              title: 'Assignment Tracking',
              description: 'Monitor homework and project deadlines',
            ),
            _buildFeatureItem(
              icon: Icons.grade,
              title: 'Grade Monitoring',
              description: 'Stay updated on test scores and grades',
            ),
            _buildFeatureItem(
              icon: Icons.message,
              title: 'Teacher Communication',
              description: 'Direct messaging with teachers and staff',
            ),
            _buildFeatureItem(
              icon: Icons.event,
              title: 'School Events',
              description: 'Never miss important school events and activities',
            ),
            const SizedBox(height: 24),
            
            // Contact Information
            _buildSectionHeader('Contact Us'),
            _buildContactItem(
              icon: Icons.email,
              title: 'Email Support',
              subtitle: 'support@parentportal.com',
              onTap: () => _showContactInfo(context, 'Email', 'support@parentportal.com'),
            ),
            _buildContactItem(
              icon: Icons.phone,
              title: 'Phone Support',
              subtitle: '+1 (555) 123-4567',
              onTap: () => _showContactInfo(context, 'Phone', '+1 (555) 123-4567'),
            ),
            _buildContactItem(
              icon: Icons.web,
              title: 'Website',
              subtitle: 'www.parentportal.com',
              onTap: () => _showContactInfo(context, 'Website', 'www.parentportal.com'),
            ),
            const SizedBox(height: 24),
            
            // Legal Information
            _buildSectionHeader('Legal'),
            _buildLegalItem(
              title: 'Terms of Service',
              onTap: () => _showTermsDialog(context),
            ),
            _buildLegalItem(
              title: 'Privacy Policy',
              onTap: () => _showPrivacyDialog(context),
            ),
            _buildLegalItem(
              title: 'Open Source Licenses',
              onTap: () => _showLicensesDialog(context),
            ),
            const SizedBox(height: 32),
            
            // Footer
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2024 Parent Portal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Made with ❤️ for parents and students',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.green,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(
        Icons.launch,
        color: Colors.grey,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildLegalItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.description,
          color: Colors.orange,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  void _showContactInfo(BuildContext context, String type, String info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$type Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Contact us via $type:'),
              const SizedBox(height: 16),
              SelectableText(
                info,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms of Service'),
          content: const SingleChildScrollView(
            child: Text(
              'By using Parent Portal, you agree to our terms of service. This includes responsible use of the platform, respect for privacy of other users, and compliance with school policies.\n\n'
              'Users are responsible for maintaining the security of their account credentials and for all activities under their account.\n\n'
              'The service is provided "as is" without warranties of any kind.',
            ),
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

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'We take your privacy seriously. Parent Portal collects only the information necessary to provide educational services.\n\n'
              'Personal information is used solely for communication between parents, students, and school staff.\n\n'
              'We do not sell or share personal information with third parties except as required by law or school policy.\n\n'
              'Data is stored securely and access is limited to authorized personnel only.',
            ),
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

  void _showLicensesDialog(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Parent Portal',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.school,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}