// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_screen.dart';

// Email: demo@example.com
// Password: demo123

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Replace this with your actual API URL
  static const String API_BASE_URL = 'https://zawadi-project.onrender.com';

  // Demo credentials - change these to whatever you want
  static const String DEMO_EMAIL = 'demo@example.com';
  static const String DEMO_PASSWORD = 'demo123';

  // Administrator contact details
  static const String ADMIN_PHONE = '+254794203261';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isDemoCredentials() {
    return _emailController.text.trim().toLowerCase() == DEMO_EMAIL.toLowerCase() &&
           _passwordController.text == DEMO_PASSWORD;
  }

  Future<void> _handleDemoLogin() async {
    // Store demo data in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', 'demo_token_12345');
    await prefs.setString('role', 'parent'); // or whatever role you want for demo

    // Show success message
    _showSuccessSnackBar('Demo login successful!');

    // Navigate to home screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: ADMIN_PHONE);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorDialog('Could not open phone app. Please call $ADMIN_PHONE manually.');
      }
    } catch (e) {
      _showErrorDialog('Could not open phone app. Please call $ADMIN_PHONE manually.');
    }
  }

  Future<void> _openWhatsApp() async {
    final String message = Uri.encodeComponent(
      'Hello, I need help with password reset.\n\n'
      'School Name: [Please enter your school name]\n'
      'Email: [Please enter your email address]\n\n'
      'Please help me reset my password.'
    );
    
    final Uri whatsappUri = Uri.parse('https://wa.me/$ADMIN_PHONE?text=$message');
    
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        _showErrorDialog('Could not open WhatsApp. Please install WhatsApp or contact $ADMIN_PHONE directly.');
      }
    } catch (e) {
      _showErrorDialog('Could not open WhatsApp. Please install WhatsApp or contact $ADMIN_PHONE directly.');
    }
  }

  void _showContactAdministratorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.contact_support, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text('Contact Administrator'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Need help with your password? Contact the administrator:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              
              // Important note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade600, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          'Before contacting:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '• Include your school name\n'
                      '• Include your email address\n'
                      '• I will respond within a few minutes',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              Text(
                'Administrator: $ADMIN_PHONE',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _makePhoneCall();
              },
              icon: const Icon(Icons.phone, color: Colors.green),
              label: const Text(
                'Call',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _openWhatsApp();
              },
              icon: Icon(Icons.message, color: Colors.green.shade600),
              label: Text(
                'WhatsApp',
                style: TextStyle(color: Colors.green.shade600),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check if demo credentials are being used
        if (_isDemoCredentials()) {
          // Small delay to show loading animation
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            await _handleDemoLogin();
          }
          return;
        }

        // Normal API call for non-demo credentials
        final response = await http.post(
          Uri.parse('$API_BASE_URL/api/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            
            // Store token and role in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('token', responseData['token']);
            await prefs.setString('role', responseData['role']);

            // Show success message
            _showSuccessSnackBar('Logged in successfully!');

            // Navigate to home screen and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else {
            // Handle error response
            String errorMessage = 'Failed to sign in. Please check your credentials.';
            
            try {
              final Map<String, dynamic> errorData = jsonDecode(response.body);
              if (errorData.containsKey('message')) {
                errorMessage = errorData['message'];
              }
            } catch (e) {
              // Use default error message if parsing fails
            }
            
            _showErrorDialog(errorMessage);
          }
        }
      } catch (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          
          String errorMessage = 'Network error. Please check your connection and try again.';
          
          // Handle specific error types
          if (error.toString().contains('SocketException')) {
            errorMessage = 'No internet connection. Please check your network.';
          } else if (error.toString().contains('TimeoutException')) {
            errorMessage = 'Connection timeout. Please try again.';
          }
          
          _showErrorDialog(errorMessage);
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
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

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo and title
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.school,
                  size: 60,
                  color: Colors.blue.shade600,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to access your child\'s progress',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // Demo info card (optional - remove if you don't want to show this)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange.shade600,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Demo: Use $DEMO_EMAIL / $DEMO_PASSWORD',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Login form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword 
                                ? Icons.visibility_outlined 
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              TextButton(
                onPressed: _showContactAdministratorDialog,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}