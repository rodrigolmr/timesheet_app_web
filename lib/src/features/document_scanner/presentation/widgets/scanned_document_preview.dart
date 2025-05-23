import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../../../core/theme/theme_extensions.dart';

class ScannedDocumentPreview extends StatelessWidget {
  final Uint8List imageData;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ScannedDocumentPreview({
    super.key,
    required this.imageData,
    this.onRemove,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 200,
        height: height ?? 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          border: Border.all(
            color: context.colors.divider,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.dimensions.borderRadiusM),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(
                imageData,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: context.colors.surface,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: context.colors.error,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load image',
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.error,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (onRemove != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}