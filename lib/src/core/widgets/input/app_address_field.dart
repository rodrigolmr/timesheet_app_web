import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/core/widgets/input/app_text_field.dart';
import 'package:timesheet_app_web/src/core/services/google_places_service.dart';

/// A reusable address input field with Google Places autocomplete
class AppAddressField extends ConsumerStatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSelected;
  final bool enabled;
  final bool hasError;
  final String? errorText;
  final FocusNode? focusNode;
  final VoidCallback? onClearError;
  final bool isRequired;
  final String? Function(String?)? validator;
  final List<String>? existingAddresses;
  final int minCharacters;
  final int maxSuggestions;

  const AppAddressField({
    super.key,
    required this.label,
    this.hintText = 'Enter address',
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onSelected,
    this.enabled = true,
    this.hasError = false,
    this.errorText,
    this.focusNode,
    this.onClearError,
    this.isRequired = false,
    this.validator,
    this.existingAddresses,
    this.minCharacters = 3,
    this.maxSuggestions = 15,
  });

  @override
  ConsumerState<AppAddressField> createState() => _AppAddressFieldState();
}

class _AppAddressFieldState extends ConsumerState<AppAddressField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final _overlayController = OverlayPortalController();
  String _currentQuery = '';
  List<String> _existingSuggestions = [];
  List<String> _googleSuggestions = [];
  bool _isLoading = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  List<String> get _allSuggestions {
    // Combine existing and Google suggestions, with existing first
    final combined = [..._existingSuggestions, ..._googleSuggestions];
    // Remove duplicates while preserving order
    final seen = <String>{};
    return combined.where((address) => seen.add(address.toLowerCase())).toList();
  }

  void _onTextChanged() {
    final query = _controller.text;
    if (query != _currentQuery) {
      _currentQuery = query;
      _selectedIndex = -1;
      _fetchSuggestions();
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) {
      // Small delay to allow click events to register
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted && !_focusNode.hasFocus) {
          _overlayController.hide();
        }
      });
    } else if (_allSuggestions.isNotEmpty) {
      _overlayController.show();
    }
  }

  Future<void> _fetchSuggestions() async {
    if (_currentQuery.length < widget.minCharacters) {
      setState(() {
        _existingSuggestions = [];
        _googleSuggestions = [];
        _isLoading = false;
        _selectedIndex = -1;
      });
      _overlayController.hide();
      return;
    }

    // First, filter existing addresses
    if (widget.existingAddresses != null) {
      final query = _currentQuery.toLowerCase();
      _existingSuggestions = widget.existingAddresses!
          .where((address) => address.toLowerCase().contains(query))
          .take(5) // Limit existing suggestions
          .toList();
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final suggestions = await ref.read(addressSuggestionsProvider(_currentQuery).future);
      
      if (mounted && _currentQuery == _controller.text) {
        setState(() {
          _googleSuggestions = suggestions.take(10).toList(); // Limit Google suggestions
          _isLoading = false;
        });
        
        if (_allSuggestions.isNotEmpty) {
          _overlayController.show();
        } else {
          _overlayController.hide();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _googleSuggestions = [];
          _isLoading = false;
        });
      }
    }
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    widget.onSelected?.call(suggestion);
    widget.onChanged?.call(suggestion);
    
    // Reset session token when address is selected
    ref.read(googlePlacesServiceProvider).resetSessionToken();
    
    if (widget.hasError && widget.onClearError != null) {
      widget.onClearError!();
    }
    
    _overlayController.hide();
    _focusNode.unfocus();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is RawKeyDownEvent) {
      final suggestions = _allSuggestions;
      if (suggestions.isEmpty) return;

      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        setState(() {
          _selectedIndex = (_selectedIndex + 1) % suggestions.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        setState(() {
          _selectedIndex = (_selectedIndex - 1 + suggestions.length) % suggestions.length;
        });
      } else if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_selectedIndex >= 0 && _selectedIndex < suggestions.length) {
          _selectSuggestion(suggestions[_selectedIndex]);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.escape) {
        _overlayController.hide();
        _selectedIndex = -1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: _handleKeyEvent,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (BuildContext context) {
          final suggestions = _allSuggestions.take(widget.maxSuggestions).toList();
          final visibleCount = suggestions.length > 6 ? 6 : suggestions.length;
          
          return Positioned(
            left: 0,
            right: 0,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 60),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: visibleCount * 48.0 + (_isLoading ? 48.0 : 0),
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
                    border: Border.all(color: context.colors.outline),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading)
                        Container(
                          height: 48,
                          padding: EdgeInsets.all(context.dimensions.spacingM),
                          child: Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: context.colors.primary,
                              ),
                            ),
                          ),
                        ),
                      if (suggestions.isEmpty && !_isLoading)
                        Container(
                          padding: EdgeInsets.all(context.dimensions.spacingM),
                          child: Text(
                            'No suggestions found',
                            style: context.textStyles.body.copyWith(
                              color: context.colors.textSecondary,
                            ),
                          ),
                        )
                      else
                        Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = suggestions[index];
                              final isExisting = widget.existingAddresses?.any(
                                (addr) => addr.toLowerCase() == suggestion.toLowerCase()
                              ) ?? false;
                              final isSelected = index == _selectedIndex;
                              
                              return InkWell(
                                onTap: () => _selectSuggestion(suggestion),
                                child: Container(
                                  height: 48,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.dimensions.spacingM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                      ? context.colors.primary.withOpacity(0.1)
                                      : Colors.transparent,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: context.colors.outline.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isExisting 
                                          ? Icons.history
                                          : Icons.location_on_outlined,
                                        size: 20,
                                        color: isExisting
                                          ? context.colors.primary
                                          : context.colors.textSecondary,
                                      ),
                                      SizedBox(width: context.dimensions.spacingS),
                                      Expanded(
                                        child: Text(
                                          suggestion,
                                          style: context.textStyles.body.copyWith(
                                            fontSize: 14,
                                            fontWeight: isExisting 
                                              ? FontWeight.w500 
                                              : FontWeight.normal,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        child: CompositedTransformTarget(
          link: _layerLink,
          child: AppTextField(
            controller: _controller,
            focusNode: _focusNode,
            label: widget.label,
            hintText: widget.hintText,
            hasError: widget.hasError,
            errorText: widget.errorText,
            enabled: widget.enabled,
            onClearError: widget.onClearError,
            onChanged: widget.onChanged,
            prefixIcon: Icon(
              Icons.location_on_outlined,
              size: 20,
              color: context.colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  final _layerLink = LayerLink();
}