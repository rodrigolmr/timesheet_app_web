import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/core/widgets/logo/logo.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(authStateProvider.notifier).signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      // Navigation is handled automatically by the router
      // The router will redirect to home when auth state changes
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _formatErrorMessage(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  String _formatErrorMessage(String error) {
    // Format Firebase error messages to be more user-friendly
    if (error.contains('user-not-found')) {
      return 'User not found. Please check your email.';
    }
    if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    }
    if (error.contains('invalid-email')) {
      return 'Invalid email address.';
    }
    if (error.contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    }
    return 'An error occurred. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo - fora do ResponsiveContainer
                _buildLogo(context),
                
                SizedBox(height: context.responsive<double>(
                  xs: context.dimensions.spacingXL,
                  md: context.dimensions.spacingXL * 1.5,
                )),
                
                // Form container com largura limitada
                ResponsiveContainer(
                  maxWidthMd: 400,
                  maxWidthLg: 400,
                  maxWidthXl: 400,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Title
                        _buildTitle(context),
                        
                        SizedBox(height: context.responsive<double>(
                          xs: context.dimensions.spacingL,
                          md: context.dimensions.spacingXL,
                        )),
                        
                        // Form fields
                        _buildFormFields(context),
                        
                        // Error message
                        if (_errorMessage != null) _buildErrorMessage(context),
                        
                        SizedBox(height: context.responsive<double>(
                          xs: context.dimensions.spacingL,
                          md: context.dimensions.spacingXL,
                        )),
                        
                        // Actions
                        _buildActions(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return AppLogo(
      displayMode: LogoDisplayMode.vertical,
      small: false,
      centered: true,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Column(
      children: [
        Text(
          'Sign In',
          style: context.responsive<TextStyle>(
            xs: context.textStyles.title,
            md: context.textStyles.headline,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.dimensions.spacingS),
        Text(
          'Access your timesheet account',
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        // Email field
        AppTextField.email(
          controller: _emailController,
          label: 'Email',
          hintText: 'Enter your email address',
          onSubmitted: (_) => _handleLogin(),
        ),
        
        SizedBox(height: context.dimensions.spacingM),
        
        // Password field
        AppPasswordField(
          controller: _passwordController,
          label: 'Password',
          hintText: 'Enter your password',
          onSubmitted: (_) => _handleLogin(),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.dimensions.spacingM),
      child: Container(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        decoration: BoxDecoration(
          color: context.colors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          border: Border.all(
            color: context.colors.error.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: context.colors.error,
              size: context.iconSizeMedium,
            ),
            SizedBox(width: context.dimensions.spacingS),
            Expanded(
              child: Text(
                _errorMessage!,
                style: context.textStyles.body.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        // Sign in button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              ),
            ),
            icon: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(context.colors.onPrimary),
                    ),
                  )
                : Icon(Icons.login),
            label: Text(_isLoading ? 'Signing in...' : 'Sign In'),
          ),
        ),
      ],
    );
  }


  // Helpers
  void _clearError() {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }
}