import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../components/keyword_chip.dart';
import '../../components/processing_badge.dart';
import '../../components/cluster_chip.dart';
import '../../components/ai_summary_card.dart';
import '../../components/related_note_card.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../home/home_notifier.dart';
import 'note_detail_notifier.dart';

class NoteDetailScreen extends ConsumerWidget {
  const NoteDetailScreen({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteDetailProvider(noteId));
    final clustersAsync = ref.watch(clustersStreamProvider);
    final clusters = clustersAsync.asData?.value ?? [];
    final clusterMap = {for (final c in clusters) c.id: c};

    return noteAsync.when(
      data: (note) {
        if (note == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Note not found')),
          );
        }

        final cluster =
            note.clusterId != null ? clusterMap[note.clusterId!] : null;
        final relatedAsync =
            ref.watch(relatedNotesProvider(note.relatedNoteIds));

        // Format date/time
        final dateFormat = DateFormat('MMMM d, yyyy • h:mm a');

        // Extract body by stripping the first line title if it exists
        String displayContent = note.content;
        final lines = note.content.split('\n');
        if (lines.isNotEmpty && lines.first.trim() == note.title.replaceAll('…', '')) {
          if (lines.length > 1) {
            displayContent = lines.sublist(1).join('\n').trimLeft();
          }
        }
        if (displayContent.trim().isEmpty) {
          displayContent = note.content;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: AppColors.textPrimary),
                tooltip: 'Edit Note',
                onPressed: () => context.push(AppRoutes.editor, extra: note.id),
              ),
              if (cluster != null)
                IconButton(
                  icon: const Icon(Icons.hub_outlined, color: AppColors.textPrimary),
                  tooltip: 'View in Topic Graph',
                  onPressed: () => context.push('/topics/${cluster.id}', extra: cluster.name),
                ),
              const SizedBox(width: 4),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date & Time
                Text(
                  dateFormat.format(note.createdAt),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),

                // Note Title
                Text(
                  note.title,
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 12),

                // Cluster Chip & Status Badge Row
                Row(
                  children: [
                    if (cluster != null) ...[
                      ClusterChip(
                        name: cluster.name,
                        colorHex: cluster.colorHex,
                      ),
                      const SizedBox(width: 8),
                    ],
                    ProcessingBadge(status: note.status),
                  ],
                ),
                const SizedBox(height: 20),

                // Note Content Text
                SelectableText(
                  displayContent,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // AI Summary Card
                if (note.summary != null && note.summary!.isNotEmpty) ...[
                  AISummaryCard(summary: note.summary!),
                  const SizedBox(height: 24),
                ],

                // Keywords Section
                if (note.keywords.isNotEmpty) ...[
                  Text(
                    'Keywords',
                    style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...note.keywords.map((k) => KeywordChip(label: k)),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Related Notes Section
                Text(
                  'Related Notes',
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),

                relatedAsync.when(
                  data: (relatedNotes) {
                    if (relatedNotes.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No related notes discovered yet.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: relatedNotes.map((rNote) {
                        return RelatedNoteCard(
                          note: rNote,
                          onTap: () => context.push('/detail/${rNote.id}'),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.accentGreen),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
