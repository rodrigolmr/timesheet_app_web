import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timesheet_app_web/src/core/theme/theme_extensions.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/providers/notification_providers.dart';
import 'package:timesheet_app_web/src/features/notifications/presentation/widgets/notification_dropdown.dart';

class NotificationIconButton extends ConsumerStatefulWidget {
  const NotificationIconButton({super.key});

  @override
  ConsumerState<NotificationIconButton> createState() => _NotificationIconButtonState();
}

class _NotificationIconButtonState extends ConsumerState<NotificationIconButton> {
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
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _closeDropdown,
        child: Stack(
          children: [
            Positioned(
              left: offset.dx - 300 + size.width, // Align to right edge
              top: offset.dy + size.height + 8,
              child: NotificationDropdownWidget(
                onClose: _closeDropdown,
                onNotificationTap: (notification) {
                  _closeDropdown();
                  // Navigate based on notification data
                  if (notification.data?['route'] != null) {
                    context.go(notification.data!['route']);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });

    // Mark all as read when opening
    ref.read(notificationStateProvider.notifier).markAllAsRead();
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _isDropdownOpen = false;
      });
    }
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          key: _dropdownKey,
          icon: Icon(
            _isDropdownOpen ? Icons.notifications : Icons.notifications_outlined,
            // Sempre usar a cor herdada do AppBar (foregroundColor)
            color: null,
          ),
          onPressed: _toggleDropdown,
          tooltip: unreadCount > 0 
              ? '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}' 
              : 'Notifications',
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: context.colors.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: TextStyle(
                      color: context.colors.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}