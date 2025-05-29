import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_container.dart' as responsive;
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/database/presentation/providers/database_providers.dart';
import 'package:timesheet_app_web/src/features/database/presentation/widgets/import_collection_dialog.dart';
import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';
import 'package:universal_html/html.dart' as html;

class DatabaseScreen extends ConsumerStatefulWidget {
  const DatabaseScreen({super.key});

  @override
  ConsumerState<DatabaseScreen> createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends ConsumerState<DatabaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Database Management',
        subtitle: 'Manage your application data',
        showBackButton: true,
        showNavigationMenu: false,
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              border: Border(
                bottom: BorderSide(
                  color: context.colors.surface,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: context.colors.primary,
              unselectedLabelColor: context.colors.textSecondary,
              indicatorColor: context.colors.primary,
              indicatorWeight: 3,
              isScrollable: context.isMobile,
              labelStyle: TextStyle(
                fontSize: context.responsive<double>(
                  xs: 11,
                  sm: 12,
                  md: 13,
                  lg: 14,
                ),
              ),
              tabs: context.isMobile
                  ? [
                      Tab(icon: Icon(Icons.folder_outlined, size: context.iconSizeSmall)),
                      Tab(icon: Icon(Icons.backup_outlined, size: context.iconSizeSmall)),
                      Tab(icon: Icon(Icons.sync_alt_outlined, size: context.iconSizeSmall)),
                    ]
                  : [
                      Tab(
                        text: 'Collections',
                        icon: Icon(Icons.folder_outlined),
                      ),
                      Tab(
                        text: 'Backup & Restore',
                        icon: Icon(Icons.backup_outlined),
                      ),
                      Tab(
                        text: 'Import & Export',
                        icon: Icon(Icons.sync_alt_outlined),
                      ),
                    ],
            ),
          ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _CollectionsTab(),
                _BackupRestoreTab(),
                _ImportExportTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Collections Tab
class _CollectionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);

