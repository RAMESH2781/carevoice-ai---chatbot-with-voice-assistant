import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/database_service.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showBiometricPrompt = false;
  String _biometricType = 'fingerprint';
  String? _errorMessage;

  // Mock credentials for testing (will be replaced by database)
  final Map<String, String> _mockCredentials = {
    'admin@carevoice.ai': 'admin123',
    'doctor@carevoice.ai': 'doctor123',
    'user@carevoice.ai': 'user123',
  };

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Simulate biometric availability check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _biometricType = 'fingerprint'; // Default to fingerprint
    });
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    try {
      // First try database authentication
      final databaseService = DatabaseService();
      final user = await databaseService.getUserByEmail(email);
      
      if (user != null && user['password'] == password) {
        // Successful database login
        HapticFeedback.lightImpact();
        
        // Navigate directly to chatbot screen
        _navigateToChatbot(user);
        return;
      }
      
      // Fallback to mock credentials for testing
      if (_mockCredentials.containsKey(email) &&
          _mockCredentials[email] == password) {
        // Create user in database if using mock credentials
        final userId = await databaseService.createUser(
          email: email,
          password: password,
          name: email.split('@')[0],
        );
        
        if (userId > 0) {
          final newUser = await databaseService.getUserByEmail(email);
          if (newUser != null) {
            HapticFeedback.lightImpact();
            _navigateToChatbot(newUser);
            return;
          }
        }
      }
      
      // Invalid credentials
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid email or password. Please try again.';
      });

      HapticFeedback.heavyImpact();
      _showErrorSnackBar(_errorMessage!);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Login error. Please try again.';
      });
      _showErrorSnackBar(_errorMessage!);
    }
  }

  Future<void> _handleSocialLogin(String provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate social login
      await Future.delayed(const Duration(seconds: 1));

      HapticFeedback.lightImpact();
      _showSuccessSnackBar('$provider login successful!');

      // Navigate to main interface after social login
      _navigateToMainInterface();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('$provider login failed. Please try again.');
    }
  }

  Future<void> _handleBiometricSetup(bool enable) async {
    if (enable) {
      // Simulate biometric setup
      await Future.delayed(const Duration(milliseconds: 500));
      _showSuccessSnackBar(
          '${_biometricType == 'face' ? 'Face ID' : 'Fingerprint'} enabled successfully!');
    }

    setState(() {
      _showBiometricPrompt = false;
    });

    // Navigate to main interface
    _navigateToMainInterface();
  }

  void _navigateToMainInterface() {
    Navigator.pushReplacementNamed(context, '/main-voice-interface');
  }

  void _navigateToChatbot(Map<String, dynamic> user) {
    Navigator.pushReplacementNamed(
      context, 
      '/chatbot',
      arguments: user,
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.darkTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.getSuccessColor(false),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.darkTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // Main Content
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 8.h),

                        // App Logo
                        Center(
                          child: Container(
                            width: 25.w,
                            height: 25.w,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.darkTheme.colorScheme.primary,
                                  AppTheme.darkTheme.colorScheme.secondary,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.darkTheme.colorScheme.primary
                                      .withValues(alpha: 0.3),
                                  blurRadius: 20.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'mic',
                                color: Colors.white,
                                size: 12.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),

                        // Welcome Text
                        Text(
                          'Welcome to CareVoice AI',
                          style: AppTheme.darkTheme.textTheme.headlineMedium
                              ?.copyWith(
                            color: AppTheme.darkTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),

                        Text(
                          'Your AI-powered healthcare companion',
                          style:
                              AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                            color:
                                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 6.h),

                        // Login Form
                        LoginFormWidget(
                          onLogin: _handleLogin,
                          isLoading: _isLoading,
                        ),
                        SizedBox(height: 4.h),

                        // Social Login Options
                        SocialLoginWidget(
                          isLoading: _isLoading,
                          onGoogleLogin: () => _handleSocialLogin('Google'),
                          onAppleLogin: () => _handleSocialLogin('Apple'),
                        ),

                        const Spacer(),

                        // Sign Up Link
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New user? ',
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .darkTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: _isLoading ? null : _navigateToSignUp,
                                child: Text(
                                  'Sign Up',
                                  style: AppTheme.darkTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color:
                                        AppTheme.darkTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        AppTheme.darkTheme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Biometric Prompt Overlay
              if (_showBiometricPrompt)
                Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: Center(
                    child: BiometricPromptWidget(
                      isVisible: _showBiometricPrompt,
                      biometricType: _biometricType,
                      onEnableBiometric: () => _handleBiometricSetup(true),
                      onSkipBiometric: () => _handleBiometricSetup(false),
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
