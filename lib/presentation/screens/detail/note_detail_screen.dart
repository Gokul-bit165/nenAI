import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../components/keyword_chip.dart';
import '../../components/processing_badge.dart';
import '../../components/cluster_chip.dart';
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
            appBar: AppBar(),
            body: const Center(child: Text('Note not found')),
          );
        }

        final cluster = note.clusterId != null ? clusterMap[note.clusterId!] : null;
        final relatedAsync = ref.watch(relatedNotesProvider(note.relatedNoteIds));

        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push(AppRoutes.editor, extra: note.id),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMMM d, yyyy • h:mm a').format(note.createdAt),
                      style: AppTextStyles.labelSmall,
                    ),
                    ProcessingBadge(status: note.status),
                  ],
                ),
                const SizedBox(height: 12),

                // Note title
                Text(note.title, style: AppTextStyles.headlineLarge),
                const SizedBox(height: 16),

                // Cluster chip if assigned
                if (cluster != null) ...[
                  ClusterChip(name: cluster.name, colorHex: cluster.colorHex),
                  const SizedBox(height: 16),
                ],

                // Full note content
                SelectableText(
                  note.content,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 24),
                const Divider(color: AppColors.border),
                const SizedBox(height: 16),

                // AI Summary Card
                if (note.summary != null && note.summary!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.auto_awesome, size: 18, color: AppColors.primaryLight),
                            SizedBox(width: 8),
                            Text(
                              'AI Summary',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(note.summary!, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // AI Keywords
                if (note.keywords.isNotEmpty) ...[
                  Text('Keywords', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: note.keywords.map((k) => KeywordChip(label: k)).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // Related Notes Section
                Text('Related Notes', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),

                relatedAsync.when(
                  data: (relatedNotes) {
                    if (relatedNotes.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'No related notes discovered yet.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                        ),
                      );
                    }

                    return Column(
                      children: relatedNotes.map((rNote) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            onTap: () => context.push('/detail/${rNote.id}'),
                            title: Text(rNote.title, style: AppTextStyles.titleMedium.copyWith(fontSize: 15)),
                            subtitle: Text(
                              rNote.summary ?? rNote.snippet,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium,
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                          ),
                        );
                      }).toList(),
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $err')),
      ),
    );
  }
}
