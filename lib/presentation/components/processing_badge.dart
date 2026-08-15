import 'package:flutter/material.dart';
import '../../domain/entities/processing_status.dart';
import '../theme/app_colors.dart';

class ProcessingBadge extends StatelessWidget {
  const ProcessingBadge({super.key, required this.status});

  final ProcessingStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ProcessingStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.accentGreenLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_rounded, size: 13, color: AppColors.accentGreenDark),
              SizedBox(width: 3),
              Text(
                'Done',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentGreenDark,
                ),
              ),
            ],
          ),
        );

      case ProcessingStatus.processing:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.clusterIdeasBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.clusterIdeas),
                ),
              ),
              SizedBox(width: 5),
              Text(
                'Processing',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.clusterIdeas,
                ),
              ),
            ],
          ),
        );

      case ProcessingStatus.pending:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Pending',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        );

      case ProcessingStatus.needsUserClarification:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.electricViolet.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline_rounded, size: 13, color: AppColors.electricViolet),
              SizedBox(width: 3),
              Text(
                'Clarification',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.electricViolet,
                ),
              ),
            ],
          ),
        );

      case ProcessingStatus.failed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFFEE2E2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 13, color: AppColors.error),
              SizedBox(width: 3),
              Text(
                'Failed',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        );
    }
  }
}
