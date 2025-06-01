import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_search_providers.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_text_field.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive_grid.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/widgets/company_card_filters.dart';
import 'package:timesheet_app_web/src/core/widgets/dialogs/dialogs.dart';

class CompanyCardsScreen extends ConsumerStatefulWidget {
  const CompanyCardsScreen({super.key});

  @override
  ConsumerState<CompanyCardsScreen> createState() => _CompanyCardsScreenState();
}

class _CompanyCardsScreenState extends ConsumerState<CompanyCardsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'all';
  bool _filtersExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(companyCardsStreamProvider);
    
    return Scaffold(
      appBar: AppHeader(
        title: 'Company Cards',
        subtitle: 'Manage company credit cards',
        actionIcon: Icons.add,
        onActionPressed: () => _showCreateDialog(context),
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: cardsAsync.when(
              data: (cards) => _buildCardList(context, cards),
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
                      'Error loading company cards',
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
    return CompanyCardFilters(
      searchController: _searchController,
      searchQuery: _searchQuery,
      selectedStatus: _selectedStatus,
      filtersExpanded: _filtersExpanded,
      onSearchChanged: (query) {
        setState(() {
          _searchQuery = query.trim();
        });
        ref.read(companyCardSearchQueryProvider.notifier).updateQuery(query);
      },
      onStatusChanged: (status) {
        setState(() {
          _selectedStatus = status;
        });
        // Update the provider based on status
        if (status == 'active') {
          ref.read(companyCardSearchFiltersProvider.notifier).updateActiveStatus(true);
        } else if (status == 'inactive') {
          ref.read(companyCardSearchFiltersProvider.notifier).updateActiveStatus(false);
        } else {
          ref.read(companyCardSearchFiltersProvider.notifier).updateActiveStatus(null);
        }
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
    });
    ref.read(companyCardSearchQueryProvider.notifier).updateQuery('');
    ref.read(companyCardSearchFiltersProvider.notifier).updateActiveStatus(null);
  }

  Widget _buildCardList(BuildContext context, List<CompanyCardModel> allCards) {
    final searchResults = ref.watch(companyCardSearchResultsProvider);
    final cards = searchResults.isEmpty && _searchController.text.isEmpty && _selectedStatus == 'all'
        ? allCards
        : searchResults;
    
    if (cards.isEmpty) {
      return _buildEmptyState(context);
    }

    final isMobile = context.isMobile;
    
    if (isMobile) {
      return ListView.builder(
        padding: EdgeInsets.all(context.dimensions.spacingM),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          return _buildCompanyCard(context, card);
        },
      );
    }

    return Padding(
      padding: EdgeInsets.all(context.dimensions.spacingL),
      child: ResponsiveGrid(
        spacing: context.dimensions.spacingM,
        xsColumns: 1,
        smColumns: 2,
        mdColumns: 3,
        lgColumns: 4,
        children: cards.map((card) => 
          _buildCompanyCard(context, card)
        ).toList(),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, CompanyCardModel card) {
    return Card(
      margin: EdgeInsets.only(bottom: context.responsive<double>(xs: 6, sm: 8, md: 10)),
      child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.responsive<double>(xs: 12, sm: 14, md: 16),
            vertical: context.responsive<double>(xs: 8, sm: 10, md: 12),
          ),
          child: Row(
            children: [
              Container(
                width: context.responsive<double>(xs: 40, sm: 44, md: 48),
                height: context.responsive<double>(xs: 30, sm: 33, md: 36),
                decoration: BoxDecoration(
                  color: card.isActive 
                      ? context.colors.primary.withOpacity(0.1)
                      : context.colors.textSecondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: card.isActive 
                        ? context.colors.primary.withOpacity(0.3)
                        : context.colors.textSecondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.credit_card,
                  size: context.responsive<double>(xs: 18, sm: 20, md: 22),
                  color: card.isActive 
                      ? context.colors.primary 
                      : context.colors.textSecondary,
                ),
              ),
              SizedBox(width: context.responsive<double>(xs: 10, sm: 12, md: 14)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      card.holderName,
                      style: context.textStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: context.responsive<double>(xs: 14, sm: 15, md: 16),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '**** **** **** ${card.lastFourDigits}',
                      style: context.textStyles.caption.copyWith(
                        color: context.colors.textSecondary,
                        fontSize: context.responsive<double>(xs: 11, sm: 12, md: 13),
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.responsive<double>(xs: 6, sm: 7, md: 8),
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: card.isActive
                            ? context.colors.success.withOpacity(0.1)
                            : context.colors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        card.isActive ? 'Active' : 'Inactive',
                        style: context.textStyles.caption.copyWith(
                          color: card.isActive
                              ? context.colors.success
                              : context.colors.error,
                          fontWeight: FontWeight.w600,
                          fontSize: context.responsive<double>(xs: 10, sm: 11, md: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: context.responsive<double>(xs: 18, sm: 20, md: 22),
                ),
                onPressed: () => _showEditDialog(context, card),
                tooltip: 'Edit card',
                padding: const EdgeInsets.all(4),
                constraints: BoxConstraints(
                  minWidth: context.responsive<double>(xs: 32, sm: 36, md: 40),
                  minHeight: context.responsive<double>(xs: 32, sm: 36, md: 40),
                ),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final hasFilters = _searchController.text.isNotEmpty || _selectedStatus != 'all';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            hasFilters ? Icons.search_off : Icons.credit_card_off,
            size: 120,
            color: context.colors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 24),
          Text(
            hasFilters ? 'No cards found' : 'No company cards yet',
            style: context.textStyles.title.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters 
                ? 'Try adjusting your search or filters'
                : 'Start by adding your first company card',
            style: context.textStyles.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          if (!hasFilters)
            ElevatedButton.icon(
              onPressed: () => _showCreateDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Add Company Card'),
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

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _CreateCompanyCardDialog(ref: ref),
    );
  }

  void _showEditDialog(BuildContext context, CompanyCardModel card) {
    showDialog(
      context: context,
      builder: (_) => _EditCompanyCardDialog(card: card, ref: ref),
    );
  }
}

class _CreateCompanyCardDialog extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _CreateCompanyCardDialog({required this.ref});

  @override
  ConsumerState<_CreateCompanyCardDialog> createState() => _CreateCompanyCardDialogState();
}

class _CreateCompanyCardDialogState extends ConsumerState<_CreateCompanyCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _holderNameController = TextEditingController();
  final _lastFourDigitsController = TextEditingController();
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _holderNameController.dispose();
    _lastFourDigitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Add Company Card',
      icon: Icons.credit_card,
      mode: DialogMode.create,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _holderNameController,
              label: 'Card Holder Name',
              hintText: 'Enter cardholder name',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppTextField(
              controller: _lastFourDigitsController,
              label: 'Last 4 Digits',
              hintText: 'Enter last 4 digits',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: context.dimensions.spacingM),
            CheckboxListTile(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value!),
              title: const Text('Active'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.create,
          onConfirm: _handleSubmit,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_holderNameController.text.trim().isEmpty ||
        _lastFourDigitsController.text.trim().isEmpty ||
        _lastFourDigitsController.text.trim().length != 4) {
      await showWarningDialog(
        context: context,
        title: 'Invalid Information',
        message: 'Please fill in all fields correctly. Last 4 digits must be exactly 4 numbers.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final card = CompanyCardModel(
        id: '',
        holderName: _holderNameController.text.trim(),
        lastFourDigits: _lastFourDigitsController.text.trim(),
        isActive: _isActive,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(companyCardRepositoryProvider).create(card);

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Company card added successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to add company card: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _EditCompanyCardDialog extends StatefulWidget {
  final CompanyCardModel card;
  final WidgetRef ref;

  const _EditCompanyCardDialog({
    required this.card,
    required this.ref,
  });

  @override
  State<_EditCompanyCardDialog> createState() => _EditCompanyCardDialogState();
}

class _EditCompanyCardDialogState extends State<_EditCompanyCardDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _holderNameController;
  late final TextEditingController _lastFourDigitsController;
  late bool _isActive;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _holderNameController = TextEditingController(text: widget.card.holderName);
    _lastFourDigitsController = TextEditingController(text: widget.card.lastFourDigits);
    _isActive = widget.card.isActive;
  }

  @override
  void dispose() {
    _holderNameController.dispose();
    _lastFourDigitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFormDialog(
      title: 'Edit Company Card',
      icon: Icons.edit,
      mode: DialogMode.edit,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _holderNameController,
              label: 'Card Holder Name',
              hintText: 'Enter cardholder name',
            ),
            SizedBox(height: context.dimensions.spacingM),
            AppTextField(
              controller: _lastFourDigitsController,
              label: 'Last 4 Digits',
              hintText: 'Enter last 4 digits',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: context.dimensions.spacingM),
            CheckboxListTile(
              value: _isActive,
              onChanged: (value) => setState(() => _isActive = value!),
              title: const Text('Active'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        AppFormDialogActions(
          isLoading: _isLoading,
          mode: DialogMode.edit,
          onConfirm: _handleSubmit,
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (_holderNameController.text.trim().isEmpty ||
        _lastFourDigitsController.text.trim().isEmpty ||
        _lastFourDigitsController.text.trim().length != 4) {
      await showWarningDialog(
        context: context,
        title: 'Invalid Information',
        message: 'Please fill in all fields correctly. Last 4 digits must be exactly 4 numbers.',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedCard = widget.card.copyWith(
        holderName: _holderNameController.text.trim(),
        lastFourDigits: _lastFourDigitsController.text.trim(),
        isActive: _isActive,
        updatedAt: DateTime.now(),
      );

      await widget.ref.read(companyCardRepositoryProvider).update(
        widget.card.id,
        updatedCard,
      );

      if (mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(
          context: context,
          title: 'Success',
          message: 'Company card updated successfully.',
        );
      }
    } catch (e) {
      if (mounted) {
        await showErrorDialog(
          context: context,
          title: 'Error',
          message: 'Failed to update company card: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}