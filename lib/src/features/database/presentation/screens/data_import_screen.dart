import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/providers/firebase_providers.dart';
import 'package:timesheet_app_web/src/core/theme/app_dimensions.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
// Removed unused import
import 'package:timesheet_app_web/src/features/database/services/data_importer_service.dart';

class DataImportScreen extends ConsumerStatefulWidget {
  const DataImportScreen({super.key});

  @override
  ConsumerState<DataImportScreen> createState() => _DataImportScreenState();
}

class _DataImportScreenState extends ConsumerState<DataImportScreen> {
  bool _isImporting = false;
  String? _selectedFileName;
  String? _fileContent;
  ImportReport? _report;
  String? _error;
  ImportMode _importMode = ImportMode.merge;

  void _selectFile() {
    final input = html.FileUploadInputElement()..accept = '.json';
    input.click();

    input.onChange.listen((e) {
      final files = input.files;
      if (files?.isNotEmpty ?? false) {
        final file = files!.first;
        setState(() {
          _selectedFileName = file.name;
          _error = null;
        });

        final reader = html.FileReader();
        reader.readAsText(file);
        reader.onLoadEnd.listen((e) {
          setState(() {
            _fileContent = reader.result as String;
          });
        });
      }
    });
  }

  Future<void> _startImport() async {
    if (_fileContent == null) {
      setState(() {
        _error = 'Please select a file first';
      });
      return;
    }

    setState(() {
      _isImporting = true;
      _error = null;
      _report = null;
    });

    try {
      final firestore = ref.read(firestoreProvider);
      final importer = DataImporterService(firestore);
      final report = await importer.importFromJson(_fileContent!, mode: _importMode);

      setState(() {
        _report = report;
        _isImporting = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Import failed: $e';
        _isImporting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colors = theme.colors;
    final textStyles = theme.textStyles;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        children: [
          AppHeader(
            title: 'Data Import',
            showBackButton: true,
            onBackPressed: () => context.pop(),
          ),
          Expanded(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(AppDimensions.padding16),
                child: Card(
                  color: colors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.padding24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Import Data from Old App',
                          style: textStyles.headline.copyWith(
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacing24),
                        
                        if (!_isImporting && _report == null) ...[
                          Text(
                            'Select the backup JSON file to import data',
                            style: textStyles.body.copyWith(
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppDimensions.spacing24),
                          
                          if (_selectedFileName != null) ...[
                            Container(
                              padding: const EdgeInsets.all(AppDimensions.padding12),
                              decoration: BoxDecoration(
                                color: colors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                border: Border.all(color: colors.success),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle, 
                                    color: colors.success,
                                    size: 20,
                                  ),
                                  const SizedBox(width: AppDimensions.spacing8),
                                  Expanded(
                                    child: Text(
                                      'Selected: $_selectedFileName',
                                      style: textStyles.body.copyWith(
                                        color: colors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacing16),
                          ],
                          
                          ElevatedButton.icon(
                            onPressed: _selectFile,
                            icon: Icon(Icons.upload_file),
                            label: Text(
                              _selectedFileName == null 
                                ? 'Select Backup File' 
                                : 'Change File'
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                            ),
                          ),
                          
                          if (_selectedFileName != null) ...[
                            const SizedBox(height: AppDimensions.spacing24),
                            Container(
                              padding: const EdgeInsets.all(AppDimensions.padding16),
                              decoration: BoxDecoration(
                                color: colors.primary.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                                border: Border.all(color: colors.primary.withOpacity(0.2)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Import Mode',
                                    style: textStyles.subtitle.copyWith(
                                      color: colors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimensions.spacing8),
                                  RadioListTile<ImportMode>(
                                    title: Text('Merge', style: textStyles.body),
                                    subtitle: Text(
                                      'Update existing records with new data',
                                      style: textStyles.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                    value: ImportMode.merge,
                                    groupValue: _importMode,
                                    onChanged: (value) {
                                      setState(() {
                                        _importMode = value!;
                                      });
                                    },
                                  ),
                                  RadioListTile<ImportMode>(
                                    title: Text('Skip Duplicates', style: textStyles.body),
                                    subtitle: Text(
                                      'Keep existing records unchanged',
                                      style: textStyles.caption.copyWith(
                                        color: colors.textSecondary,
                                      ),
                                    ),
                                    value: ImportMode.skip,
                                    groupValue: _importMode,
                                    onChanged: (value) {
                                      setState(() {
                                        _importMode = value!;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppDimensions.spacing16),
                            ElevatedButton.icon(
                              onPressed: _startImport,
                              icon: Icon(Icons.play_arrow),
                              label: Text('Start Import'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors.success,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ],
                        
                        if (_isImporting) ...[
                          const CircularProgressIndicator(),
                          const SizedBox(height: AppDimensions.spacing16),
                          Text(
                            'Importing data...',
                            style: textStyles.body.copyWith(
                              color: colors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        
                        if (_report != null) ...[
                          Container(
                            padding: const EdgeInsets.all(AppDimensions.padding16),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Import Complete!',
                                  style: textStyles.headline.copyWith(
                                    color: colors.success,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.spacing16),
                                Text(
                                  _report!.summary,
                                  style: textStyles.body.copyWith(
                                    color: colors.textPrimary,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _selectedFileName = null;
                                _fileContent = null;
                                _report = null;
                                _error = null;
                              });
                            },
                            icon: Icon(Icons.refresh),
                            label: Text('Import Another File'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
                            ),
                          ),
                        ],
                        
                        if (_error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(AppDimensions.padding12),
                            decoration: BoxDecoration(
                              color: colors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              border: Border.all(color: colors.error),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error, 
                                  color: colors.error,
                                  size: 20,
                                ),
                                const SizedBox(width: AppDimensions.spacing8),
                                Expanded(
                                  child: Text(
                                    _error!,
                                    style: textStyles.body.copyWith(
                                      color: colors.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}