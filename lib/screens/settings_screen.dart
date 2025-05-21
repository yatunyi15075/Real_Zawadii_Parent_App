// screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../widgets/nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader('Account Settings'),
          _buildSettingItem(
            context: context,
            icon: Icons.person_outline,
            title: 'Profile Information',
            subtitle: 'Change your personal information',
            onTap: () {},
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.lock_outline,
            title: 'Security',
            subtitle: 'Change password and security settings',
            onTap: () {},
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Configure your notification preferences',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('App Settings'),
          _buildSettingItem(
            context: context,
            icon: Icons.language,
            title: 'Language',
            subtitle: 'English (US)',
            onTap: () {},
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.dark_mode_outlined,
            title: 'Theme',
            subtitle: 'Light',
            onTap: () {},
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy',
            subtitle: 'Manage your data and privacy settings',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildSectionHeader('Support'),
          _buildSettingItem(
            context: context,
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'Get help with the Parent Portal app',
            onTap: () {},
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            onTap: () {},
          ),
          _buildSettingItem(
            context: context,
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Sign Out'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: const NavBar(currentIndex: 3),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

  Widget _buildSettingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.blue.shade700,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}