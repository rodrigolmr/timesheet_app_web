import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:timesheet_app_web/src/features/pigtail/data/models/pigtail_model.dart';
import 'package:timesheet_app_web/src/features/pigtail/presentation/providers/pigtail_providers.dart';
import 'package:timesheet_app_web/src/features/pigtail/presentation/providers/pigtail_search_providers.dart';
import 'package:timesheet_app_web/src/features/pigtail/presentation/widgets/pigtail_filters.dart';
import 'package:timesheet_app_web/src/features/user/presentation/providers/user_providers.dart';

class PigtailScreen extends ConsumerStatefulWidget {
  const PigtailScreen({super.key});

  @override
  ConsumerState<PigtailScreen> createState() => _PigtailScreenState();
}

class _PigtailScreenState extends ConsumerState<PigtailScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'all';
  String? _selectedType;
  bool _filtersExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pigtailsAsync = ref.watch(pigtailsStreamProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Pigtail Tracker',
        subtitle: 'Track pigtail installations',
        actionIcon: Icons.add,
        onActionPressed: () => _showCreateDialog(context),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: pigtailsAsync.when(
              data: (pigtails) => _buildPigtailList(context, pigtails),
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
                    const SizedBox(height: 16),
                    Text(
                      'Error loading pigtails',
                      style: context.textStyles.title,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return PigtailFilters(
      searchController: _searchController,
      searchQuery: _searchQuery,
      selectedStatus: _selectedStatus,
      selectedType: _selectedType,
      filtersExpanded: _filtersExpanded,
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query.trim();
        });
        ref.read(pigtailSearchQueryProvider.notifier).updateQuery(query);
      },
      onStatusChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
        ref.read(pigtailSearchFiltersProvider.notifier).updateStatus(status);
      },
      onTypeChanged: (type) {
        setState(() {
          _selectedType = type;
        });
        ref.read(pigtailSearchFiltersProvider.notifier).updateType(type);
      },
      onExpandedChanged: (expanded) {
        setState(() {
          _filtersExpanded = expanded;
        });
      },
      onClearFilters: _clearAllFilters,
    );
  }

  void _clearAllFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedStatus = 'all';
      _selectedType = null;
    });
    ref.read(pigtailSearchQueryProvider.notifier).updateQuery('');
    ref.read(pigtailSearchFiltersProvider.notifier).clearFilters();
  }

  Widget _buildPigtailList(BuildContext context, List<PigtailModel> allPigtails) {
    final searchResults = ref.watch(pigtailSearchResultsProvider);
    var pigtails = searchResults.isEmpty && _searchController.text.isEmpty && _selectedStatus == 'all' && _selectedType == null
        ? allPigtails
        : searchResults;
    
    // Sort pigtails: installed first (by date desc), then removed (by date desc)
    pigtails = List<PigtailModel>.from(pigtails)..sort((a, b) {
      // First, separate by status (installed vs removed)
      if (a.isRemoved != b.isRemoved) {
        return a.isRemoved ? 1 : -1; // Installed first
      }
      
      // Then sort by date (most recent first)
      if (a.isRemoved && b.isRemoved) {
        // Both removed: sort by removal date
        final aDate = a.removedDate ?? a.installedDate;
        final bDate = b.removedDate ?? b.installedDate;
        return bDate.compareTo(aDate);
      } else {
        // Both installed: sort by installation date
        return b.installedDate.compareTo(a.installedDate);
      }
    });
    
    if (pigtails.isEmpty) {
      return _buildEmptyState(context);
    }

    final isMobile = context.isMobile;
    
    if (isMobile) {
      return ListView.builder(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        itemCount: pigtails.length,
        itemBuilder: (context, index) {
          final pigtail = pigtails[index];
          return _buildPigtailCard(context, pigtail);
        },
      );
    }

    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacingL),
      child: ResponsiveGrid(
        spacing: context.dimensions.spacingM,
        xsColumns: 1,
        smColumns: 2,
        mdColumns: 2,
        lgColumns: 3,
        children: pigtails.map((pigtail) => 
          _buildPigtailCard(context, pigtail)
        ).toList(),
      ),
    );
  }

  Widget _buildPigtailCard(BuildContext context, PigtailModel pigtail) {
    return Card(
      margin: EdgeInsets.only(bottom: context.dimensions.spacingS),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
        onTap: () => _showDetailsDialog(context, pigtail),
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingS),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.electrical_services,
                color: pigtail.isRemoved 
                    ? context.colors.textSecondary 
                    : context.colors.primary,
                size: 20,
              ),
              SizedBox(width: context.dimensions.spacingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pigtail.jobName,
                            style: context.textStyles.subtitle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: context.dimensions.spacingXS),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.dimensions.spacingXS,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: pigtail.isRemoved
                                ? context.colors.error.withOpacity(0.1)
                                : context.colors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            pigtail.isRemoved ? 'Removed' : 'Installed',
                            style: context.textStyles.caption.copyWith(
                              color: pigtail.isRemoved
                                  ? context.colors.error
                                  : context.colors.success,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.dimensions.spacingXS),
                    Wrap(
                      spacing: context.dimensions.spacingXS,
                      runSpacing: 2,
                      children: pigtail.pigtailItems.map((item) => 
                        Text(
                          '${item.type}(${item.quantity})',
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),
              FutureBuilder<bool>(
                future: ref.read(canEditPigtailProvider(pigtail.installedBy).future),
                builder: (context, snapshot) {
                  final canEdit = snapshot.data ?? false;
                  if (!canEdit) return const SizedBox.shrink();
                  
                  return PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: context.colors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _showEditDialog(context, pigtail);
                          break;
                        case 'remove':
                          _markAsRemoved(context, pigtail);
                          break;
                        case 'install':
                          _markAsInstalled(context, pigtail);
                          break;
                        case 'delete':
                          _deletePigtail(context, pigtail);
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: context.colors.textPrimary,
                            ),
                            SizedBox(width: context.dimensions.spacingS),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      if (!pigtail.isRemoved)
                        PopupMenuItem<String>(
                          value: 'remove',
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: context.colors.textPrimary,
                              ),
                              SizedBox(width: context.dimensions.spacingS),
                              Text('Mark as Removed'),
                            ],
                          ),
                        ),
                      if (pigtail.isRemoved)
                        PopupMenuItem<String>(
                          value: 'install',
                          child: Row(
                            children: [
                              Icon(
                                Icons.replay,
                                size: 18,
                                color: context.colors.textPrimary,
                              ),
                              SizedBox(width: context.dimensions.spacingS),
                              Text('Mark as Installed'),
                            ],
                          ),
                        ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: context.colors.error,
                            ),
                            SizedBox(width: context.dimensions.spacingS),
                            Text(
                              'Delete',
                              style: TextStyle(color: context.colors.error),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasFilters = _searchController.text.isNotEmpty || 
                      _selectedStatus != 'all' || 
                      _selectedType != null;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.electrical_services_outlined,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            hasFilters ? 'No pigtails found' : 'No pigtails tracked yet',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters 
                ? 'Try adjusting your search or filters'
                : 'Start tracking your pigtail installations',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (!hasFilters)
            ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Pigtail'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                foregroundColor: context.colors.onPrimary,
              ),
            )
          else
            TextButton(
              onPressed: _clearAllFilters,
              child: const Text('Clear filters'),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showCreateDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = context.isMobile;
    
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: isMobile ? 24 : 40,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? screenWidth - 32 : 550,
            maxHeight: isMobile ? screenHeight - 48 : screenHeight * 0.9,
          ),
          child: _CreatePigtailDialog(ref: ref),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, PigtailModel pigtail) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = context.isMobile;
    
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40,
          vertical: isMobile ? 24 : 40,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? screenWidth - 32 : 550,
            maxHeight: isMobile ? screenHeight - 48 : screenHeight * 0.9,
          ),
          child: _EditPigtailDialog(pigtail: pigtail, ref: ref),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, PigtailModel pigtail) {
    showDialog(
      context: context,
      builder: (_) => _PigtailDetailsDialog(pigtail: pigtail, ref: ref),
    );
  }

  Future<void> _markAsRemoved(BuildContext context, PigtailModel pigtail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark as Removed?'),
        content: Text('Are you sure you want to mark this pigtail installation at ${pigtail.jobName} as removed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: const Text('Mark Removed'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(pigtailStateProvider.notifier).markAsRemoved(pigtail.id, pigtail);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pigtail marked as removed'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    }
  }

  Future<void> _markAsInstalled(BuildContext context, PigtailModel pigtail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark as Installed?'),
        content: Text('Are you sure you want to mark this pigtail at ${pigtail.jobName} as installed again?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
            child: const Text('Mark Installed'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(pigtailStateProvider.notifier).markAsInstalled(pigtail.id, pigtail);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pigtail marked as installed'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    }
  }

  Future<void> _deletePigtail(BuildContext context, PigtailModel pigtail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Pigtail?'),
        content: Text('Are you sure you want to permanently delete this pigtail record at ${pigtail.jobName}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.error,
              foregroundColor: context.colors.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(pigtailStateProvider.notifier).delete(pigtail.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pigtail deleted successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    }
  }
}

class _CreatePigtailDialog extends StatefulWidget {
  final WidgetRef ref;

  const _CreatePigtailDialog({required this.ref});

  @override
  State<_CreatePigtailDialog> createState() => _CreatePigtailDialogState();
}

class _CreatePigtailDialogState extends State<_CreatePigtailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _jobNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final List<PigtailItem> _pigtailItems = [];
  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  
  // Validation states
  bool _jobNameHasError = false;
  bool _addressHasError = false;
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? context.dimensions.spacingM : context.dimensions.spacingL
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.electrical_services,
                    color: context.colors.primary,
                    size: 28,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      'Add Pigtail Installation',
                      style: context.textStyles.title,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: context.dimensions.spacingM),
                AppTextField(
                  controller: _jobNameController,
                  label: 'Job Name',
                  hintText: 'Enter job name',
                  hasError: _jobNameHasError,
                  errorText: _jobNameHasError ? 'Job name is required' : null,
                  onClearError: () {
                    setState(() {
                      _jobNameHasError = false;
                    });
                  },
                  onChanged: (value) {
                    if (_jobNameHasError && value.trim().isNotEmpty) {
                      setState(() {
                        _jobNameHasError = false;
                      });
                    }
                  },
                ),
                SizedBox(height: context.dimensions.spacingS),
                AppAddressField(
                  label: 'Address',
                  hintText: 'Enter installation address',
                  controller: _addressController,
                  hasError: _addressHasError,
                  errorText: _addressHasError ? 'Address is required' : null,
                  isRequired: true,
                  onClearError: () {
                    setState(() {
                      _addressHasError = false;
                    });
                  },
                  onChanged: (value) {
                    if (_addressHasError && value.trim().isNotEmpty) {
                      setState(() {
                        _addressHasError = false;
                      });
                    }
                  },
                ),
                SizedBox(height: context.dimensions.spacingS),
                AppDatePickerField(
                  label: 'Installation Date',
                  hintText: 'Select installation date',
                  initialDate: _selectedDate,
                  onDateSelected: (date) {
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                SizedBox(height: context.dimensions.spacingS),
                AppMultilineTextField(
                  controller: _notesController,
                  label: 'Notes (optional)',
                  hintText: 'Add any notes about this installation',
                  maxLines: 3,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Row(
                  children: [
                    Text(
                      'Pigtail Types',
                      style: context.textStyles.subtitle,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Type'),
                      onPressed: _addPigtailType,
                    ),
                  ],
                ),
                SizedBox(height: context.dimensions.spacingS),
                if (_pigtailItems.isEmpty)
                  Container(
                    padding: EdgeInsets.all(context.dimensions.spacingM),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.outline),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                    ),
                    child: Text(
                      'No pigtail types added yet',
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ..._pigtailItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.dimensions.spacingS),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.dimensions.spacingM,
                                vertical: context.dimensions.spacingS,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: BorderRadius.circular(
                                  context.dimensions.borderRadiusM,
                                ),
                                border: Border.all(color: context.colors.outline),
                              ),
                              child: Text(
                                '${item.type} (Qty: ${item.quantity})',
                                style: context.textStyles.body,
                              ),
                            ),
                          ),
                          SizedBox(width: context.dimensions.spacingS),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: context.colors.error,
                            ),
                            onPressed: () => _removePigtailType(index),
                            tooltip: 'Remove',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              SizedBox(height: context.dimensions.spacingM),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: context.dimensions.spacingS),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addPigtailType() {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddPigtailTypeDialog(
        onAdd: (type, quantity) {
          setState(() {
            _pigtailItems.add(PigtailItem(type: type, quantity: quantity));
          });
        },
      ),
    );
  }

  void _removePigtailType(int index) {
    setState(() {
      _pigtailItems.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    // Validate fields manually
    setState(() {
      _jobNameHasError = _jobNameController.text.trim().isEmpty;
      _addressHasError = _addressController.text.trim().isEmpty;
    });
    
    if (_jobNameHasError || _addressHasError) return;
    
    if (_pigtailItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please add at least one pigtail type'),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = await widget.ref.read(currentUserProfileProvider.future);
      if (currentUser == null) throw Exception('User not found');

      final pigtail = PigtailModel(
        id: '',
        jobName: _jobNameController.text.trim(),
        address: _addressController.text.trim(),
        pigtailItems: _pigtailItems,
        installedBy: currentUser.id,
        installedDate: _selectedDate,
        isRemoved: false,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(pigtailStateProvider.notifier).create(pigtail);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Pigtail installation added successfully'),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _AddPigtailTypeDialog extends StatefulWidget {
  final Function(String type, int quantity) onAdd;

  const _AddPigtailTypeDialog({required this.onAdd});

  @override
  State<_AddPigtailTypeDialog> createState() => _AddPigtailTypeDialogState();
}

class _AddPigtailTypeDialogState extends State<_AddPigtailTypeDialog> {
  final _typeController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  String? _selectedType;
  final _commonTypes = ['3 Phase', 'Spider Box', 'Single Phase', 'Custom'];
  
  // Validation states
  bool _quantityHasError = false;

  @override
  void dispose() {
    _typeController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Pigtail Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDropdownField<String>(
            label: 'Type',
            hintText: 'Select pigtail type',
            value: _selectedType,
            items: _commonTypes,
            onChanged: (value) {
              setState(() {
                _selectedType = value;
                if (value != 'Custom') {
                  _typeController.text = value ?? '';
                } else {
                  _typeController.clear();
                }
              });
            },
          ),
          if (_selectedType == 'Custom') ...[
            SizedBox(height: context.dimensions.spacingM),
            AppTextField(
              controller: _typeController,
              label: 'Custom Type',
              hintText: 'Enter custom type',
            ),
          ],
          SizedBox(height: context.dimensions.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quantity',
                style: context.textStyles.labelMedium.copyWith(
                  color: _quantityHasError ? context.colors.error : context.colors.onSurfaceVariant,
                ),
              ),
              SizedBox(height: context.dimensions.spacingXS),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      final currentQty = int.tryParse(_quantityController.text) ?? 1;
                      if (currentQty > 1) {
                        setState(() {
                          _quantityController.text = (currentQty - 1).toString();
                          _quantityHasError = false;
                        });
                      }
                    },
                    color: context.colors.primary,
                  ),
                  Expanded(
                    child: AppTextField(
                      controller: _quantityController,
                      label: '',
                      keyboardType: TextInputType.number,
                      hintText: '1',
                      hasError: _quantityHasError,
                      onClearError: () {
                        setState(() {
                          _quantityHasError = false;
                        });
                      },
                      onChanged: (value) {
                        if (_quantityHasError && value.isNotEmpty) {
                          final qty = int.tryParse(value);
                          if (qty != null && qty >= 1) {
                            setState(() {
                              _quantityHasError = false;
                            });
                          }
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      final currentQty = int.tryParse(_quantityController.text) ?? 0;
                      setState(() {
                        _quantityController.text = (currentQty + 1).toString();
                        _quantityHasError = false;
                      });
                    },
                    color: context.colors.primary,
                  ),
                ],
              ),
              if (_quantityHasError)
                Padding(
                  padding: EdgeInsets.only(top: context.dimensions.spacingXS),
                  child: Text(
                    'Enter a valid quantity (1 or more)',
                    style: context.textStyles.labelSmall.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final type = _typeController.text.trim();
            final quantity = int.tryParse(_quantityController.text);
            
            // Validate quantity
            setState(() {
              _quantityHasError = quantity == null || quantity < 1;
            });
            
            if (type.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Please select or enter a type'),
                  backgroundColor: context.colors.error,
                ),
              );
              return;
            }
            
            if (_quantityHasError) {
              return;
            }
            
            widget.onAdd(type, quantity!);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
            foregroundColor: context.colors.onPrimary,
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}


// Edit Dialog
class _EditPigtailDialog extends StatefulWidget {
  final PigtailModel pigtail;
  final WidgetRef ref;

  const _EditPigtailDialog({
    required this.pigtail,
    required this.ref,
  });

  @override
  State<_EditPigtailDialog> createState() => _EditPigtailDialogState();
}

class _EditPigtailDialogState extends State<_EditPigtailDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _jobNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _notesController;
  late final List<PigtailItem> _pigtailItems;
  late DateTime _selectedDate;
  DateTime? _removedDate;
  bool _isLoading = false;
  
  // Validation states
  bool _jobNameHasError = false;
  bool _addressHasError = false;
  
  @override
  void initState() {
    super.initState();
    _jobNameController = TextEditingController(text: widget.pigtail.jobName);
    _addressController = TextEditingController(text: widget.pigtail.address);
    _notesController = TextEditingController(text: widget.pigtail.notes ?? "");
    _pigtailItems = List.from(widget.pigtail.pigtailItems);
    _selectedDate = widget.pigtail.installedDate;
    _removedDate = widget.pigtail.removedDate;
  }

  @override
  void dispose() {
    _jobNameController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(
          isMobile ? context.dimensions.spacingM : context.dimensions.spacingL
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.electrical_services,
                    color: context.colors.primary,
                    size: 28,
                  ),
                  SizedBox(width: context.dimensions.spacingM),
                  Expanded(
                    child: Text(
                      'Edit Pigtail Installation',
                      style: context.textStyles.title,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: context.dimensions.spacingM),
                AppTextField(
                  controller: _jobNameController,
                  label: "Job Name",
                  hintText: "Enter job name",
                  hasError: _jobNameHasError,
                  errorText: _jobNameHasError ? "Job name is required" : null,
                  onClearError: () {
                    setState(() {
                      _jobNameHasError = false;
                    });
                  },
                  onChanged: (value) {
                    if (_jobNameHasError && value.trim().isNotEmpty) {
                      setState(() {
                        _jobNameHasError = false;
                      });
                    }
                  },
                ),
                SizedBox(height: context.dimensions.spacingS),
                AppAddressField(
                  label: 'Address',
                  hintText: 'Enter installation address',
                  controller: _addressController,
                  hasError: _addressHasError,
                  errorText: _addressHasError ? 'Address is required' : null,
                  isRequired: true,
                  onClearError: () {
                    setState(() {
                      _addressHasError = false;
                    });
                  },
                  onChanged: (value) {
                    if (_addressHasError && value.trim().isNotEmpty) {
                      setState(() {
                        _addressHasError = false;
                      });
                    }
                  },
                ),
                SizedBox(height: context.dimensions.spacingS),
                AppDatePickerField(
                  label: 'Installation Date',
                  hintText: 'Select installation date',
                  initialDate: _selectedDate,
                  onDateSelected: (date) {
                    if (date != null) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                ),
                SizedBox(height: context.dimensions.spacingS),
                if (widget.pigtail.isRemoved) ...[
                  AppDatePickerField(
                    label: 'Removal Date',
                    hintText: 'Select removal date',
                    initialDate: _removedDate ?? DateTime.now(),
                    onDateSelected: (date) {
                      setState(() {
                        _removedDate = date;
                      });
                    },
                  ),
                  SizedBox(height: context.dimensions.spacingS),
                ],
                AppMultilineTextField(
                  controller: _notesController,
                  label: "Notes (optional)",
                  hintText: "Add any notes about this installation",
                  maxLines: 3,
                ),
                SizedBox(height: context.dimensions.spacingM),
                Row(
                  children: [
                    Text(
                      "Pigtail Types",
                      style: context.textStyles.subtitle,
                    ),
                    const Spacer(),
                    TextButton.icon(
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text("Add Type"),
                      onPressed: _addPigtailType,
                    ),
                  ],
                ),
                SizedBox(height: context.dimensions.spacingS),
                if (_pigtailItems.isEmpty)
                  Container(
                    padding: EdgeInsets.all(context.dimensions.spacingM),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.colors.outline),
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                    ),
                    child: Text(
                      "No pigtail types added yet",
                      style: context.textStyles.body.copyWith(
                        color: context.colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else
                  ..._pigtailItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Padding(
                      padding: EdgeInsets.only(bottom: context.dimensions.spacingS),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.dimensions.spacingM,
                                vertical: context.dimensions.spacingS,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.surface,
                                borderRadius: BorderRadius.circular(
                                  context.dimensions.borderRadiusM,
                                ),
                                border: Border.all(color: context.colors.outline),
                              ),
                              child: Text(
                                "${item.type} (Qty: ${item.quantity})",
                                style: context.textStyles.body,
                              ),
                            ),
                          ),
                          SizedBox(width: context.dimensions.spacingS),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: context.colors.error,
                            ),
                            onPressed: () => _removePigtailType(index),
                            tooltip: "Remove",
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              SizedBox(height: context.dimensions.spacingM),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: context.dimensions.spacingS),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.colors.primary,
                        foregroundColor: context.colors.onPrimary,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addPigtailType() {
    showDialog(
      context: context,
      builder: (dialogContext) => _AddPigtailTypeDialog(
        onAdd: (type, quantity) {
          setState(() {
            _pigtailItems.add(PigtailItem(type: type, quantity: quantity));
          });
        },
      ),
    );
  }

  void _removePigtailType(int index) {
    setState(() {
      _pigtailItems.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    // Validate fields manually
    setState(() {
      _jobNameHasError = _jobNameController.text.trim().isEmpty;
      _addressHasError = _addressController.text.trim().isEmpty;
    });
    
    if (_jobNameHasError || _addressHasError) return;
    
    if (_pigtailItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please add at least one pigtail type"),
          backgroundColor: context.colors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedPigtail = widget.pigtail.copyWith(
        jobName: _jobNameController.text.trim(),
        address: _addressController.text.trim(),
        pigtailItems: _pigtailItems,
        installedDate: _selectedDate,
        removedDate: widget.pigtail.isRemoved ? _removedDate : null,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(pigtailStateProvider.notifier).update(
        widget.pigtail.id,
        updatedPigtail,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Pigtail installation updated successfully"),
            backgroundColor: context.colors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: context.colors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

// Details Dialog
class _PigtailDetailsDialog extends ConsumerWidget {
  final PigtailModel pigtail;
  final WidgetRef ref;

  const _PigtailDetailsDialog({
    required this.pigtail,
    required this.ref,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = context.isMobile;
    
    // Watch for changes to this specific pigtail
    final pigtailStream = ref.watch(pigtailByIdProvider(pigtail.id));
    
    return pigtailStream.when(
      data: (updatedPigtail) {
        final currentPigtail = updatedPigtail ?? pigtail;
        
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 40,
            vertical: isMobile ? 24 : 40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMobile ? screenWidth - 32 : 550,
              maxHeight: isMobile ? screenHeight - 48 : screenHeight * 0.9,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(
                  isMobile ? context.dimensions.spacingM : context.dimensions.spacingL
                ),
                child: _buildContent(context, currentPigtail),
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Dialog(
        child: Padding(
          padding: EdgeInsets.all(context.dimensions.spacingL),
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
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
              const SizedBox(height: 2),
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

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  Widget _buildContent(BuildContext context, PigtailModel pigtail) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!context.isMobile) ...[
          Row(
            children: [
              Icon(
                Icons.electrical_services,
                color: pigtail.isRemoved 
                    ? context.colors.textSecondary 
                    : context.colors.primary,
                size: 28,
              ),
              SizedBox(width: context.dimensions.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pigtail.jobName,
                      style: context.textStyles.title,
                    ),
                    SizedBox(height: context.dimensions.spacingXS),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.dimensions.spacingS,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: pigtail.isRemoved
                            ? context.colors.error.withOpacity(0.1)
                            : context.colors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        pigtail.isRemoved ? "Removed" : "Installed",
                        style: context.textStyles.caption.copyWith(
                          color: pigtail.isRemoved
                              ? context.colors.error
                              : context.colors.success,
                          fontWeight: FontWeight.w600,
                        ),
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
          SizedBox(height: context.dimensions.spacingL),
        ] else ...[
          // Mobile: status badge at the top
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.spacingM,
              vertical: context.dimensions.spacingS,
            ),
            decoration: BoxDecoration(
              color: pigtail.isRemoved
                  ? context.colors.error.withOpacity(0.1)
                  : context.colors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  pigtail.isRemoved ? Icons.event_available : Icons.electrical_services,
                  size: 16,
                  color: pigtail.isRemoved
                      ? context.colors.error
                      : context.colors.success,
                ),
                SizedBox(width: context.dimensions.spacingS),
                Text(
                  pigtail.isRemoved ? "Removed" : "Installed",
                  style: context.textStyles.body.copyWith(
                    color: pigtail.isRemoved
                        ? context.colors.error
                        : context.colors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: context.dimensions.spacingL),
        ],
        _buildDetailRow(
          context,
          Icons.work_outline,
          "Job Name",
          pigtail.jobName,
        ),
        SizedBox(height: context.dimensions.spacingM),
        _buildDetailRow(
          context,
          Icons.location_on_outlined,
          "Address",
          pigtail.address,
        ),
        SizedBox(height: context.dimensions.spacingM),
        _buildDetailRow(
          context,
          Icons.calendar_today_outlined,
          "Installed Date",
          _formatDate(pigtail.installedDate),
        ),
        if (pigtail.isRemoved && pigtail.removedDate != null) ...[
          SizedBox(height: context.dimensions.spacingM),
          _buildDetailRow(
            context,
            Icons.event_available,
            "Removed Date",
            _formatDate(pigtail.removedDate!),
          ),
        ],
        SizedBox(height: context.dimensions.spacingL),
        Text(
          "Pigtail Types",
          style: context.textStyles.subtitle,
        ),
        SizedBox(height: context.dimensions.spacingS),
        Wrap(
          spacing: context.dimensions.spacingS,
          runSpacing: context.dimensions.spacingS,
          children: pigtail.pigtailItems.map((item) => 
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.dimensions.spacingM,
                vertical: context.dimensions.spacingS,
              ),
              decoration: BoxDecoration(
                color: context.colors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "${item.type} (Qty: ${item.quantity})",
                style: context.textStyles.body.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ).toList(),
        ),
        if (pigtail.notes != null && pigtail.notes!.isNotEmpty) ...[
          SizedBox(height: context.dimensions.spacingL),
          Text(
            "Notes",
            style: context.textStyles.subtitle,
          ),
          SizedBox(height: context.dimensions.spacingS),
          Container(
            padding: EdgeInsets.all(context.dimensions.spacingM),
            decoration: BoxDecoration(
              color: context.colors.surface,
              borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
              border: Border.all(color: context.colors.outline),
            ),
            child: Text(
              pigtail.notes!,
              style: context.textStyles.body,
            ),
          ),
        ],
        SizedBox(height: context.dimensions.spacingL),
        FutureBuilder<bool>(
          future: ref.read(canEditPigtailProvider(pigtail.installedBy).future),
          builder: (context, snapshot) {
            final canEdit = snapshot.data ?? false;
            if (!canEdit) return const SizedBox.shrink();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!pigtail.isRemoved)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Mark as Removed"),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Mark as Removed?'),
                          content: Text('Are you sure you want to mark this pigtail installation at ${pigtail.jobName} as removed?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                foregroundColor: context.colors.onPrimary,
                              ),
                              child: const Text('Mark Removed'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await ref.read(pigtailStateProvider.notifier)
                            .markAsRemoved(pigtail.id, pigtail);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Pigtail marked as removed"),
                              backgroundColor: context.colors.success,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.warning,
                      foregroundColor: context.colors.onPrimary,
                    ),
                  ),
                if (pigtail.isRemoved)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.replay),
                    label: const Text("Mark as Installed"),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Mark as Installed?'),
                          content: Text('Are you sure you want to mark this pigtail at ${pigtail.jobName} as installed again?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.colors.primary,
                                foregroundColor: context.colors.onPrimary,
                              ),
                              child: const Text('Mark Installed'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await ref.read(pigtailStateProvider.notifier)
                            .markAsInstalled(pigtail.id, pigtail);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Pigtail marked as installed"),
                              backgroundColor: context.colors.success,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.success,
                      foregroundColor: context.colors.onPrimary,
                    ),
                  ),
                SizedBox(height: context.dimensions.spacingS),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          final screenWidth = MediaQuery.of(context).size.width;
                          final screenHeight = MediaQuery.of(context).size.height;
                          final isMobile = context.isMobile;
                          
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              insetPadding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 16 : 40,
                                vertical: isMobile ? 24 : 40,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isMobile ? screenWidth - 32 : 550,
                                  maxHeight: isMobile ? screenHeight - 48 : screenHeight * 0.9,
                                ),
                                child: _EditPigtailDialog(
                                  pigtail: pigtail,
                                  ref: ref,
                                ),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.onPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: context.dimensions.spacingS),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Delete"),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Delete Pigtail?'),
                              content: Text('Are you sure you want to permanently delete this pigtail record at ${pigtail.jobName}? This action cannot be undone.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: context.colors.error,
                                    foregroundColor: context.colors.onError,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            Navigator.of(context).pop();
                            await ref.read(pigtailStateProvider.notifier).delete(pigtail.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Pigtail deleted successfully'),
                                  backgroundColor: context.colors.success,
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.error,
                          foregroundColor: context.colors.onError,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
