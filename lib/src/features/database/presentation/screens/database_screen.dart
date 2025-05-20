import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/database/presentation/providers/database_providers.dart';
import 'package:timesheet_app_web/src/features/database/presentation/widgets/import_collection_dialog.dart';
import 'package:timesheet_app_web/src/features/database/data/models/database_stats_model.dart';

class DatabaseScreen extends ConsumerWidget {
  const DatabaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseStatsAsync = ref.watch(databaseStatsProvider);
    final operationsState = ref.watch(databaseOperationsProvider);

    return Scaffold(
      appBar: AppHeader(
        title: 'Database Management',
        showBackButton: true,
        showNavigationMenu: false,
        actionIcon: Icons.refresh,
        onActionPressed: () => ref.refresh(databaseStatsProvider),
      ),
      body: databaseStatsAsync.when(
        data: (stats) => _buildContent(context, ref, stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
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
              ElevatedButton(
                onPressed: () => ref.refresh(databaseStatsProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.primary,
                  foregroundColor: context.colors.onPrimary,
                ),
                child: Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<DatabaseStatsModel> stats) {
    final operationsState = ref.watch(databaseOperationsProvider);

    return ResponsiveContainer(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Actions section
            _buildActionsSection(context, ref),
            SizedBox(height: context.dimensions.spacingL),
            
            // Operations feedback
            if (operationsState is AsyncLoading)
              _buildLoadingIndicator(context, 'Processing operation...')
            else if (operationsState is AsyncData && operationsState.value != null)
              _buildSuccessMessage(context, operationsState.value!)
            else if (operationsState is AsyncError)
              _buildErrorMessage(context, operationsState.error.toString()),
            
            // Database overview
            Text(
              'Database Overview',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingM),
            _buildOverviewCard(context, stats),
            SizedBox(height: context.dimensions.spacingL),
            
            // Collections
            Text(
              'Collections',
              style: context.textStyles.headline,
            ),
            SizedBox(height: context.dimensions.spacingM),
            
            ResponsiveGrid(
              spacing: context.dimensions.spacingM,
              xsColumns: 1,
              smColumns: 2,
              mdColumns: 3,
              lgColumns: 3,
              xlColumns: 4,
              children: stats.map((stat) => _buildCollectionCard(context, ref, stat)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Database Actions',
              style: context.textStyles.title,
            ),
            SizedBox(height: context.dimensions.spacingM),
            Wrap(
              spacing: context.dimensions.spacingM,
              runSpacing: context.dimensions.spacingM,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _handleBackup(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                  icon: Icon(Icons.backup),
                  label: Text('Backup Database'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showUploadDialog(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: context.colors.onPrimary,
                  ),
                  icon: Icon(Icons.upload_file),
                  label: Text('Restore from Backup'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _handleClearCache(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.colors.primary,
                    side: BorderSide(color: context.colors.primary),
                  ),
                  icon: Icon(Icons.cleaning_services),
                  label: Text('Clear Cache'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context, List<DatabaseStatsModel> stats) {
    final totalDocuments = stats.fold(0, (sum, stat) => sum + stat.documentCount);
    final totalSize = stats.fold(0, (sum, stat) => sum + stat.approximateSizeInBytes);
    final mostRecentUpdate = stats
        .where((stat) => stat.lastUpdated != null)
        .map((stat) => stat.lastUpdated!)
        .fold<DateTime?>(null, (a, b) => a == null || b.isAfter(a) ? b : a);

    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.storage,
                  size: context.dimensions.iconSizeL,
                  color: context.colors.primary,
                ),
                SizedBox(width: context.dimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Documents',
                        style: context.textStyles.caption.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      Text(
                        totalDocuments.toString(),
                        style: context.textStyles.headline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.dimensions.spacingM),
            _buildStatRow(
              context,
              icon: Icons.data_usage,
              label: 'Approximate Size',
              value: _formatBytes(totalSize),
            ),
            if (mostRecentUpdate != null) ...[
              SizedBox(height: context.dimensions.spacingS),
              _buildStatRow(
                context,
                icon: Icons.update,
                label: 'Last Updated',
                value: _formatDateTime(mostRecentUpdate),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionCard(BuildContext context, WidgetRef ref, DatabaseStatsModel stat) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _showCollectionDetails(context, ref, stat),
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(context.dimensions.spacingS),
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusS),
                    ),
                    child: Icon(
                      Icons.folder,
                      color: context.colors.primary,
                      size: context.dimensions.iconSizeM,
                    ),
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      stat.collectionName,
                      style: context.textStyles.title,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          _showCollectionDocuments(context, ref, stat.collectionName);
                          break;
                        case 'add':
                          _showAddDocumentDialog(context, ref, stat.collectionName);
                          break;
                        case 'test':
                          _showGenerateTestDataDialog(context, ref, stat.collectionName);
                          break;
                        case 'export':
                          _handleExportCollection(context, ref, stat.collectionName);
                          break;
                        case 'import':
                          _handleImportCollection(context, ref, stat.collectionName);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'view',
                        child: Row(
                          children: [
                            Icon(Icons.visibility, size: 20),
                            SizedBox(width: 8),
                            Text('View Documents'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'add',
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 20),
                            SizedBox(width: 8),
                            Text('Add Document'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'test',
                        child: Row(
                          children: [
                            Icon(Icons.science, size: 20),
                            SizedBox(width: 8),
                            Text('Generate Test Data'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'export',
                        child: Row(
                          children: [
                            Icon(Icons.download, size: 20),
                            SizedBox(width: 8),
                            Text('Export'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'import',
                        child: Row(
                          children: [
                            Icon(Icons.upload_file, size: 20),
                            SizedBox(width: 8),
                            Text('Import CSV'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.dimensions.spacingM),
              _buildCollectionStat(
                context,
                label: 'Documents',
                value: stat.documentCount.toString(),
              ),
              SizedBox(height: context.dimensions.spacingXS),
              _buildCollectionStat(
                context,
                label: 'Size',
                value: _formatBytes(stat.approximateSizeInBytes),
              ),
              if (stat.lastUpdated != null) ...[
                SizedBox(height: context.dimensions.spacingXS),
                _buildCollectionStat(
                  context,
                  label: 'Last Updated',
                  value: _formatDateTime(stat.lastUpdated!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: context.dimensions.iconSizeS,
          color: context.colors.textSecondary,
        ),
        SizedBox(width: context.dimensions.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.textStyles.caption.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              Text(
                value,
                style: context.textStyles.body,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionStat(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyles.caption.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.textStyles.body,
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      ),
      child: Row(
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          SizedBox(width: context.dimensions.spacingM),
          Text(
            message,
            style: context.textStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessMessage(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
      decoration: BoxDecoration(
        color: context.colors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      ),
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
              message,
              style: context.textStyles.body.copyWith(
                color: context.colors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, String error) {
    return Container(
      padding: EdgeInsets.all(context.dimensions.spacingM),
      margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
      decoration: BoxDecoration(
        color: context.colors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
      ),
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
              error,
              style: context.textStyles.body.copyWith(
                color: context.colors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCollectionDetails(BuildContext context, WidgetRef ref, DatabaseStatsModel stat) {
    showDialog(
      context: context,
      builder: (context) => _CollectionDetailsDialog(
        collectionName: stat.collectionName,
      ),
    );
  }

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
        title: const Text('Export Collection'),
        content: Text('Export the "$collectionName" collection?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).exportCollection(collectionName);
            },
            child: Text(
              'Export',
              style: TextStyle(color: context.colors.primary),
            ),
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
  
  void _showUploadDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Select Collection to Restore'),
        contentPadding: EdgeInsets.all(context.dimensions.spacingL),
        children: [
          Text('Choose a collection to restore from backup:'),
          SizedBox(height: context.dimensions.spacingM),
          ...['users', 'employees', 'company_cards', 'expenses', 'job_records'].map((collection) => 
            ListTile(
              leading: Icon(Icons.upload_file),
              title: Text(collection),
              onTap: () {
                Navigator.of(context).pop();
                _handleImportCollection(context, ref, collection);
              },
            ),
          ),
          SizedBox(height: context.dimensions.spacingM),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBackup(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup Database'),
        content: const Text('Create a backup of all collections?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).backupDatabase();
            },
            child: Text(
              'Backup',
              style: TextStyle(color: context.colors.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _handleClearCache(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('Clear the local Firestore cache? This may temporarily slow down data loading.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(databaseOperationsProvider.notifier).clearCache();
            },
            child: Text(
              'Clear',
              style: TextStyle(color: context.colors.error),
            ),
          ),
        ],
      ),
    );
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
}

// Collection details dialog
class _CollectionDetailsDialog extends ConsumerWidget {
  final String collectionName;

  const _CollectionDetailsDialog({
    required this.collectionName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionDetailsAsync = ref.watch(collectionDetailsProvider(collectionName));
    final sampleDocumentAsync = ref.watch(sampleDocumentProvider(collectionName));

    return Dialog(
      child: Container(
        width: context.responsive<double>(
          xs: double.infinity,
          sm: 500,
          md: 600,
          lg: 700,
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    Icons.folder,
                    color: context.colors.primary,
                    size: context.dimensions.iconSizeL,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collectionName,
                          style: context.textStyles.headline,
                        ),
                        Text(
                          'Collection Details',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    collectionDetailsAsync.when(
                      data: (details) => _buildDetailsSection(context, details),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text(
                        'Error loading collection details: $error',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ),
                    SizedBox(height: context.dimensions.spacingL),
                    Text(
                      'Sample Document',
                      style: context.textStyles.title,
                    ),
                    SizedBox(height: context.dimensions.spacingM),
                    sampleDocumentAsync.when(
                      data: (document) => _buildSampleDocument(context, document),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => Text(
                        'Error loading sample document: $error',
                        style: context.textStyles.body.copyWith(
                          color: context.colors.error,
                        ),
                      ),
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

  Widget _buildDetailsSection(BuildContext context, DatabaseCollectionModel details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Collection Information',
          style: context.textStyles.title,
        ),
        SizedBox(height: context.dimensions.spacingM),
        _buildDetailRow(
          context,
          label: 'Document Count',
          value: details.documentCount.toString(),
        ),
        if (details.lastUpdated != null) ...[
          SizedBox(height: context.dimensions.spacingS),
          _buildDetailRow(
            context,
            label: 'Last Updated',
            value: _formatDateTime(details.lastUpdated!),
          ),
        ],
        SizedBox(height: context.dimensions.spacingL),
        Text(
          'Fields',
          style: context.textStyles.subtitle,
        ),
        SizedBox(height: context.dimensions.spacingS),
        Wrap(
          spacing: context.dimensions.spacingS,
          runSpacing: context.dimensions.spacingS,
          children: details.fields.map((field) => Chip(
            label: Text(field),
            backgroundColor: context.colors.primary.withOpacity(0.1),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSampleDocument(BuildContext context, Map<String, dynamic> document) {
    if (document.isEmpty) {
      return Text(
        'No documents in this collection',
        style: context.textStyles.body.copyWith(
          color: context.colors.textSecondary,
        ),
      );
    }

    return Container(
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
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textStyles.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
        Text(
          value,
          style: context.textStyles.body,
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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
      return _formatDateTime(value.toDate());
    }
    return value;
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
      child: Container(
        width: context.responsive<double>(
          xs: double.infinity,
          sm: 700,
          md: 900,
          lg: 1000,
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
                    Icons.list,
                    color: context.colors.primary,
                    size: context.dimensions.iconSizeL,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          collectionName,
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
                  ),
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
                  SizedBox(width: context.dimensions.spacingM),
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
    );
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
      padding: EdgeInsets.all(context.dimensions.spacingM),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: context.colors.primary.withOpacity(0.1),
              child: Text(
                '${index + 1}',
                style: TextStyle(color: context.colors.primary),
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
            trailing: Row(
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
      case 'job_drafts':
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
          xs: double.infinity,
          sm: 600,
          md: 700,
          lg: 800,
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
                          widget.collectionName,
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
          xs: double.infinity,
          sm: 600,
          md: 700,
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
          xs: double.infinity,
          sm: 400,
          md: 500,
        ),
        padding: EdgeInsets.all(context.dimensions.spacingL),
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
                        widget.collectionName,
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