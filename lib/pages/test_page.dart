import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';
import '../core/responsive/responsive.dart';
import '../widgets/title_box.dart';

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
  
  // Função auxiliar para criar containers responsivos consistentes para cada exemplo
  Widget _responsiveTestContainer({required Widget child}) {
    return ResponsiveContainer(
      mobileMaxWidth: 500,
      tabletMaxWidth: 600,
      desktopMaxWidth: 700,
      padding: const EdgeInsets.all(AppTheme.defaultSpacing),
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();
    _initTestWidgets();
  }
  
  void _initTestWidgets() {
    // Widget de boas-vindas
    _addTestWidget(
      'Introdução', 
      _responsiveTestContainer(
        child: Column(
          children: [
            const TitleBox(
              title: 'Widget Showcase',
              backgroundColor: AppTheme.primaryBlue,
            ),
            const SizedBox(height: AppTheme.defaultSpacing),
            const Text(
              'Esta página demonstra os widgets implementados no aplicativo.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppTheme.bodyTextSize),
            ),
            const SizedBox(height: AppTheme.largeSpacing),
            Text(
              'Use os botões abaixo para navegar entre os widgets.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTheme.smallTextSize,
                color: AppTheme.textGrayColor,
              ),
            ),
          ],
        ),
      ),
    );
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
            color: AppTheme.primaryBlue.withOpacity(0.1),
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
                                ? AppTheme.primaryBlue
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