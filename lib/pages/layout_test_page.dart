// lib/pages/layout_test_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/base_layout.dart';
import '../core/responsive/responsive.dart';
import '../widgets/toast_message.dart';

class LayoutTestPage extends ConsumerWidget {
  const LayoutTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseLayout.standard(
      title: 'Layout Test Page',
      child: ResponsiveContainer(
        mobileMaxWidth: 500,
        tabletMaxWidth: 700,
        desktopMaxWidth: 900,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Layout Types Demonstration',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildLayoutButton(
                context, 
                'Standard Layout', 
                'Shows header and title box (like most pages)',
                LayoutType.standard,
              ),
              
              const SizedBox(height: 16),
              
              _buildLayoutButton(
                context, 
                'No Header Layout', 
                'Hides header, shows title box (like login)',
                LayoutType.noHeader,
              ),
              
              const SizedBox(height: 16),
              
              _buildLayoutButton(
                context, 
                'No Title Box Layout', 
                'Shows header, hides title box (like home)',
                LayoutType.noTitleBox,
              ),
              
              const SizedBox(height: 16),
              
              _buildLayoutButton(
                context, 
                'Minimal Layout', 
                'Hides both header and title box',
                LayoutType.minimal,
              ),
              
              const SizedBox(height: 32),
              
              const Text(
                'Other Layout Features',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureButton(
                context, 
                'With Back Button', 
                'Shows a back button instead of menu',
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureButton(
                context, 
                'With Action Buttons', 
                'Shows custom action buttons in header',
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureButton(
                context, 
                'With Floating Action Button', 
                'Shows a floating action button',
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureButton(
                context, 
                'With Custom Title Box Color', 
                'Shows title box with custom color',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLayoutButton(BuildContext context, String title, String description, LayoutType type) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _ExamplePage(
              layoutType: type,
              title: title,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String title, String description) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => _FeaturePage(
              featureType: title,
              description: description,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamplePage extends ConsumerWidget {
  final LayoutType layoutType;
  final String title;

  const _ExamplePage({
    Key? key,
    required this.layoutType,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseLayout.fromType(
      type: layoutType,
      title: title,
      child: ResponsiveContainer(
        mobileMaxWidth: 500,
        tabletMaxWidth: 700,
        desktopMaxWidth: 900,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'This is $title',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'This demonstrates how this layout type looks.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/debug'),
                child: const Text('Go Back to Debug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturePage extends ConsumerWidget {
  final String featureType;
  final String description;

  const _FeaturePage({
    Key? key,
    required this.featureType,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configuração específica para cada feature
    Widget? floatingActionButton;
    List<Widget>? actions;
    Color? titleBoxColor;
    VoidCallback? onBackPressed;

    if (featureType == 'With Floating Action Button') {
      floatingActionButton = FloatingActionButton(
        onPressed: () {
          ToastMessage.showInfo(
            context,
            'Floating action button pressed',
          );
        },
        child: const Icon(Icons.add),
      );
    }

    if (featureType == 'With Action Buttons') {
      actions = [
        IconButton(
          icon: const Icon(Icons.search, color: Color(0xFF0205D3)),
          onPressed: () {
            ToastMessage.showInfo(
              context,
              'Search button pressed',
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF0205D3)),
          onPressed: () {
            ToastMessage.showInfo(
              context,
              'Refresh button pressed',
            );
          },
        ),
      ];
    }

    if (featureType == 'With Custom Title Box Color') {
      titleBoxColor = Colors.purple;
    }

    if (featureType == 'With Back Button') {
      onBackPressed = () {
        ToastMessage.showInfo(
          context,
          'Custom back button pressed',
        );
        Navigator.of(context).pop();
      };
    }

    return BaseLayout(
      title: featureType,
      floatingActionButton: floatingActionButton,
      actions: actions,
      titleBoxColor: titleBoxColor,
      onBackPressed: onBackPressed,
      child: ResponsiveContainer(
        mobileMaxWidth: 500,
        tabletMaxWidth: 700,
        desktopMaxWidth: 900,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                featureType,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/debug'),
                child: const Text('Go Back to Debug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}