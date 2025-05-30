import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/widgets/app_loading_screen.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';

/// Wrapper widget that shows loading screen during authentication state changes
class AuthStateWrapper extends ConsumerWidget {
  final Widget child;
  
  const AuthStateWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    // Show loading screen while auth state is loading
    if (authState.isLoading) {
      return const AppLoadingScreen();
    }
    
    // Otherwise show the child widget
    return child;
  }
}