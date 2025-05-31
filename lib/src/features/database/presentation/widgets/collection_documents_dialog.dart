import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/database/presentation/providers/database_providers.dart';
import 'dart:convert';

class CollectionDocumentsDialog extends ConsumerStatefulWidget {
  final String collectionName;

  const CollectionDocumentsDialog({
    super.key,
    required this.collectionName,
  });

  @override
  ConsumerState<CollectionDocumentsDialog> createState() => _CollectionDocumentsDialogState();
}

class _CollectionDocumentsDialogState extends ConsumerState<CollectionDocumentsDialog> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  int _currentLimit = 20;

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(collectionDocumentsProvider(
      widget.collectionName,
      limit: _currentLimit,
    ));

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.responsive<double>(
          xs: 16,
          sm: 24,
          md: 40,
          lg: 60,
        ),
        vertical: context.responsive<double>(
          xs: 24,
          sm: 40,
          md: 60,
        ),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
                    _getIconForCollection(widget.collectionName),
                    color: context.colors.primary,
                    size: context.dimensions.iconSizeL,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatCollectionName(widget.collectionName),
                          style: context.textStyles.headline,
                        ),
                        Text(
                          'Collection Documents',
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: documentsAsync.when(
                data: (documents) => _buildDocumentsList(context, documents),
                loading: () => Center(child: CircularProgressIndicator()),
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
                        'Error loading documents',
                        style: context.textStyles.title,
                      ),
                      SizedBox(height: context.dimensions.spacingS),
                      Text(
                        error.toString(),
                        style: context.textStyles.body.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: context.dimensions.spacingL),
                      ElevatedButton.icon(
                        onPressed: () => ref.refresh(collectionDocumentsProvider(
                          widget.collectionName,
                          limit: _currentLimit,
                        )),
                        icon: Icon(Icons.refresh),
                        label: Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsList(BuildContext context, List<Map<String, dynamic>> documents) {
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
          ],
        ),
      );
    }

    // Get all unique keys from documents
    final allKeys = <String>{};
    for (final doc in documents) {
      allKeys.addAll(doc.keys);
    }
    final sortedKeys = allKeys.toList()..sort();

    return Column(
      children: [
        // Actions bar
        Container(
          padding: EdgeInsets.all(context.dimensions.spacingM),
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(
              bottom: BorderSide(
                color: context.colors.surface,
              ),
            ),
          ),
          child: Row(
            children: [
              Text(
                '${documents.length} documents',
                style: context.textStyles.body,
              ),
              Spacer(),
              if (documents.length == _currentLimit)
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentLimit += 20;
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('Load More'),
                ),
              SizedBox(width: context.dimensions.spacingM),
              OutlinedButton.icon(
                onPressed: () => _exportDocuments(documents),
                icon: Icon(Icons.download),
                label: Text('Export'),
              ),
            ],
          ),
        ),
        // Data table
        Expanded(
          child: context.isMobile
              ? _buildMobileList(context, documents, sortedKeys)
              : _buildDesktopTable(context, documents, sortedKeys),
        ),
      ],
    );
  }

  Widget _buildMobileList(
    BuildContext context,
    List<Map<String, dynamic>> documents,
    List<String> keys,
  ) {
    return ListView.builder(
      controller: _verticalScrollController,
      padding: EdgeInsets.all(context.dimensions.spacingM),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Card(
          margin: EdgeInsets.only(bottom: context.dimensions.spacingM),
          child: ExpansionTile(
            title: Text(
              doc['id'] ?? 'Document ${index + 1}',
              style: context.textStyles.subtitle,
            ),
            subtitle: Text(
              _getDocumentPreview(doc),
              style: context.textStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            children: [
              Container(
                padding: EdgeInsets.all(context.dimensions.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: keys.map((key) {
                    final value = doc[key];
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.dimensions.spacingS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              key,
                              style: context.textStyles.caption.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              _formatValue(value),
                              style: context.textStyles.caption,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(
    BuildContext context,
    List<Map<String, dynamic>> documents,
    List<String> keys,
  ) {
    return Scrollbar(
      controller: _horizontalScrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _horizontalScrollController,
        scrollDirection: Axis.horizontal,
        child: Scrollbar(
          controller: _verticalScrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _verticalScrollController,
            child: DataTable(
              columns: keys.map((key) => DataColumn(
                label: Text(
                  key,
                  style: context.textStyles.subtitle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )).toList(),
              rows: documents.map((doc) => DataRow(
                cells: keys.map((key) => DataCell(
                  Container(
                    constraints: BoxConstraints(maxWidth: 300),
                    child: Text(
                      _formatValue(doc[key]),
                      style: context.textStyles.body,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                )).toList(),
              )).toList(),
            ),
          ),
        ),
      ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is DateTime) return value.toLocal().toString();
    if (value is Map || value is List) {
      try {
        return const JsonEncoder.withIndent('  ').convert(value);
      } catch (e) {
        return value.toString();
      }
    }
    return value.toString();
  }

  String _getDocumentPreview(Map<String, dynamic> doc) {
    final previewFields = <String>[];
    doc.forEach((key, value) {
      if (key != 'id' && previewFields.length < 3) {
        if (value != null && value.toString().isNotEmpty) {
          previewFields.add('$key: ${_formatValue(value).split('\n').first}');
        }
      }
    });
    return previewFields.join(' • ');
  }

  void _exportDocuments(List<Map<String, dynamic>> documents) {
    ref.read(databaseOperationsProvider.notifier).exportCollection(widget.collectionName);
    Navigator.of(context).pop();
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
}