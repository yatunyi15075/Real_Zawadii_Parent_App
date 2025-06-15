// screens/privacy_screen.dart
import 'package:flutter/material.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool _dataCollection = true;
  bool _personalizedAds = false;
  bool _analyticsSharing = true;
  bool _locationTracking = false;
  bool _crashReporting = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Data & Privacy'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: Icon(
                    Icons.data_usage,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Data Collection'),
                  subtitle: const Text('Allow collection of usage data to improve the app'),
                  value: _dataCollection,
                  onChanged: (value) {
                    setState(() {
                      _dataCollection = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.ads_click,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Personalized Ads'),
                  subtitle: const Text('Show ads based on your interests'),
                  value: _personalizedAds,
                  onChanged: (value) {
                    setState(() {
                      _personalizedAds = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.analytics,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Analytics Sharing'),
                  subtitle: const Text('Share anonymous usage analytics'),
                  value: _analyticsSharing,
                  onChanged: (value) {
                    setState(() {
                      _analyticsSharing = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.location_on,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Location Tracking'),
                  subtitle: const Text('Allow location-based features'),
                  value: _locationTracking,
                  onChanged: (value) {
                    setState(() {
                      _locationTracking = value;
                    });
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: Icon(
                    Icons.bug_report,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Crash Reporting'),
                  subtitle: const Text('Automatically send crash reports'),
                  value: _crashReporting,
                  onChanged: (value) {
                    setState(() {
                      _crashReporting = value;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Data Management'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.download,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Download My Data'),
                  subtitle: const Text('Get a copy of your data'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showDownloadDataDialog();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Delete My Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Permanently delete your account and data'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () {
                    _showDeleteAccountDialog();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Legal'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.policy,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Privacy Policy'),
                  subtitle: const Text('Read our privacy policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showPrivacyPolicy();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.description,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Terms of Service'),
                  subtitle: const Text('Read our terms of service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showTermsOfService();
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.cookie,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: const Text('Cookie Policy'),
                  subtitle: const Text('Learn about our cookie usage'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showCookiePolicy();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.shield,
                    color: Theme.of(context).primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your Privacy Matters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We are committed to protecting your privacy and giving you control over your personal information.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  void _showDownloadDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Download My Data'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download,
                size: 48,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                'We will prepare a file containing all your data and send it to your registered email address.',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'This process may take up to 48 hours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data download request submitted. You will receive an email shortly.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Request Download'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Account',
            style: TextStyle(color: Colors.red),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                size: 48,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'Are you sure you want to delete your account?',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'This action cannot be undone. All your data will be permanently deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In a real app, this would handle account deletion
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account deletion process initiated. You will receive a confirmation email.'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Account'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Privacy Policy\n\n'
              'Last updated: [Date]\n\n'
              'This Privacy Policy describes how Parent Portal ("we", "our", or "us") collects, uses, and shares your personal information when you use our mobile application.\n\n'
              'Information We Collect:\n'
              '• Personal information you provide (name, email, phone number)\n'
              '• Usage data and analytics\n'
              '• Device information\n'
              '• Location data (if enabled)\n\n'
              'How We Use Your Information:\n'
              '• To provide and maintain our service\n'
              '• To notify you about changes to our service\n'
              '• To provide customer support\n'
              '• To gather analysis or valuable information to improve our service\n\n'
              'For more details, please visit our website.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms of Service'),
          content: const SingleChildScrollView(
            child: Text(
              'Terms of Service\n\n'
              'Last updated: [Date]\n\n'
              'Please read these Terms of Service ("Terms", "Terms of Service") carefully before using the Parent Portal mobile application operated by us.\n\n'
              'Acceptance of Terms:\n'
              'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement.\n\n'
              'Use License:\n'
              'Permission is granted to temporarily use this application for personal, non-commercial transitory viewing only.\n\n'
              'User Accounts:\n'
              'When you create an account with us, you must provide information that is accurate, complete, and current at all times.\n\n'
              'For complete terms, please visit our website.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showCookiePolicy() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cookie Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Cookie Policy\n\n'
              'Last updated: [Date]\n\n'
              'This Cookie Policy explains how Parent Portal uses cookies and similar technologies when you use our mobile application.\n\n'
              'What are Cookies:\n'
              'Cookies are small pieces of text sent by your web browser by a website you visit. A cookie file is stored in your web browser and allows the application to recognize you.\n\n'
              'How We Use Cookies:\n'
              '• Essential cookies: Required for the application to function properly\n'
              '• Analytics cookies: Help us understand how you use our application\n'
              '• Preference cookies: Remember your settings and preferences\n\n'
              'Managing Cookies:\n'
              'You can control cookies through your device settings. However, disabling certain cookies may affect the functionality of the application.\n\n'
              'For more information, please visit our website.',
              style: TextStyle(fontSize: 12),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}