    return databaseStatsAsync.when(
      data: (stats) => _buildContent(context, ref, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildError(context, ref, error),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<DatabaseStatsModel> stats) {
    return responsive.ResponsiveContainer(
      child: ListView(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingS,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingM,
          lg: context.dimensions.spacingL,
        )),
        children: [
          // Overview Card
          _buildOverviewCard(context, stats),
          SizedBox(height: context.dimensions.spacingL),
          
          // Collections Grid
          Text(
            'Collections',
            style: context.textStyles.headline,
          ),
          SizedBox(height: context.dimensions.spacingM),
          
          ...stats.map((stat) => Padding(
            padding: EdgeInsets.only(bottom: context.dimensions.spacingM),
            child: _buildCollectionCard(context, ref, stat),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, List<DatabaseStatsModel> stats) {
    final totalDocuments = stats.fold(0, (sum, stat) => sum + stat.documentCount);
    final totalSize = stats.fold(0, (sum, stat) => sum + stat.approximateSizeInBytes);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingM,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
          lg: context.dimensions.spacingL,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            context.isMobile
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(context.dimensions.spacingS),
                            decoration: BoxDecoration(
                              color: context.colors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                            ),
                            child: Icon(
                              Icons.storage,
                              size: context.iconSizeMedium,
                              color: context.colors.primary,
                            ),
                          ),
                          SizedBox(width: context.dimensions.spacingS),
                          Text(
                            'Database Overview',
                            style: context.responsive<TextStyle>(
                              xs: context.textStyles.subtitle,
                              sm: context.textStyles.title,
                              md: context.textStyles.title,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.dimensions.spacingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                totalDocuments.toString(),
                                style: context.textStyles.headline,
                              ),
                              Text(
                                'Documents',
                                style: context.textStyles.caption.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: context.colors.surface,
                          ),
                          Column(
                            children: [
                              Text(
                                _formatBytes(totalSize),
                                style: context.textStyles.headline,
                              ),
                              Text(
                                'Total Size',
                                style: context.textStyles.caption.copyWith(
                                  color: context.colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(context.dimensions.spacingM),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                        ),
                        child: Icon(
                          Icons.storage,
                          size: context.dimensions.iconSizeL,
                          color: context.colors.primary,
                        ),
                      ),
                      SizedBox(width: context.dimensions.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Database Overview',
                              style: context.textStyles.title,
                            ),
                            SizedBox(height: context.dimensions.spacingXS),
                            Text(
                              '$totalDocuments total documents',
                              style: context.textStyles.caption.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatBytes(totalSize),
                            style: context.textStyles.headline,
                          ),
                          Text(
                            'Total Size',
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, WidgetRef ref, DatabaseStatsModel stat) {
    return Card(
      elevation: 2,
      child: ExpansionTile(
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
          style: context.textStyles.title,
        ),
        subtitle: Text(
          '${stat.documentCount} documents • ${_formatBytes(stat.approximateSizeInBytes)}',
          style: context.textStyles.caption.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.surface.withOpacity(0.5),
              border: Border(
                top: BorderSide(color: context.colors.surface),
              ),
            ),
            child: Column(
              children: [
                // Action Buttons
                Wrap(
                  spacing: context.responsive<double>(
                    xs: context.dimensions.spacingXS,
                    sm: context.dimensions.spacingS,
                    md: context.dimensions.spacingS,
                  ),
                  runSpacing: context.responsive<double>(
                    xs: context.dimensions.spacingXS,
                    sm: context.dimensions.spacingS,
                    md: context.dimensions.spacingS,
                  ),
                  alignment: context.isMobile ? WrapAlignment.center : WrapAlignment.start,
                  children: [
                    _ActionButton(
                      icon: Icons.visibility_outlined,
                      label: 'View Documents',
                      onPressed: () => _showCollectionDocuments(context, ref, stat.collectionName),
                    ),
                    _ActionButton(
                      icon: Icons.add_circle_outline,
                      label: 'Add Document',
                      onPressed: () => _showAddDocumentDialog(context, ref, stat.collectionName),
                    ),
                    _ActionButton(
                      icon: Icons.download_outlined,
                      label: 'Export',
                      onPressed: () => _handleExportCollection(context, ref, stat.collectionName),
                    ),
                    _ActionButton(
                      icon: Icons.upload_outlined,
                      label: 'Import CSV',
                      onPressed: () => _handleImportCollection(context, ref, stat.collectionName),
                    ),
                    if (_canGenerateTestData(stat.collectionName))
                      _ActionButton(
                        icon: Icons.science_outlined,
                        label: 'Test Data',
                        onPressed: () => _showGenerateTestDataDialog(context, ref, stat.collectionName),
                      ),
                  ],
                ),
                
                // Collection Stats
                if (stat.lastUpdated != null) ...[
                  SizedBox(height: context.dimensions.spacingM),
                  Container(
                    padding: EdgeInsets.all(context.dimensions.spacingS),
                    decoration: BoxDecoration(
                      color: context.colors.background,
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update,
                          size: context.dimensions.iconSizeS,
                          color: context.colors.textSecondary,
                        ),
                        SizedBox(width: context.dimensions.spacingXS),
                        Text(
                          'Last updated: ${_formatDateTime(stat.lastUpdated!)}',
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
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
            size: 64,
            color: context.colors.error,
          ),
          SizedBox(height: context.dimensions.spacingM),
          Text(
            'Error loading database stats',
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
    );
  }

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

  bool _canGenerateTestData(String collectionName) {
    return ['users', 'employees', 'company_cards', 'expenses', 'job_records'].contains(collectionName);
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Action handlers
  void _showCollectionDocuments(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => _CollectionDocumentsDialog(
        collectionName: collectionName,
      ),
    );
  }

  void _showAddDocumentDialog(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => _DocumentEditorDialog(
        collectionName: collectionName,
      ),
    );
  }

  void _showGenerateTestDataDialog(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => _GenerateTestDataDialog(
        collectionName: collectionName,
      ),
    );
  }

  void _handleExportCollection(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Collection'),
        content: Text('Export all documents from "$collectionName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).exportCollection(collectionName);
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

  void _handleImportCollection(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => ImportCollectionDialog(
        collectionName: collectionName,
      ),
    );
  }
}

// Backup & Restore Tab
class _BackupRestoreTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operationsState = ref.watch(databaseOperationsProvider);

    return responsive.ResponsiveContainer(
      child: ListView(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingS,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingM,
          lg: context.dimensions.spacingL,
        )),
        children: [
          // Status Messages
          if (operationsState is AsyncLoading)
            _buildStatusMessage(
              context,
              icon: Icons.sync,
              message: 'Processing...',
              color: context.colors.primary,
              isLoading: true,
            ),
          if (operationsState is AsyncData && operationsState.value != null)
            _buildStatusMessage(
              context,
              icon: Icons.check_circle,
              message: operationsState.value!,
              color: context.colors.success,
            ),
          if (operationsState is AsyncError)
            _buildStatusMessage(
              context,
              icon: Icons.error,
              message: operationsState.error.toString(),
              color: context.colors.error,
            ),

          // Backup Section
          _buildSectionCard(
            context,
            title: 'Backup Database',
            subtitle: 'Create a complete backup of all collections',
            icon: Icons.backup,
            color: context.colors.primary,
            actions: [
              ElevatedButton.icon(
                onPressed: () => _handleBackup(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                ),
                icon: Icon(Icons.download),
                label: Text('Create Backup'),
              ),
            ],
          ),
          
          SizedBox(height: context.dimensions.spacingM),

          // Restore Section
          _buildSectionCard(
            context,
            title: 'Restore Database',
            subtitle: 'Restore data from a backup file',
            icon: Icons.restore,
            color: Colors.orange,
            actions: [
              ElevatedButton.icon(
                onPressed: () => _showRestoreOptions(context, ref),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.upload_file),
                label: Text('Restore from File'),
              ),
            ],
          ),

          SizedBox(height: context.dimensions.spacingM),

          // Cache Management
          _buildSectionCard(
            context,
            title: 'Cache Management',
            subtitle: 'Clear local Firestore cache',
            icon: Icons.cleaning_services,
            color: context.colors.secondary,
            actions: [
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
        ],
      ),
    );
  }

  Widget _buildStatusMessage(
    BuildContext context, {
    required IconData icon,
    required String message,
    required Color color,
    bool isLoading = false,
  }) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          if (isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            )
          else
            Icon(icon, color: color, size: context.dimensions.iconSizeM),
          SizedBox(width: context.dimensions.spacingM),
          Expanded(
            child: Text(
              message,
              style: context.textStyles.body.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Widget> actions,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingM,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
          lg: context.dimensions.spacingL,
        )),
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
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textStyles.title,
                      ),
                      SizedBox(height: context.dimensions.spacingXS),
                      Text(
                        subtitle,
                        style: context.textStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingM),
            Wrap(
              spacing: context.dimensions.spacingM,
              children: actions,
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

  void _showRestoreOptions(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restore Database'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose what to restore:'),
            SizedBox(height: context.dimensions.spacingM),
            ListTile(
              leading: Icon(Icons.folder_special),
              title: Text('Single Collection'),
              subtitle: Text('Restore a specific collection'),
              onTap: () {
                Navigator.of(context).pop();
                _showCollectionSelection(context, ref);
              },
            ),
            ListTile(
              leading: Icon(Icons.storage),
              title: Text('Full Database'),
              subtitle: Text('Restore all collections'),
              onTap: () {
                Navigator.of(context).pop();
                _handleFullRestore(context, ref);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCollectionSelection(BuildContext context, WidgetRef ref) {
    final collections = ['users', 'employees', 'company_cards', 'expenses', 'job_records'];
    
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select Collection to Restore'),
        children: [
          ...collections.map((collection) => SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              _handleImportCollection(context, ref, collection);
            },
            child: ListTile(
              leading: Icon(Icons.folder),
              title: Text(collection),
              contentPadding: EdgeInsets.zero,
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _handleFullRestore(BuildContext context, WidgetRef ref) {
    // Implement full database restore
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Full database restore is not yet implemented'),
        backgroundColor: context.colors.warning,
      ),
    );
  }

  void _handleImportCollection(BuildContext context, WidgetRef ref, String collectionName) {
    showDialog(
      context: context,
      builder: (context) => ImportCollectionDialog(
        collectionName: collectionName,
      ),
    );
  }

  void _handleClearCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cache'),
        content: Text(
          'This will clear the local Firestore cache. Data will be reloaded from the server on next access.\n\n'
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

// Import & Export Tab
class _ImportExportTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return responsive.ResponsiveContainer(
      child: ListView(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingS,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingM,
          lg: context.dimensions.spacingL,
        )),
        children: [
          // Import from Old App - MAINTAINED
          _buildImportOldAppCard(context, ref),
          
          SizedBox(height: context.dimensions.spacingM),

          // Quick Actions
          _buildQuickActionsCard(context, ref),
          
          SizedBox(height: context.dimensions.spacingM),

          // Import/Export Help
          _buildHelpCard(context),
        ],
      ),
    );
  }

  Widget _buildImportOldAppCard(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 3,
      color: context.categoryColorByName('add').withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingM,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
          lg: context.dimensions.spacingL,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  decoration: BoxDecoration(
                    color: context.categoryColorByName('add'),
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                  ),
                  child: Icon(
                    Icons.history,
                    color: Colors.white,
                    size: context.dimensions.iconSizeL,
                  ),
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Import from Old App',
                        style: context.textStyles.headline,
                      ),
                      SizedBox(height: context.dimensions.spacingXS),
                      Text(
                        'Transfer data from the previous version',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingL),
            ElevatedButton.icon(
              onPressed: () => context.goNamed('dataImport'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.categoryColorByName('add'),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              icon: Icon(Icons.upload_file),
              label: Text('Open Import Tool'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingM,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
          lg: context.dimensions.spacingL,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingM),
            
            // Export All Collections
            ListTile(
              leading: CircleAvatar(
                backgroundColor: context.colors.primary.withOpacity(0.1),
                child: Icon(Icons.download, color: context.colors.primary),
              ),
              title: Text('Export All Collections'),
              subtitle: Text('Download all data as JSON'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _handleExportAll(context, ref),
            ),
            
            Divider(),
            
            // Import CSV
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.1),
                child: Icon(Icons.table_chart, color: Colors.green),
              ),
              title: Text('Import CSV'),
              subtitle: Text('Import data from CSV files'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showImportCSVDialog(context, ref),
            ),
            
            Divider(),
            
            // Export Templates
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
    );
  }

  Widget _buildHelpCard(BuildContext context) {
    return Card(
      elevation: 1,
      color: context.colors.surface,
      child: Padding(
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingM,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
          lg: context.dimensions.spacingL,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.help_outline,
                  color: context.colors.primary,
                  size: context.dimensions.iconSizeM,
                ),
                SizedBox(width: context.dimensions.spacingS),
                Text(
                  'Import/Export Help',
                  style: context.textStyles.title,
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingM),
            _buildHelpItem(
              context,
              title: 'CSV Format',
              description: 'First row must contain column headers matching field names',
            ),
            SizedBox(height: context.dimensions.spacingS),
            _buildHelpItem(
              context,
              title: 'Date Format',
              description: 'Use ISO format: YYYY-MM-DD or YYYY-MM-DD HH:MM:SS',
            ),
            SizedBox(height: context.dimensions.spacingS),
            _buildHelpItem(
              context,
              title: 'Boolean Values',
              description: 'Use "true" or "false" (lowercase)',
            ),
            SizedBox(height: context.dimensions.spacingS),
            _buildHelpItem(
              context,
              title: 'Arrays',
              description: 'Use JSON format: ["value1", "value2"]',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpItem(BuildContext context, {
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 6,
          height: 6,
          margin: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: context.colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.dimensions.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textStyles.subtitle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    );
  }

  void _handleExportAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export All Collections'),
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

  void _showImportCSVDialog(BuildContext context, WidgetRef ref) {
    final collections = ['employees', 'company_cards', 'expenses', 'job_records'];
    
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select Collection'),
        children: [
          ...collections.map((collection) => SimpleDialogOption(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => ImportCollectionDialog(
                  collectionName: collection,
                ),
              );
            },
            child: ListTile(
              leading: Icon(Icons.folder),
              title: Text(collection),
              contentPadding: EdgeInsets.zero,
            ),
          )).toList(),
        ],
      ),
    );
  }

  void _showDownloadTemplatesDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Templates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select a template to download:'),
            SizedBox(height: context.dimensions.spacingM),
            ...['employees', 'company_cards', 'expenses'].map((collection) => 
              ListTile(
                leading: Icon(Icons.file_download),
                title: Text('$collection.csv'),
                onTap: () {
                  Navigator.of(context).pop();
                  _downloadTemplate(context, collection);
                },
              ),
            ).toList(),
          ],
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
    // Create CSV template
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
    
    // Download file
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

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surface,
      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive<double>(
              xs: context.dimensions.spacingS,
              sm: context.dimensions.spacingM,
              md: context.dimensions.spacingM,
            ),
            vertical: context.responsive<double>(
              xs: context.dimensions.spacingXS,
              sm: context.dimensions.spacingS,
              md: context.dimensions.spacingS,
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.surface),
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: context.responsive<double>(
                  xs: 16,
                  sm: 18,
                  md: 18,
                ),
                color: context.colors.primary,
              ),
              SizedBox(width: context.dimensions.spacingXS),
              if (!context.isMobile || label.length <= 10)
                Text(
                  label,
                  style: context.textStyles.caption.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.w500,
                    fontSize: context.responsive<double>(
                      xs: 11,
                      sm: 12,
                      md: 13,
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

// Collection documents dialog
class _CollectionDocumentsDialog extends ConsumerWidget {
  final String collectionName;

  const _CollectionDocumentsDialog({
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(collectionDocumentsProvider(collectionName));

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(
          xs: 16,
          sm: 24,
          md: 40,
          lg: 40,
        ),
        vertical: context.responsive<double>(
          xs: 24,
          sm: 40,
          md: 60,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusL),
        child: Container(
          width: context.responsive<double>(
            xs: MediaQuery.of(context).size.width * 0.95,
            sm: MediaQuery.of(context).size.width * 0.9,
            md: 800,
            lg: 1000,
            xl: 1200,
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            minHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(context.dimensions.borderRadiusL),
          ),
          child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.borderRadiusM),
                  topRight: Radius.circular(context.dimensions.borderRadiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.list,
                    color: context.colors.primary,
                    size: context.responsive<double>(
                      xs: context.dimensions.iconSizeM,
                      sm: context.dimensions.iconSizeM,
                      md: context.dimensions.iconSizeL,
                    ),
                  ),
                  SizedBox(width: context.responsive<double>(
                    xs: context.dimensions.spacingS,
                    sm: context.dimensions.spacingM,
                  )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatCollectionName(collectionName),
                          style: context.responsive<TextStyle>(
                            xs: context.textStyles.title,
                            sm: context.textStyles.title,
                            md: context.textStyles.headline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!context.isMobile)
                          Text(
                            'Documents',
                            style: context.textStyles.caption.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (context.isMobile)
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _showAddDocumentDialog(context, ref),
                      color: context.colors.primary,
                      tooltip: 'Add New',
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: () => _showAddDocumentDialog(context, ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                        minimumSize: Size(0, 36),
                      ),
                      icon: Icon(Icons.add, size: 18),
                      label: Text('Add New'),
                    ),
                  SizedBox(width: context.dimensions.spacingS),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: documentsAsync.when(
                data: (documents) => _buildDocumentsList(context, ref, documents),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(
                    'Error loading documents: $error',
                    style: context.textStyles.body.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  String _formatCollectionName(String name) {
    return name.replaceAll('_', ' ').split(' ').map((word) => 
      word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  Widget _buildDocumentsList(BuildContext context, WidgetRef ref, List<Map<String, dynamic>> documents) {
    if (documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 80,
              color: context.colors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: context.dimensions.spacingM),
            Text(
              'No documents found',
              style: context.textStyles.title.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: context.dimensions.spacingM),
            ElevatedButton.icon(
              onPressed: () => _showAddDocumentDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
              icon: Icon(Icons.add),
              label: Text('Add First Document'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(context.responsive<double>(
        xs: context.dimensions.spacingM,
        sm: context.dimensions.spacingL,
        md: context.dimensions.spacingL,
        lg: context.dimensions.spacingXL,
      )),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Card(
          margin: EdgeInsets.only(
            bottom: context.responsive<double>(
              xs: context.dimensions.spacingM,
              sm: context.dimensions.spacingM,
              md: context.dimensions.spacingL,
            ),
          ),
          elevation: 2,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.responsive<double>(
                xs: context.dimensions.spacingM,
                sm: context.dimensions.spacingL,
                md: context.dimensions.spacingL,
              ),
              vertical: context.responsive<double>(
                xs: context.dimensions.spacingS,
                sm: context.dimensions.spacingM,
                md: context.dimensions.spacingM,
              ),
            ),
            leading: CircleAvatar(
              radius: context.responsive<double>(
                xs: 20,
                sm: 24,
                md: 28,
              ),
              backgroundColor: context.colors.primary.withOpacity(0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: context.colors.primary,
                  fontSize: context.responsive<double>(
                    xs: 14,
                    sm: 16,
                    md: 18,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            title: Text(
              doc['id'] ?? 'No ID',
              style: context.textStyles.title,
            ),
            subtitle: Text(
              _getDocumentPreview(doc),
              style: context.textStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: context.isMobile
                ? PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _showEditDocumentDialog(context, ref, doc);
                          break;
                        case 'delete':
                          _confirmDeleteDocument(context, ref, doc['id']);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: context.colors.primary, size: 20),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: context.colors.error, size: 20),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: context.colors.error)),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: context.colors.primary),
                        onPressed: () => _showEditDocumentDialog(context, ref, doc),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: context.colors.error),
                        onPressed: () => _confirmDeleteDocument(context, ref, doc['id']),
                      ),
                    ],
                  ),
            onTap: () => _showDocumentDetails(context, doc),
          ),
        );
      },
    );
  }

  String _getDocumentPreview(Map<String, dynamic> doc) {
    final previewFields = <String>[];
    doc.forEach((key, value) {
      if (key != 'id' && key != 'created_at' && key != 'updated_at') {
        if (value is String && value.isNotEmpty) {
          previewFields.add('$key: $value');
        } else if (value is num) {
          previewFields.add('$key: $value');
        } else if (value is bool) {
          previewFields.add('$key: $value');
        }
      }
    });
    return previewFields.take(3).join(', ');
  }

  void _showAddDocumentDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _DocumentEditorDialog(
        collectionName: collectionName,
      ),
    );
  }

  void _showEditDocumentDialog(BuildContext context, WidgetRef ref, Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => _DocumentEditorDialog(
        collectionName: collectionName,
        document: document,
      ),
    );
  }

  void _showDocumentDetails(BuildContext context, Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => _DocumentDetailsDialog(
        document: document,
      ),
    );
  }

  void _confirmDeleteDocument(BuildContext context, WidgetRef ref, String documentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete this document?\nID: $documentId'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(databaseOperationsProvider.notifier).deleteDocument(collectionName, documentId);
                ref.invalidate(collectionDocumentsProvider(collectionName));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting document: $e'),
                    backgroundColor: context.colors.error,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// Document editor dialog
class _DocumentEditorDialog extends ConsumerStatefulWidget {
  final String collectionName;
  final Map<String, dynamic>? document;

  const _DocumentEditorDialog({
    required this.collectionName,
    this.document,
  });

  @override
  ConsumerState<_DocumentEditorDialog> createState() => _DocumentEditorDialogState();
}

class _DocumentEditorDialogState extends ConsumerState<_DocumentEditorDialog> {
  late TextEditingController _jsonController;
  bool _isValidJson = true;
  String? _jsonError;

  @override
  void initState() {
    super.initState();
    final initialData = widget.document ?? _getDefaultDataForCollection(widget.collectionName);
    // Remove system fields for editing
    final editableData = Map<String, dynamic>.from(initialData);
    editableData.remove('id');
    editableData.remove('created_at');
    editableData.remove('updated_at');
    
    _jsonController = TextEditingController(
      text: const JsonEncoder.withIndent('  ').convert(editableData),
    );
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getDefaultDataForCollection(String collectionName) {
    switch (collectionName) {
      case 'users':
        return {
          'auth_uid': '',
          'email': '',
          'first_name': '',
          'last_name': '',
          'role': 'user',
          'is_active': true,
        };
      case 'employees':
        return {
          'first_name': '',
          'last_name': '',
          'is_active': true,
        };
      case 'company_cards':
        return {
          'holder_name': '',
          'last_four_digits': '',
          'is_active': true,
        };
      case 'expenses':
        return {
          'user_id': '',
          'card_id': '',
          'amount': 0.0,
          'date': Timestamp.now(),
          'description': '',
          'image_url': '',
        };
      case 'job_records':
        return {
          'user_id': '',
          'job_name': '',
          'date': Timestamp.now(),
          'territorial_manager': '',
          'job_size': '',
          'material': '',
          'job_description': '',
          'foreman': '',
          'vehicle': '',
          'employees': [],
        };
      default:
        return {};
    }
  }

  void _validateJson() {
    try {
      json.decode(_jsonController.text);
      setState(() {
        _isValidJson = true;
        _jsonError = null;
      });
    } catch (e) {
      setState(() {
        _isValidJson = false;
        _jsonError = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.document != null;

    return Dialog(
      child: Container(
        width: context.responsive<double>(
          xs: MediaQuery.of(context).size.width * 0.95,
          sm: MediaQuery.of(context).size.width * 0.9,
          md: 600,
          lg: 700,
          xl: 800,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.borderRadiusM),
                  topRight: Radius.circular(context.dimensions.borderRadiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isEditing ? Icons.edit : Icons.add,
                    color: context.colors.primary,
                    size: context.dimensions.iconSizeL,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Document' : 'Add Document',
                          style: context.textStyles.headline,
                        ),
                        Text(
                          _formatCollectionName(widget.collectionName),
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEditing) ...[
                      Text(
                        'Document ID: ${widget.document!['id']}',
                        style: context.textStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacingM),
                    ],
                    Text(
                      'Edit JSON Data',
                      style: context.textStyles.subtitle,
                    ),
                    SizedBox(height: context.dimensions.spacingS),
                    Text(
                      'System fields (id, created_at, updated_at) will be handled automatically',
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                      ),
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _isValidJson ? context.colors.surface : context.colors.error,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                        ),
                        child: TextField(
                          controller: _jsonController,
                          maxLines: null,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14.0,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(context.dimensions.spacingM),
                          ),
                          onChanged: (value) => _validateJson(),
                        ),
                      ),
                    ),
                    if (_jsonError != null) ...[
                      SizedBox(height: context.dimensions.spacingS),
                      Text(
                        _jsonError!,
                        style: context.textStyles.caption.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Actions
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: context.colors.surface),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.primary,
                      side: BorderSide(color: context.colors.primary),
                    ),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  ElevatedButton(
                    onPressed: !_isValidJson ? null : () => _handleSave(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.onPrimary,
                    ),
                    child: Text(isEditing ? 'Update' : 'Create'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCollectionName(String name) {
    return name.replaceAll('_', ' ').split(' ').map((word) => 
      word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  void _handleSave() async {
    if (!_isValidJson) return;

    try {
      final data = json.decode(_jsonController.text) as Map<String, dynamic>;
      
      if (widget.document != null) {
        // Update existing document
        await ref.read(databaseOperationsProvider.notifier).updateDocument(
          widget.collectionName,
          widget.document!['id'],
          data,
        );
      } else {
        // Create new document
        await ref.read(databaseOperationsProvider.notifier).createDocument(
          widget.collectionName,
          data,
        );
      }
      
      // Refresh data and close dialog
      ref.invalidate(collectionDocumentsProvider(widget.collectionName));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving document: $e'),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }
}

// Document details dialog
class _DocumentDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> document;

  const _DocumentDetailsDialog({
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: context.responsive<double>(
          xs: MediaQuery.of(context).size.width * 0.95,
          sm: MediaQuery.of(context).size.width * 0.9,
          md: 600,
          lg: 700,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(context.dimensions.spacingM),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.dimensions.borderRadiusM),
                  topRight: Radius.circular(context.dimensions.borderRadiusM),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.description,
                    color: context.colors.primary,
                    size: context.dimensions.iconSizeL,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document Details',
                          style: context.textStyles.headline,
                        ),
                        Text(
                          document['id'] ?? 'No ID',
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                child: Container(
                  padding: EdgeInsets.all(context.dimensions.spacingM),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                    border: Border.all(
                      color: context.colors.surface,
                    ),
                  ),
                  child: SelectableText(
                    _formatJson(document),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatJson(Map<String, dynamic> json) {
    // Convert Timestamps to readable strings
    final processedJson = _processJson(json);
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(processedJson);
  }
  
  dynamic _processJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value.map((key, val) => MapEntry(key, _processJson(val)));
    } else if (value is List) {
      return value.map((item) => _processJson(item)).toList();
    } else if (value is DateTime) {
      return value.toIso8601String();
    } else if (value is Timestamp) {
      // Convert Firestore Timestamp to DateTime string
      return value.toDate().toIso8601String();
    }
    return value;
  }
}

// Generate test data dialog
class _GenerateTestDataDialog extends ConsumerStatefulWidget {
  final String collectionName;

  const _GenerateTestDataDialog({
    required this.collectionName,
  });

  @override
  ConsumerState<_GenerateTestDataDialog> createState() => _GenerateTestDataDialogState();
}

class _GenerateTestDataDialogState extends ConsumerState<_GenerateTestDataDialog> {
  final _countController = TextEditingController(text: '10');
  int _count = 10;

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: context.responsive<double>(
          xs: MediaQuery.of(context).size.width * 0.9,
          sm: MediaQuery.of(context).size.width * 0.85,
          md: 400,
          lg: 500,
        ),
        padding: EdgeInsets.all(context.responsive<double>(
          xs: context.dimensions.spacingM,
          sm: context.dimensions.spacingM,
          md: context.dimensions.spacingL,
          lg: context.dimensions.spacingL,
        )),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.science,
                  color: context.colors.primary,
                  size: context.dimensions.iconSizeL,
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generate Test Data',
                        style: context.textStyles.title,
                      ),
                      Text(
                        _formatCollectionName(widget.collectionName),
                        style: context.textStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingL),
            Text(
              'Number of documents to generate:',
              style: context.textStyles.body,
            ),
            SizedBox(height: context.dimensions.spacingM),
            TextField(
              controller: _countController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.dimensions.spacingM,
                  vertical: context.dimensions.spacingS,
                ),
              ),
              onChanged: (value) {
                final count = int.tryParse(value);
                if (count != null && count > 0) {
                  setState(() {
                    _count = count;
                  });
                }
              },
            ),
            SizedBox(height: context.dimensions.spacingL),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.primary,
                    side: BorderSide(color: context.colors.primary),
                  ),
                  child: Text('Cancel'),
                ),
                SizedBox(width: context.dimensions.spacingM),
                ElevatedButton.icon(
                  onPressed: () => _handleGenerate(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                  icon: Icon(Icons.add_circle),
                  label: Text('Generate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatCollectionName(String name) {
    return name.replaceAll('_', ' ').split(' ').map((word) => 
      word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1)
    ).join(' ');
  }

  void _handleGenerate() async {
    Navigator.of(context).pop();
    try {
      await ref.read(databaseOperationsProvider.notifier).generateTestData(
        widget.collectionName,
        _count,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating test data: $e'),
          backgroundColor: context.colors.error,
        ),
      );
    }
  }
}