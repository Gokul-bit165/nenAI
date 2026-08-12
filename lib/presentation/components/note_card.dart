import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/note.dart';
import '../../domain/entities/cluster.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'processing_badge.dart';
import 'cluster_chip.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.cluster,
    required this.onTap,
  });

  final Note note;
  final Cluster? cluster;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Date/Time Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: AppTextStyles.titleMedium.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(note.createdAt),
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),

                // Note snippet / summary
                Text(
                  note.summary?.isNotEmpty == true
                      ? note.summary!
                      : note.snippet,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Footer Row: Cluster chip and Processing badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (cluster != null)
                      ClusterChip(
                        name: cluster!.name,
                        colorHex: cluster!.colorHex,
                      )
                    else
                      const SizedBox.shrink(),
                    ProcessingBadge(status: note.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
