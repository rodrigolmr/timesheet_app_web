import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/widgets/app_loading_screen.dart';
import 'package:timesheet_app_web/src/features/home/presentation/screens/home_screen.dart';
import 'package:timesheet_app_web/src/features/home/presentation/providers/home_providers.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

class HomeScreenWrapper extends ConsumerStatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  ConsumerState<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends ConsumerState<HomeScreenWrapper> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _preloadData();
  }

  Future<void> _preloadData() async {
    try {
      // Preload user profile
      await ref.read(currentUserProfileProvider.future);
      
      // Preload navigation items
      await ref.read(filteredHomeNavigationItemsProvider.future);
      
      // Add a small delay to ensure smooth transition
      await Future.delayed(const Duration(milliseconds: 300));
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Even if there's an error, show the home screen
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const AppLoadingScreen();
    }
    
    return const HomeScreen();
  }
}