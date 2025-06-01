import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/database/presentation/providers/database_providers.dart';
import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';
import 'package:timesheet_app_web/src/features/database/presentation/widgets/import_collection_dialog.dart';
import 'package:timesheet_app_web/src/features/database/presentation/widgets/collection_documents_dialog.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';

class DatabaseScreen extends ConsumerWidget {
  const DatabaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Database Management',
        subtitle: 'Manage your application data',
        showBackButton: true,
        showNavigationMenu: false,
      ),
      body: ResponsiveLayout(
        mobile: _MobileLayout(),
        desktop: _DesktopLayout(),
      ),
    );
  }
}

// Mobile Layout (360px+)
class _MobileLayout extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<_MobileLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);

    return Column(
      children: [
        // Bottom Navigation Style Tabs
        Container(
          color: context.colors.surface,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.spacingM,
              vertical: context.dimensions.spacingS,
            ),
            child: Row(
              children: [
                _buildMobileTab(
                  index: 0,
                  icon: Icons.dashboard,
                  label: 'Overview',
                ),
                SizedBox(width: context.dimensions.spacingS),
                _buildMobileTab(
                  index: 1,
                  icon: Icons.folder_outlined,
                  label: 'Collections',
                ),
                SizedBox(width: context.dimensions.spacingS),
                _buildMobileTab(
                  index: 2,
                  icon: Icons.backup_outlined,
                  label: 'Backup',
                ),
                SizedBox(width: context.dimensions.spacingS),
                _buildMobileTab(
                  index: 3,
                  icon: Icons.history,
                  label: 'Import',
                ),
              ],
            ),
          ),
        ),
        // Content
        Expanded(
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _MobileOverviewTab(),
              _MobileCollectionsTab(),
              _MobileBackupTab(),
              _MobileImportTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTab({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.dimensions.spacingM,
          vertical: context.dimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          border: Border.all(
            color: isSelected ? context.colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? context.colors.primary : context.colors.textSecondary,
              size: context.dimensions.iconSizeM,
            ),
            SizedBox(height: context.dimensions.spacingXS),
            Text(
              label,
              style: context.textStyles.caption.copyWith(
                color: isSelected ? context.colors.primary : context.colors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Desktop Layout
class _DesktopLayout extends ConsumerStatefulWidget {
  @override
  ConsumerState<_DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<_DesktopLayout> {
  String _selectedSection = 'overview';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Sidebar Navigation
        Container(
          width: 280,
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(
              right: BorderSide(
                color: context.colors.surface,
                width: 2,
              ),
            ),
          ),
          child: _DesktopSidebar(
            selectedSection: _selectedSection,
            onSectionChanged: (section) => setState(() => _selectedSection = section),
          ),
        ),
        // Content Area
        Expanded(
          child: _DesktopContent(selectedSection: _selectedSection),
        ),
      ],
    );
  }
}

// Desktop Sidebar
class _DesktopSidebar extends ConsumerWidget {
  final String selectedSection;
  final Function(String) onSectionChanged;

  const _DesktopSidebar({
    required this.selectedSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);

    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(context.dimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.dimensions.spacingM),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                    ),
                    child: Icon(
                      Icons.storage,
                      color: context.colors.primary,
                      size: context.dimensions.iconSizeL,
                    ),
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Database',
                          style: context.textStyles.title,
                        ),
                        databaseStatsAsync.when(
                          data: (stats) {
                            final totalDocs = stats.fold<int>(
                              0,
                              (sum, stat) => sum + stat.documentCount,
                            );
                            return Text(
                              '$totalDocs total documents',
                              style: context.textStyles.caption.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            );
                          },
                          loading: () => Text(
                            'Loading...',
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                          error: (_, __) => Text(
                            'Error loading stats',
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(height: 1),
        // Navigation Items
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            children: [
              _buildSidebarItem(
                context,
                id: 'overview',
                icon: Icons.dashboard_outlined,
                label: 'Overview',
                description: 'Database statistics and health',
              ),
              SizedBox(height: context.dimensions.spacingS),
              _buildSidebarItem(
                context,
                id: 'collections',
                icon: Icons.folder_outlined,
                label: 'Collections',
                description: 'Browse and manage collections',
              ),
              SizedBox(height: context.dimensions.spacingS),
              _buildSidebarItem(
                context,
                id: 'backup',
                icon: Icons.backup_outlined,
                label: 'Backup & Restore',
                description: 'Create backups and restore data',
              ),
              SizedBox(height: context.dimensions.spacingS),
              _buildSidebarItem(
                context,
                id: 'import',
                icon: Icons.upload_file_outlined,
                label: 'Import Data',
                description: 'Import from old app or CSV',
              ),
              SizedBox(height: context.dimensions.spacingL),
              Divider(),
              SizedBox(height: context.dimensions.spacingL),
              // Quick Actions
              Text(
                'Quick Actions',
                style: context.textStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: context.dimensions.spacingM),
              _buildQuickAction(
                context,
                icon: Icons.download,
                label: 'Export All',
                onTap: () => _handleExportAll(context, ref),
              ),
              SizedBox(height: context.dimensions.spacingS),
              _buildQuickAction(
                context,
                icon: Icons.cleaning_services,
                label: 'Clear Cache',
                onTap: () => _handleClearCache(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required String id,
    required IconData icon,
    required String label,
    required String description,
  }) {
    final isSelected = selectedSection == id;

    return InkWell(
      onTap: () => onSectionChanged(id),
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      child: Container(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          border: Border.all(
            color: isSelected ? context.colors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.colors.primary : context.colors.textSecondary,
              size: context.dimensions.iconSizeM,
            ),
            SizedBox(width: context.dimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.textStyles.subtitle.copyWith(
                      color: isSelected ? context.colors.primary : context.colors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacingXS),
                  Text(
                    description,
                    style: context.textStyles.caption.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacingM,
            vertical: context.dimensions.spacingS,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: context.colors.primary,
                size: context.dimensions.iconSizeS,
              ),
              SizedBox(width: context.dimensions.spacingM),
              Text(
                label,
                style: context.textStyles.body.copyWith(
                  color: context.colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleExportAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export All Data'),
        content: Text('This will export all collections to a single JSON file. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).backupDatabase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: Text('Export'),
          ),
        ],
      ),
    );
  }

  void _handleClearCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
          'This will clear the local Firestore cache. Data will be reloaded from the server.\n\n'
          'This may temporarily slow down the application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).clearCache();
            },
            child: Text(
              'Clear Cache',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// Desktop Content Area
class _DesktopContent extends ConsumerWidget {
  final String selectedSection;

  const _DesktopContent({required this.selectedSection});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (selectedSection) {
      case 'overview':
        return _DesktopOverviewTab();
      case 'collections':
        return _DesktopCollectionsTab();
      case 'backup':
        return _DesktopBackupTab();
      case 'import':
        return _DesktopImportTab();
      default:
        return _DesktopOverviewTab();
    }
  }
}

// Mobile Tabs
class _MobileOverviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);

    return databaseStatsAsync.when(
      data: (stats) => _buildOverview(context, ref, stats),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
    );
  }

  Widget _buildOverview(BuildContext context, WidgetRef ref, List<DatabaseStatsModel> stats) {
    final totalDocuments = stats.fold(0, (sum, stat) => sum + stat.documentCount);
    final totalSize = stats.fold(0, (sum, stat) => sum + stat.approximateSizeInBytes);

    return ListView(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      children: [
        // Summary Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            child: Column(
              children: [
                Icon(
                  Icons.storage,
                  size: 48,
                  color: context.colors.primary,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Text(
                  totalDocuments.toString(),
                  style: context.textStyles.headline,
                ),
                Text(
                  'Total Documents',
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: context.dimensions.spacingM),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.dimensions.spacingM,
                    vertical: context.dimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  ),
                  child: Text(
                    _formatBytes(totalSize),
                    style: context.textStyles.subtitle.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.dimensions.spacingM),
        // Collections Summary
        Text(
          'Collections',
          style: context.textStyles.title,
        ),
        SizedBox(height: context.dimensions.spacingM),
        ...stats.map((stat) => Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingS),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(context.dimensions.spacingS),
              decoration: BoxDecoration(
                color: context.categoryColorByName(stat.collectionName).withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
              ),
              child: Icon(
                _getIconForCollection(stat.collectionName),
                color: context.categoryColorByName(stat.collectionName),
                size: context.dimensions.iconSizeM,
              ),
            ),
            title: Text(
              _formatCollectionName(stat.collectionName),
              style: context.textStyles.subtitle,
            ),
            subtitle: Text(
              '${stat.documentCount} documents',
              style: context.textStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            trailing: Text(
              _formatBytes(stat.approximateSizeInBytes),
              style: context.textStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colors.error,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'Error loading data',
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingS),
            Text(
              error.toString(),
              style: context.textStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.dimensions.spacingL),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(databaseStatsProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileCollectionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);

    return databaseStatsAsync.when(
      data: (stats) => _buildCollections(context, ref, stats),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
    );
  }

  Widget _buildCollections(BuildContext context, WidgetRef ref, List<DatabaseStatsModel> stats) {
    return ListView.builder(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
          child: Column(
            children: [
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(context.dimensions.spacingS),
                  decoration: BoxDecoration(
                    color: context.categoryColorByName(stat.collectionName).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                  ),
                  child: Icon(
                    _getIconForCollection(stat.collectionName),
                    color: context.categoryColorByName(stat.collectionName),
                    size: context.dimensions.iconSizeM,
                  ),
                ),
                title: Text(
                  _formatCollectionName(stat.collectionName),
                  style: context.textStyles.subtitle,
                ),
                subtitle: Text(
                  '${stat.documentCount} documents • ${_formatBytes(stat.approximateSizeInBytes)}',
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: context.colors.textSecondary,
                ),
                onTap: () => _showCollectionActions(context, ref, stat),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCollectionActions(BuildContext context, WidgetRef ref, DatabaseStatsModel stat) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatCollectionName(stat.collectionName),
              style: context.textStyles.title,
            ),
            Text(
              '${stat.documentCount} documents',
              style: context.textStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimensions.spacingL),
            ListTile(
              leading: Icon(Icons.visibility_outlined),
              title: Text('View Documents'),
              onTap: () {
                Navigator.pop(context);
                _showCollectionDocuments(context, ref, stat.collectionName);
              },
            ),
            ListTile(
              leading: Icon(Icons.download_outlined),
              title: Text('Export Collection'),
              onTap: () {
                Navigator.pop(context);
                ref.read(databaseOperationsProvider.notifier).exportCollection(stat.collectionName);
              },
            ),
            ListTile(
              leading: Icon(Icons.upload_outlined),
              title: Text('Import CSV'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => ImportCollectionDialog(
                    collectionName: stat.collectionName,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colors.error,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'Error loading collections',
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingL),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(databaseStatsProvider),
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCollectionDocuments(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => CollectionDocumentsDialog(
        collectionName: collectionName,
      ),
    );
  }
}

class _MobileBackupTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationsState = ref.watch(databaseOperationsProvider);

    return ListView(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      children: [
        // Status
        if (operationsState is AsyncLoading)
          Card(
            color: context.colors.primary.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                    ),
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Text(
                    'Processing...',
                    style: context.textStyles.body.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (operationsState is AsyncData && operationsState.value != null)
          Card(
            color: context.colors.success.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: context.colors.success,
                    size: context.dimensions.iconSizeM,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      operationsState.value!,
                      style: context.textStyles.body.copyWith(
                        color: context.colors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (operationsState is AsyncError)
          Card(
            color: context.colors.error.withOpacity(0.1),
            child: Padding(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              child: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: context.colors.error,
                    size: context.dimensions.iconSizeM,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      operationsState.error.toString(),
                      style: context.textStyles.body.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        SizedBox(height: context.dimensions.spacingL),
        // Backup Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingL),
            child: Column(
              children: [
                Icon(
                  Icons.backup,
                  size: 48,
                  color: context.colors.primary,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Text(
                  'Backup Database',
                  style: context.textStyles.title,
                ),
                SizedBox(height: context.dimensions.spacingS),
                Text(
                  'Create a complete backup of all collections',
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.dimensions.spacingL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _handleBackup(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                      padding: EdgeInsets.symmetric(
                        vertical: context.dimensions.spacingM,
                      ),
                    ),
                    icon: Icon(Icons.download),
                    label: Text('Create Backup'),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: context.dimensions.spacingM),
        // Restore Card
        Card(
          child: Padding(
            padding: EdgeInsets.all(context.dimensions.spacingL),
            child: Column(
              children: [
                Icon(
                  Icons.restore,
                  size: 48,
                  color: Colors.orange,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Text(
                  'Restore Database',
                  style: context.textStyles.title,
                ),
                SizedBox(height: context.dimensions.spacingS),
                Text(
                  'Restore data from a backup file',
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.dimensions.spacingL),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showRestoreDialog(context, ref),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: context.dimensions.spacingM,
                      ),
                    ),
                    icon: Icon(Icons.upload_file),
                    label: Text('Restore from File'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleBackup(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Backup'),
        content: Text('This will create a backup file containing all your data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).backupDatabase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: Text('Create Backup'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select a backup file to restore from.'),
            SizedBox(height: context.dimensions.spacingM),
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                border: Border.all(
                  color: context.colors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: context.colors.warning,
                    size: context.dimensions.iconSizeM,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      'This will replace all existing data!',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _selectAndRestoreFile(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Select File'),
          ),
        ],
      ),
    );
  }

  void _selectAndRestoreFile(BuildContext context, WidgetRef ref) {
    final input = html.FileUploadInputElement()..accept = 'application/json';
    input.click();
    
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        
        reader.onLoadEnd.listen((e) {
          try {
            final content = reader.result as String;
            final data = json.decode(content);
            
            // Validate backup format
            if (data['version'] != null && data['collections'] != null) {
              _confirmRestore(context, ref, data);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid backup file format'),
                  backgroundColor: context.colors.error,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error reading backup file: $e'),
                backgroundColor: context.colors.error,
              ),
            );
          }
        });
        
        reader.readAsText(file);
      }
    });
  }

  void _confirmRestore(BuildContext context, WidgetRef ref, Map<String, dynamic> backupData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Restore'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backup details:'),
            SizedBox(height: context.dimensions.spacingS),
            Text(
              '• Date: ${backupData['backupDate'] ?? 'Unknown'}',
              style: context.textStyles.caption,
            ),
            Text(
              '• Collections: ${(backupData['collections'] as Map).length}',
              style: context.textStyles.caption,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'Are you sure you want to restore this backup?',
              style: context.textStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'This will replace ALL existing data!',
              style: context.textStyles.caption.copyWith(
                color: context.colors.error,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Restore functionality requires backend implementation'),
                  backgroundColor: context.colors.warning,
                ),
              );
              // TODO: Implement actual restore functionality
              // This would require backend support to safely restore data
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Restore'),
          ),
        ],
      ),
    );
  }
}

class _MobileImportTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      children: [
        // Import Options
        Card(
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.colors.primary.withOpacity(0.1),
                  child: Icon(Icons.table_chart, color: context.colors.primary),
                ),
                title: Text('Import CSV'),
                subtitle: Text('Import data from CSV files'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showImportCSVDialog(context, ref),
              ),
              Divider(height: 1),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Icon(Icons.file_download, color: Colors.blue),
                ),
                title: Text('Download Templates'),
                subtitle: Text('Get CSV templates for import'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showDownloadTemplatesDialog(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImportCSVDialog(BuildContext context, WidgetRef ref) {
    final collections = ['employees', 'company_cards', 'expenses', 'job_records'];
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Collection',
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingL),
            ...collections.map((collection) => ListTile(
              leading: Icon(_getIconForCollection(collection)),
              title: Text(_formatCollectionName(collection)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => ImportCollectionDialog(
                    collectionName: collection,
                  ),
                );
              },
            )),
          ],
        ),
      ),
    );
  }

  void _showDownloadTemplatesDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download Templates',
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingL),
            ...['employees', 'company_cards', 'expenses'].map((collection) => 
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text('${_formatCollectionName(collection)}.csv'),
                onTap: () {
                  Navigator.pop(context);
                  _downloadTemplate(context, collection);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadTemplate(BuildContext context, String collectionName) {
    String csvContent = '';
    
    switch (collectionName) {
      case 'employees':
        csvContent = 'first_name,last_name,is_active\nJohn,Doe,true\nJane,Smith,true';
        break;
      case 'company_cards':
        csvContent = 'holder_name,last_four_digits,is_active\nJohn Doe,1234,true';
        break;
      case 'expenses':
        csvContent = 'user_id,card_id,amount,date,description\n,,100.50,2024-01-01,Office Supplies';
        break;
    }
    
    final blob = html.Blob([csvContent]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..download = '${collectionName}_template.csv'
      ..click();
    html.Url.revokeObjectUrl(url);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template downloaded: ${collectionName}_template.csv'),
        backgroundColor: context.colors.success,
      ),
    );
  }
}

// Desktop Tabs (similar to mobile but with more features)
class _DesktopOverviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);
    final operationsState = ref.watch(databaseOperationsProvider);

    return databaseStatsAsync.when(
      data: (stats) => _buildContent(context, ref, stats, operationsState),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<DatabaseStatsModel> stats,
    AsyncValue<String?> operationsState,
  ) {
    final totalDocuments = stats.fold(0, (sum, stat) => sum + stat.documentCount);
    final totalSize = stats.fold(0, (sum, stat) => sum + stat.approximateSizeInBytes);

    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operation Status
            if (operationsState is AsyncLoading || 
                operationsState is AsyncData && operationsState.value != null ||
                operationsState is AsyncError)
              Container(
                margin: EdgeInsets.only(bottom: context.dimensions.spacingL),
                padding: EdgeInsets.all(context.dimensions.spacingM),
                decoration: BoxDecoration(
                  color: operationsState is AsyncLoading
                      ? context.colors.primary.withOpacity(0.1)
                      : operationsState is AsyncError
                          ? context.colors.error.withOpacity(0.1)
                          : context.colors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  border: Border.all(
                    color: operationsState is AsyncLoading
                        ? context.colors.primary.withOpacity(0.3)
                        : operationsState is AsyncError
                            ? context.colors.error.withOpacity(0.3)
                            : context.colors.success.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    if (operationsState is AsyncLoading)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                        ),
                      )
                    else
                      Icon(
                        operationsState is AsyncError ? Icons.error : Icons.check_circle,
                        color: operationsState is AsyncError 
                            ? context.colors.error 
                            : context.colors.success,
                        size: context.dimensions.iconSizeM,
                      ),
                    SizedBox(width: context.dimensions.spacingM),
                    Expanded(
                      child: Text(
                        operationsState is AsyncLoading
                            ? 'Processing...'
                            : operationsState is AsyncError
                                ? operationsState.error.toString()
                                : operationsState.value ?? '',
                        style: context.textStyles.body.copyWith(
                          color: operationsState is AsyncLoading
                              ? context.colors.primary
                              : operationsState is AsyncError
                                  ? context.colors.error
                                  : context.colors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Overview Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.folder_outlined,
                    label: 'Collections',
                    value: stats.length.toString(),
                    color: context.colors.primary,
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.description_outlined,
                    label: 'Documents',
                    value: totalDocuments.toString(),
                    color: context.colors.secondary,
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.storage,
                    label: 'Total Size',
                    value: _formatBytes(totalSize),
                    color: context.categoryColorByName('add'),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingL),
            // Collections Table
            Text(
              'Collections Overview',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Card(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Collection')),
                    DataColumn(label: Text('Documents')),
                    DataColumn(label: Text('Size')),
                    DataColumn(label: Text('Last Updated')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: stats.map((stat) => DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(context.dimensions.spacingS),
                              decoration: BoxDecoration(
                                color: context.categoryColorByName(stat.collectionName).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                              ),
                              child: Icon(
                                _getIconForCollection(stat.collectionName),
                                color: context.categoryColorByName(stat.collectionName),
                                size: context.dimensions.iconSizeS,
                              ),
                            ),
                            SizedBox(width: context.dimensions.spacingS),
                            Text(_formatCollectionName(stat.collectionName)),
                          ],
                        ),
                      ),
                      DataCell(Text(stat.documentCount.toString())),
                      DataCell(Text(_formatBytes(stat.approximateSizeInBytes))),
                      DataCell(Text(
                        stat.lastUpdated != null 
                            ? _formatDateTime(stat.lastUpdated!)
                            : 'N/A',
                      )),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.visibility_outlined, size: 18),
                              onPressed: () => _showCollectionDocuments(context, ref, stat.collectionName),
                              tooltip: 'View Documents',
                            ),
                            IconButton(
                              icon: Icon(Icons.download_outlined, size: 18),
                              onPressed: () => ref.read(databaseOperationsProvider.notifier)
                                  .exportCollection(stat.collectionName),
                              tooltip: 'Export',
                            ),
                            IconButton(
                              icon: Icon(Icons.upload_outlined, size: 18),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (context) => ImportCollectionDialog(
                                  collectionName: stat.collectionName,
                                ),
                              ),
                              tooltip: 'Import',
                            ),
                          ],
                        ),
                      ),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: context.dimensions.iconSizeL,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              value,
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingXS),
            Text(
              label,
              style: context.textStyles.caption.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(context.dimensions.spacingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: context.colors.error,
            ),
            SizedBox(height: context.dimensions.spacingL),
            Text(
              'Error loading database statistics',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              ),
              child: Text(
                error.toString(),
                style: context.textStyles.body.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
            SizedBox(height: context.dimensions.spacingL),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(databaseStatsProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
              icon: Icon(Icons.refresh),
              label: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCollectionDocuments(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => CollectionDocumentsDialog(
        collectionName: collectionName,
      ),
    );
  }
}

// Desktop Collections Tab
class _DesktopCollectionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);

    return databaseStatsAsync.when(
      data: (stats) => _buildContent(context, ref, stats),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<DatabaseStatsModel> stats) {
    return ResponsiveContainer(
      child: ListView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        children: [
          Text(
            'Collections Management',
            style: context.textStyles.headline,
          ),
          SizedBox(height: context.dimensions.spacingM),
          // Collections Grid
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.responsive<int>(
                xs: 1,
                sm: 2,
                md: 3,
                lg: 3,
                xl: 4,
              ),
              crossAxisSpacing: context.dimensions.spacingM,
              mainAxisSpacing: context.dimensions.spacingM,
              childAspectRatio: context.responsive<double>(
                xs: 2.0,
                sm: 1.3,
                md: 1.2,
                lg: 1.1,
                xl: 1.0,
              ),
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return _buildCollectionCard(context, ref, stat);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, WidgetRef ref, DatabaseStatsModel stat) {
    return Card(
      child: InkWell(
        onTap: () => _showCollectionActions(context, ref, stat),
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingM),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(context.dimensions.spacingS),
                  decoration: BoxDecoration(
                    color: context.categoryColorByName(stat.collectionName).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForCollection(stat.collectionName),
                    color: context.categoryColorByName(stat.collectionName),
                    size: context.responsive<double>(
                      xs: context.dimensions.iconSizeL,
                      sm: context.dimensions.iconSizeM,
                      md: context.dimensions.iconSizeL,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.dimensions.spacingS),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatCollectionName(stat.collectionName),
                      style: context.responsive<TextStyle>(
                        xs: context.textStyles.subtitle,
                        sm: context.textStyles.body,
                        md: context.textStyles.subtitle,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.dimensions.spacingXS),
                    Text(
                      '${stat.documentCount} docs',
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    Text(
                      _formatBytes(stat.approximateSizeInBytes),
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                        fontSize: context.responsive<double>(
                          xs: 11,
                          sm: 10,
                          md: 11,
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
    );
  }

  void _showCollectionActions(BuildContext context, WidgetRef ref, DatabaseStatsModel stat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_formatCollectionName(stat.collectionName)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility_outlined),
              title: Text('View Documents'),
              onTap: () {
                Navigator.pop(context);
                _showCollectionDocuments(context, ref, stat.collectionName);
              },
            ),
            ListTile(
              leading: Icon(Icons.download_outlined),
              title: Text('Export Collection'),
              onTap: () {
                Navigator.pop(context);
                ref.read(databaseOperationsProvider.notifier).exportCollection(stat.collectionName);
              },
            ),
            ListTile(
              leading: Icon(Icons.upload_outlined),
              title: Text('Import CSV'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => ImportCollectionDialog(
                    collectionName: stat.collectionName,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: context.colors.error,
          ),
          SizedBox(height: context.dimensions.spacingL),
          Text(
            'Error loading collections',
            style: context.textStyles.headline,
          ),
          SizedBox(height: context.dimensions.spacingL),
          ElevatedButton.icon(
            onPressed: () => ref.refresh(databaseStatsProvider),
            icon: Icon(Icons.refresh),
            label: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showCollectionDocuments(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => CollectionDocumentsDialog(
        collectionName: collectionName,
      ),
    );
  }
}

// Desktop Backup Tab
class _DesktopBackupTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationsState = ref.watch(databaseOperationsProvider);

    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backup & Restore',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingL),
            // Status
            if (operationsState is AsyncLoading || 
                operationsState is AsyncData && operationsState.value != null ||
                operationsState is AsyncError)
              Container(
                margin: EdgeInsets.only(bottom: context.dimensions.spacingL),
                padding: EdgeInsets.all(context.dimensions.spacingL),
                decoration: BoxDecoration(
                  color: operationsState is AsyncLoading
                      ? context.colors.primary.withOpacity(0.1)
                      : operationsState is AsyncError
                          ? context.colors.error.withOpacity(0.1)
                          : context.colors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  border: Border.all(
                    color: operationsState is AsyncLoading
                        ? context.colors.primary.withOpacity(0.3)
                        : operationsState is AsyncError
                            ? context.colors.error.withOpacity(0.3)
                            : context.colors.success.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    if (operationsState is AsyncLoading)
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
                        ),
                      )
                    else
                      Icon(
                        operationsState is AsyncError ? Icons.error : Icons.check_circle,
                        color: operationsState is AsyncError 
                            ? context.colors.error 
                            : context.colors.success,
                        size: context.dimensions.iconSizeL,
                      ),
                    SizedBox(width: context.dimensions.spacingM),
                    Expanded(
                      child: Text(
                        operationsState is AsyncLoading
                            ? 'Processing...'
                            : operationsState is AsyncError
                                ? operationsState.error.toString()
                                : operationsState.value ?? '',
                        style: context.textStyles.subtitle.copyWith(
                          color: operationsState is AsyncLoading
                              ? context.colors.primary
                              : operationsState is AsyncError
                                  ? context.colors.error
                                  : context.colors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            // Actions Row
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    ref,
                    icon: Icons.backup,
                    title: 'Create Backup',
                    description: 'Export all collections to a JSON file',
                    buttonLabel: 'Backup Now',
                    buttonColor: context.colors.primary,
                    onPressed: () => _handleBackup(context, ref),
                  ),
                ),
                SizedBox(width: context.dimensions.spacingL),
                Expanded(
                  child: _buildActionCard(
                    context,
                    ref,
                    icon: Icons.restore,
                    title: 'Restore Data',
                    description: 'Import data from a backup file',
                    buttonLabel: 'Select File',
                    buttonColor: Colors.orange,
                    onPressed: () => _handleRestore(context, ref),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingL),
            // Cache Management
            Card(
              child: Padding(
                padding: EdgeInsets.all(context.dimensions.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cleaning_services,
                          color: context.colors.secondary,
                          size: context.dimensions.iconSizeL,
                        ),
                        SizedBox(width: context.dimensions.spacingM),
                        Text(
                          'Cache Management',
                          style: context.textStyles.title,
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    Text(
                      'Clear the local Firestore cache to free up space and reload fresh data from the server.',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: context.dimensions.spacingL),
                    OutlinedButton.icon(
                      onPressed: () => _handleClearCache(context, ref),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.secondary,
                        side: BorderSide(color: context.colors.secondary),
                      ),
                      icon: Icon(Icons.clear),
                      label: Text('Clear Cache'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String description,
    required String buttonLabel,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          children: [
            Icon(
              icon,
              size: 64,
              color: buttonColor,
            ),
            SizedBox(height: context.dimensions.spacingL),
            Text(
              title,
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingS),
            Text(
              description,
              style: context.textStyles.body.copyWith(
                color: context.colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.dimensions.spacingL),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackup(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Backup'),
        content: Text('This will create a complete backup of all collections. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).backupDatabase();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: Text('Create Backup'),
          ),
        ],
      ),
    );
  }

  void _handleRestore(BuildContext context, WidgetRef ref) {
    _showRestoreDialog(context, ref);
  }
  
  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select a backup file to restore from.'),
            SizedBox(height: context.dimensions.spacingM),
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                border: Border.all(
                  color: context.colors.warning.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: context.colors.warning,
                    size: context.dimensions.iconSizeM,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      'This will replace all existing data!',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.warning,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _selectAndRestoreFile(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text('Select File'),
          ),
        ],
      ),
    );
  }

  void _selectAndRestoreFile(BuildContext context, WidgetRef ref) {
    final input = html.FileUploadInputElement()..accept = 'application/json';
    input.click();
    
    input.onChange.listen((e) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        
        reader.onLoadEnd.listen((e) {
          try {
            final content = reader.result as String;
            final data = json.decode(content);
            
            // Validate backup format
            if (data['version'] != null && data['collections'] != null) {
              _confirmRestore(context, ref, data);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Invalid backup file format'),
                  backgroundColor: context.colors.error,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error reading backup file: $e'),
                backgroundColor: context.colors.error,
              ),
            );
          }
        });
        
        reader.readAsText(file);
      }
    });
  }

  void _confirmRestore(BuildContext context, WidgetRef ref, Map<String, dynamic> backupData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Restore'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Backup details:'),
            SizedBox(height: context.dimensions.spacingS),
            Text(
              '• Date: ${backupData['backupDate'] ?? 'Unknown'}',
              style: context.textStyles.caption,
            ),
            Text(
              '• Collections: ${(backupData['collections'] as Map).length}',
              style: context.textStyles.caption,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'Are you sure you want to restore this backup?',
              style: context.textStyles.body.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'This will replace ALL existing data!',
              style: context.textStyles.caption.copyWith(
                color: context.colors.error,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Restore functionality requires backend implementation'),
                  backgroundColor: context.colors.warning,
                ),
              );
              // TODO: Implement actual restore functionality
              // This would require backend support to safely restore data
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Restore'),
          ),
        ],
      ),
    );
  }

  void _handleClearCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
          'This will clear the local Firestore cache. '
          'Data will be reloaded from the server on next access.\n\n'
          'This may temporarily slow down the application.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).clearCache();
            },
            child: Text(
              'Clear Cache',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// Desktop Import Tab
class _DesktopImportTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import Data',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingL),
            // Import Options Grid
            Row(
              children: [
                Expanded(
                  child: _buildImportOption(
                    context,
                    ref,
                    icon: Icons.table_chart,
                    title: 'Import CSV',
                    description: 'Import data from CSV files',
                    color: context.colors.primary,
                    onTap: () => _showImportCSVDialog(context, ref),
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: _buildImportOption(
                    context,
                    ref,
                    icon: Icons.file_download,
                    title: 'Download Templates',
                    description: 'Get CSV templates for easy import',
                    color: Colors.blue,
                    onTap: () => _showDownloadTemplatesDialog(context, ref),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImportOption(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingL),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: context.dimensions.iconSizeL,
                ),
              ),
              SizedBox(height: context.dimensions.spacingM),
              Text(
                title,
                style: context.textStyles.subtitle,
              ),
              SizedBox(height: context.dimensions.spacingS),
              Text(
                description,
                style: context.textStyles.caption.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImportCSVDialog(BuildContext context, WidgetRef ref) {
    final collections = ['employees', 'company_cards', 'expenses', 'job_records'];
    
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select Collection to Import'),
        children: collections.map((collection) => SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => ImportCollectionDialog(
                collectionName: collection,
              ),
            );
          },
          child: ListTile(
            leading: Icon(_getIconForCollection(collection)),
            title: Text(_formatCollectionName(collection)),
          ),
        )).toList(),
      ),
    );
  }

  void _showDownloadTemplatesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download CSV Templates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['employees', 'company_cards', 'expenses'].map((collection) => 
            ListTile(
              leading: Icon(Icons.file_download),
              title: Text('${_formatCollectionName(collection)}.csv'),
              onTap: () {
                Navigator.pop(context);
                _downloadTemplate(context, collection);
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _downloadTemplate(BuildContext context, String collectionName) {
    String csvContent = '';
    
    switch (collectionName) {
      case 'employees':
        csvContent = 'first_name,last_name,is_active\nJohn,Doe,true\nJane,Smith,true';
        break;
      case 'company_cards':
        csvContent = 'holder_name,last_four_digits,is_active\nJohn Doe,1234,true';
        break;
      case 'expenses':
        csvContent = 'user_id,card_id,amount,date,description\n,,100.50,2024-01-01,Office Supplies';
        break;
    }
    
    final blob = html.Blob([csvContent]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement()
      ..href = url
      ..download = '${collectionName}_template.csv'
      ..click();
    html.Url.revokeObjectUrl(url);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template downloaded: ${collectionName}_template.csv'),
        backgroundColor: context.colors.success,
      ),
    );
  }
}

// Utility Functions
IconData _getIconForCollection(String collectionName) {
  switch (collectionName) {
    case 'users':
      return Icons.person_outline;
    case 'employees':
      return Icons.badge_outlined;
    case 'company_cards':
      return Icons.credit_card_outlined;
    case 'expenses':
      return Icons.receipt_outlined;
    case 'job_records':
      return Icons.work_outline;
    default:
      return Icons.folder_outlined;
  }
}

String _formatCollectionName(String name) {
  return name.replaceAll('_', ' ').split(' ').map((word) => 
    word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)
  ).join(' ');
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}

String _formatDateTime(DateTime dateTime) {
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
      '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}';
}