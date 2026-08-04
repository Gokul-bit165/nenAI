import 'package:flutter/material.dart';
import '../../domain/entities/processing_status.dart';
import '../theme/app_colors.dart';

class ProcessingBadge extends StatelessWidget {
  const ProcessingBadge({super.key, required this.status});

  final ProcessingStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ProcessingStatus.pending:
      case ProcessingStatus.processing:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'AI Processing...',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryLight.withOpacity(0.9),
              ),
            ),
          ],
        );
      case ProcessingStatus.completed:
        return const SizedBox.shrink();
      case ProcessingStatus.failed:
        return const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
            SizedBox(width: 4),
            Text(
              'Plain Text Saved',
              style: TextStyle(fontSize: 12, color: AppColors.warning),
            ),
          ],
        );
    }
  }
}
