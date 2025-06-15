// widgets/nav_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/gradebooks_screen.dart';
import '../screens/assessments_screen.dart';
import '../screens/attendance_screen.dart';
import '../screens/notifications_screen.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;
    final isShortScreen = screenHeight < 600;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: _getNavBarHeight(isSmallScreen, isVerySmallScreen, isShortScreen),
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen ? 4 : (isSmallScreen ? 8 : 16),
            vertical: isShortScreen ? 4 : 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                0,
                Icons.home_rounded,
                Icons.home_outlined,
                'Home',
                isSmallScreen,
                isVerySmallScreen,
                isShortScreen,
              ),
              _buildNavItem(
                context,
                1,
                Icons.menu_book_rounded,
                Icons.menu_book_outlined,
                'Gradebooks',
                isSmallScreen,
                isVerySmallScreen,
                isShortScreen,
              ),
              _buildNavItem(
                context,
                2,
                Icons.assignment_rounded,
                Icons.assignment_outlined,
                'Assessments',
                isSmallScreen,
                isVerySmallScreen,
                isShortScreen,
              ),
              _buildNavItem(
                context,
                3,
                Icons.access_time_rounded,
                Icons.access_time_outlined,
                'Attendance',
                isSmallScreen,
                isVerySmallScreen,
                isShortScreen,
              ),
              _buildNavItem(
                context,
                4,
                Icons.notifications_rounded,
                Icons.notifications_outlined,
                'Notifications',
                isSmallScreen,
                isVerySmallScreen,
                isShortScreen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getNavBarHeight(bool isSmallScreen, bool isVerySmallScreen, bool isShortScreen) {
    if (isShortScreen) return 55;
    if (isVerySmallScreen) return 60;
    if (isSmallScreen) return 65;
    return 75;
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData activeIcon,
    IconData inactiveIcon,
    String label,
    bool isSmallScreen,
    bool isVerySmallScreen,
    bool isShortScreen,
  ) {
    final isActive = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavItemTap(context, index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isShortScreen ? 2 : (isSmallScreen ? 4 : 6),
            horizontal: isVerySmallScreen ? 2 : 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Flexible(
                flex: isShortScreen ? 2 : 3,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(_getIconPadding(isVerySmallScreen, isSmallScreen, isShortScreen)),
                  decoration: BoxDecoration(
                    color: isActive 
                      ? Colors.blue.shade600.withOpacity(0.15)
                      : Colors.transparent,
                    borderRadius: BorderRadius.circular(isVerySmallScreen ? 8 : 12),
                  ),
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive 
                      ? Colors.blue.shade600
                      : Colors.grey.shade600,
                    size: _getIconSize(isVerySmallScreen, isSmallScreen, isShortScreen),
                  ),
                ),
              ),
              
              // Spacing
              if (!isShortScreen) SizedBox(height: isVerySmallScreen ? 2 : 4),
              
              // Label
              Flexible(
                flex: isShortScreen ? 1 : 2,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: _getFontSize(isVerySmallScreen, isSmallScreen, isShortScreen),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive 
                      ? Colors.blue.shade600
                      : Colors.grey.shade600,
                    height: 1.0,
                  ),
                  child: Text(
                    _getLabel(label, isVerySmallScreen),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getIconPadding(bool isVerySmallScreen, bool isSmallScreen, bool isShortScreen) {
    if (isShortScreen) return 4;
    if (isVerySmallScreen) return 4;
    if (isSmallScreen) return 6;
    return 8;
  }

  double _getIconSize(bool isVerySmallScreen, bool isSmallScreen, bool isShortScreen) {
    if (isShortScreen) return 18;
    if (isVerySmallScreen) return 18;
    if (isSmallScreen) return 20;
    return 24;
  }

  double _getFontSize(bool isVerySmallScreen, bool isSmallScreen, bool isShortScreen) {
    if (isShortScreen) return 9;
    if (isVerySmallScreen) return 9;
    if (isSmallScreen) return 10;
    return 11;
  }

  String _getLabel(String label, bool isVerySmallScreen) {
    if (isVerySmallScreen) {
      // Shorten labels for very small screens
      switch (label) {
        case 'Gradebooks':
          return 'Grades';
        case 'Assessments':
          return 'Assess';
        case 'Notifications':
          return 'Alerts';
        case 'Attendance':
          return 'Attend';
        default:
          return label;
      }
    }
    return label;
  }

  void _onNavItemTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    // Add haptic feedback for better UX
    HapticFeedback.lightImpact();

    Widget destination;
    switch (index) {
      case 0:
        destination = const HomeScreen();
        break;
      case 1:
        destination = const GradebooksScreen();
        break;
      case 2:
        destination = const AssessmentsScreen();
        break;
      case 3:
        destination = const AttendanceScreen();
        break;
      case 4:
        destination = const NotificationsScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}