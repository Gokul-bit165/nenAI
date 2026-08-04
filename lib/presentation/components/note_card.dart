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
    final dateFormat = DateFormat('MMM d, h:mm a');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    dateFormat.format(note.createdAt),
                    style: AppTextStyles.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (note.summary != null && note.summary!.isNotEmpty)
                Text(
                  note.summary!,
                  style: AppTextStyles.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              else
                Text(
                  note.snippet,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: 12),
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
    );
  }
}
