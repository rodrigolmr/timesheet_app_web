import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/app_header.dart';
import 'package:timesheet_app_web/src/core/widgets/input/input.dart';
import 'package:timesheet_app_web/src/core/responsive/responsive.dart';
import 'package:timesheet_app_web/src/features/company_card/presentation/providers/company_card_providers.dart';
import 'package:timesheet_app_web/src/features/company_card/data/models/company_card_model.dart';
import 'package:timesheet_app_web/src/features/expense/data/models/expense_model.dart';
import 'package:timesheet_app_web/src/features/expense/presentation/providers/expense_providers.dart';
import 'package:timesheet_app_web/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/widgets/static_loading_indicator.dart';

class ExpenseInfoScreen extends ConsumerStatefulWidget {
  final Uint8List imageData;

  const ExpenseInfoScreen({
    super.key,
    required this.imageData,
  });

  @override
  ConsumerState<ExpenseInfoScreen> createState() => _ExpenseInfoScreenState();
}

class _ExpenseInfoScreenState extends ConsumerState<ExpenseInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  
  String? _selectedCardId;
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _cardError;
  String? _dateError;
  String? _amountError;
  String? _descriptionError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _saveExpense() async {
    // Validate fields manually
    bool hasErrors = false;
    
    if (_selectedCardId == null) {
      setState(() => _cardError = 'Please select a card');
      hasErrors = true;
    }
    
    if (_amountController.text.isEmpty) {
      setState(() => _amountError = 'Amount is required');
      hasErrors = true;
    } else {
      final amount = double.tryParse(_amountController.text);
      if (amount == null || amount <= 0) {
        setState(() => _amountError = 'Enter a valid amount');
        hasErrors = true;
      }
    }
    
    if (_descriptionController.text.isEmpty) {
      setState(() => _descriptionError = 'Description is required');
      hasErrors = true;
    } else if (_descriptionController.text.length < 10) {
      setState(() => _descriptionError = 'Description must be at least 10 characters');
      hasErrors = true;
    }
    
    if (_selectedDate == null) {
      setState(() => _dateError = 'Please select a purchase date');
      hasErrors = true;
    }
    
    if (hasErrors) return;

    setState(() => _isLoading = true);

    try {
      // Get current user
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) throw Exception('User not authenticated');

      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('receipts')
          .child('${DateTime.now().millisecondsSinceEpoch}_${currentUser.uid}.jpg');
      
      final uploadTask = await storageRef.putData(widget.imageData);
      final imageUrl = await uploadTask.ref.getDownloadURL();

      // Create expense
      final expense = ExpenseModel(
        id: '',
        userId: currentUser.uid,
        cardId: _selectedCardId!,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        description: _descriptionController.text,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await ref.read(expenseRepositoryProvider).create(expense);

      if (mounted) {
        setState(() => _isLoading = false);
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Expense saved successfully'),
            backgroundColor: context.colors.success,
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to expenses screen
        context.go('/expenses');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving expense: $e'),
            backgroundColor: context.colors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardsAsync = ref.watch(companyCardsStreamProvider);

    return StaticLoadingOverlay(
      isVisible: _isLoading,
      message: 'Saving expense...',
      child: Scaffold(
        backgroundColor: context.colors.background,
        appBar: AppHeader(
          title: 'Receipt Information',
          showBackButton: true,
        ),
        body: SingleChildScrollView(
        child: ResponsiveContainer(
          child: Padding(
            padding: context.dimensions.padding,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Card selection
                  cardsAsync.when(
                    data: (cards) {
                      final activeCards = cards.where((card) => card.isActive).toList();
                      return AppDropdownField<CompanyCardModel>(
                        label: 'Card Used',
                        hintText: 'Select the card',
                        value: activeCards.firstWhereOrNull((card) => card.id == _selectedCardId),
                        items: activeCards,
                        itemLabelBuilder: (card) => '${card.holderName} - ****${card.lastFourDigits}',
                        onChanged: (card) => setState(() => _selectedCardId = card?.id),
                        hasError: _cardError != null,
                        errorText: _cardError,
                      );
                    },
                    loading: () => const Center(child: StaticLoadingIndicator()),
                    error: (e, _) => Text(
                      'Error loading cards: $e',
                      style: TextStyle(color: context.colors.error),
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacingM),

                  // Purchase date
                  AppDatePickerField(
                    label: 'Purchase Date',
                    hintText: 'When was this purchase made?',
                    controller: _dateController,
                    initialDate: _selectedDate,
                    onDateSelected: (date) {
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                          _dateError = null;
                        });
                      }
                    },
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                    hasError: _dateError != null,
                    errorText: _dateError,
                  ),
                  SizedBox(height: context.dimensions.spacingM),

                  // Amount
                  AppTextField(
                    controller: _amountController,
                    label: 'Amount',
                    hintText: 'Enter the purchase amount',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    prefixText: '\$ ',
                    hasError: _amountError != null,
                    errorText: _amountError,
                    onChanged: (value) {
                      setState(() => _amountError = null);
                    },
                  ),
                  SizedBox(height: context.dimensions.spacingM),

                  // Description
                  AppMultilineTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hintText: 'Brief description of the purchase',
                    maxLines: 3,
                    hasError: _descriptionError != null,
                    errorText: _descriptionError,
                    onChanged: (value) {
                      setState(() => _descriptionError = null);
                    },
                  ),
                  SizedBox(height: context.dimensions.spacingXL),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: _isLoading ? null : () => context.pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: context.dimensions.spacingM),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveExpense,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.colors.primary,
                            foregroundColor: context.colors.onPrimary,
                            padding: EdgeInsets.symmetric(
                              vertical: context.dimensions.spacingM,
                            ),
                          ),
                          child: _isLoading
                              ? const StaticLoadingIndicator(
                                  size: 20,
                                  color: Colors.white,
                                )
                              : const Text('Save Expense'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.dimensions.spacingXL),

                  // Receipt preview
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                      border: Border.all(
                        color: context.colors.outline,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                      child: Image.memory(
                        widget.imageData,
                        fit: BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  SizedBox(height: context.dimensions.spacingXL),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}