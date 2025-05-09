import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_routes.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({super.key});

  @override
  ConsumerState<TestPage> createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {
  int _currentWidgetIndex = 0;
  final List<Widget> _testWidgets = [];
  final List<String> _widgetNames = [];

  void _addTestWidget(String name, Widget widget) {
    if (!_widgetNames.contains(name)) {
      _widgetNames.add(name);
      _testWidgets.add(widget);
    }
  }

  void _initTestWidgets() {
    _addTestWidget('Empty Container', Container(
      height: 100,
      color: Colors.grey.shade200,
      child: const Center(
        child: Text('Add widgets to test them here'),
      ),
    ));
    
    // Add more test widgets here
  }

  @override
  void initState() {
    super.initState();
    _initTestWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Test Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              context.go(AppRoutes.home);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _testWidgets.clear();
                _widgetNames.clear();
                _initTestWidgets();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _testWidgets.isNotEmpty
                      ? _testWidgets[_currentWidgetIndex]
                      : const Center(child: Text('No test widgets available')),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            color: AppTheme.primaryColor.withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  _widgetNames.isNotEmpty
                      ? 'Current: ${_widgetNames[_currentWidgetIndex]}'
                      : 'No widgets',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _widgetNames.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentWidgetIndex == index
                                ? AppTheme.primaryColor
                                : Colors.grey.shade300,
                            foregroundColor: _currentWidgetIndex == index
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _currentWidgetIndex = index;
                            });
                          },
                          child: Text(_widgetNames[index]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}