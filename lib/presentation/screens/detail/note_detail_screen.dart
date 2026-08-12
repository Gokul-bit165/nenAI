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

        final cluster = note.clusterId != null ? clusterMap[note.clusterId!] : null;
        final relatedAsync = ref.watch(relatedNotesProvider(note.relatedNoteIds));
        final entitiesAsync = ref.watch(noteEntitiesProvider(note.id));
        final relationshipsAsync = ref.watch(noteRelationshipsProvider(note.id));
        final tasksAsync = ref.watch(noteTasksProvider(note.id));

        // Format date/time
        final dateFormat = DateFormat('MMMM d, yyyy • h:mm a');

        // Extract body
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

                // Original Raw Content
                SelectableText(
                  displayContent,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // ── What NENAI Understood ─────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_rounded, size: 20, color: Color(0xFF7C3AED)),
                          const SizedBox(width: 8),
                          Text(
                            'What NENAI Understood',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E293B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Entities Breakdown
                      entitiesAsync.when(
                        data: (entities) {
                          if (entities.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ENTITIES & CONCEPTS',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: entities.map((e) {
                                  IconData icon = Icons.lightbulb_outline;
                                  Color chipColor = const Color(0xFF64748B);
                                  if (e.type == 'person') {
                                    icon = Icons.person_outline;
                                    chipColor = const Color(0xFF2563EB);
                                  } else if (e.type == 'project') {
                                    icon = Icons.rocket_launch_outlined;
                                    chipColor = const Color(0xFF7C3AED);
                                  } else if (e.type == 'technology') {
                                    icon = Icons.memory_outlined;
                                    chipColor = const Color(0xFF0D9488);
                                  }

                                  return Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: chipColor.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: chipColor.withOpacity(0.2)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(icon, size: 14, color: chipColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          e.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: chipColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 14),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      // Relationships Breakdown
                      relationshipsAsync.when(
                        data: (rels) {
                          if (rels.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'KNOWLEDGE GRAPH CONNECTIONS',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...rels.map((r) => Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          r.sourceName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFFEDE9FE),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  r.relation,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF7C3AED),
                                                  ),
                                                ),
                                              ),
                                              const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF7C3AED)),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          r.targetName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: Color(0xFF1E293B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(height: 14),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),

                      // Tasks Breakdown
                      tasksAsync.when(
                        data: (tasks) {
                          if (tasks.isEmpty) return const SizedBox.shrink();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ACTION ITEMS & TASKS',
                                style: AppTextStyles.labelSmall.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...tasks.map((t) => Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: const Color(0xFFE2E8F0)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF10B981)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            t.description,
                                            style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                                          ),
                                        ),
                                        if (t.dueDate != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFEF3C7),
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              t.dueDate!,
                                              style: const TextStyle(fontSize: 11, color: Color(0xFFB45309), fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )),
                            ],
                          );
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
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
