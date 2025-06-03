import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/job_record/presentation/widgets/notification_dropdown.dart';

class NotificationBadge extends ConsumerStatefulWidget {
  const NotificationBadge({super.key});

  @override
  ConsumerState<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends ConsumerState<NotificationBadge> {
  final _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpen = false;

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    final RenderBox renderBox = _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        // Get screen dimensions
        final screenWidth = MediaQuery.of(context).size.width;
        const dropdownWidth = 300.0;
        const padding = 16.0;
        
        // Calculate the ideal left position (align with right edge of button)
        double idealLeft = offset.dx + size.width - dropdownWidth;
        
        // Ensure dropdown doesn't go off left edge
        if (idealLeft < padding) {
          idealLeft = padding;
        }
        
        // Ensure dropdown doesn't go off right edge
        if (idealLeft + dropdownWidth > screenWidth - padding) {
          idealLeft = screenWidth - dropdownWidth - padding;
        }
        
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeDropdown,
          child: Stack(
            children: [
              Positioned(
                left: idealLeft,
                top: offset.dy + size.height + 8,
                child: NotificationDropdown(
                  onClose: _closeDropdown,
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {
      _isDropdownOpen = false;
    });
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = ref.watch(pendingJobRecordsCountProvider);
    
    return IconButton(
      key: _dropdownKey,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            _isDropdownOpen ? Icons.notifications : Icons.notifications_outlined,
            color: pendingCount > 0 ? context.colors.warning : null,
          ),
          if (pendingCount > 0)
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: context.colors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Text(
                  pendingCount > 99 ? '99+' : pendingCount.toString(),
                  style: TextStyle(
                    color: context.colors.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      onPressed: _toggleDropdown,
      tooltip: pendingCount > 0 
          ? '$pendingCount pending approval${pendingCount > 1 ? 's' : ''}' 
          : 'Notifications',
    );
  }
}