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
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: _getNavBarHeight(isSmallScreen, isVerySmallScreen, isShortScreen),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isVerySmallScreen ? 4 : (isSmallScreen ? 8 : 12),
              vertical: 2,
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
                  Icons.schedule_rounded,
                  Icons.schedule_outlined,
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
      ),
    );
  }

  double _getNavBarHeight(bool isSmallScreen, bool isVerySmallScreen, bool isShortScreen) {
    if (isShortScreen) return 50; // Reduced further
    if (isVerySmallScreen) return 55;
    if (isSmallScreen) return 58;
    return 62;
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onNavItemTap(context, index),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.blue.withOpacity(0.1),
          highlightColor: Colors.blue.withOpacity(0.05),
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isVerySmallScreen ? 2 : 4,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with professional styling
                Flexible(
                  flex: 3,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOutCubic,
                      tween: Tween<double>(
                        begin: 0,
                        end: isActive ? 1 : 0,
                      ),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: 1.0 + (value * 0.08), // Reduced scale effect
                          child: Icon(
                            isActive ? activeIcon : inactiveIcon,
                            color: Color.lerp(
                              Colors.grey.shade500,
                              Colors.blue.shade600,
                              value,
                            ),
                            size: _getIconSize(isVerySmallScreen, isSmallScreen, isShortScreen),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                
                // Label with professional typography
                Flexible(
                  flex: 2,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    style: TextStyle(
                      fontSize: _getFontSize(isVerySmallScreen, isSmallScreen, isShortScreen),
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive 
                        ? Colors.blue.shade600
                        : Colors.grey.shade500,
                      height: 1.0,
                      letterSpacing: isActive ? 0.1 : 0,
                    ),
                    child: Text(
                      _getLabel(label, isVerySmallScreen),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                
                // Active indicator dot
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  height: 2,
                  width: isActive ? 12 : 0,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getIconSize(bool isVerySmallScreen, bool isSmallScreen, bool isShortScreen) {
    if (isShortScreen) return 18;
    if (isVerySmallScreen) return 19;
    if (isSmallScreen) return 20;
    return 22;
  }

  double _getFontSize(bool isVerySmallScreen, bool isSmallScreen, bool isShortScreen) {
    if (isShortScreen) return 9;
    if (isVerySmallScreen) return 9;
    if (isSmallScreen) return 10;
    return 10;
  }

  String _getLabel(String label, bool isVerySmallScreen) {
    if (isVerySmallScreen) {
      // Shorten labels for very small screens
      switch (label) {
        case 'Gradebooks':
          return 'Grades';
        case 'Assessments':
          return 'Tests';
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
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.1);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }
}