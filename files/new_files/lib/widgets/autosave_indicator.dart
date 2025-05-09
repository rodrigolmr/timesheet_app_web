// lib/widgets/autosave_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/timesheet_provider.dart';

class AutosaveIndicator extends ConsumerWidget {
  const AutosaveIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autosaveState = ref.watch(autosaveStateProvider);

    // Se estiver em idle, não mostra nada
    if (autosaveState == AutosaveState.idle) {
      return const SizedBox.shrink();
    }

    Color backgroundColor;
    Color textColor = Colors.white;
    String message;
    IconData icon;

    switch (autosaveState) {
      case AutosaveState.saving:
        backgroundColor = Colors.blue[700]!;
        message = "Saving draft...";
        icon = Icons.save;
        break;
      case AutosaveState.saved:
        backgroundColor = Colors.green[700]!;
        message = "Draft saved";
        icon = Icons.check_circle;
        break;
      case AutosaveState.error:
        backgroundColor = Colors.red[700]!;
        message = "Error saving draft";
        icon = Icons.error_outline;
        break;
      default:
        return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: autosaveState == AutosaveState.idle ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            autosaveState == AutosaveState.saving
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(textColor),
                    ),
                  )
                : Icon(icon, color: textColor, size: 16),
            const SizedBox(width: 8),
            Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}