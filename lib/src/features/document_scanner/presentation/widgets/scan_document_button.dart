import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/navigation/routes.dart';

class ScanDocumentButton extends ConsumerWidget {
  final VoidCallback? onScanned;
  final String label;
  final IconData icon;
  final bool outlined;

  const ScanDocumentButton({
    super.key,
    this.onScanned,
    this.label = 'Scan Document',
    this.icon = Icons.document_scanner,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: () => _openScanner(context),
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colors.primary,
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.spacingL,
            vertical: context.dimensions.spacingM,
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () => _openScanner(context),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        padding: EdgeInsets.symmetric(
          horizontal: context.dimensions.spacingL,
          vertical: context.dimensions.spacingM,
        ),
      ),
    );
  }

  void _openScanner(BuildContext context) {
    context.push(AppRoute.documentScanner.path).then((result) {
      if (result != null && onScanned != null) {
        onScanned!();
      }
    });
  }
}