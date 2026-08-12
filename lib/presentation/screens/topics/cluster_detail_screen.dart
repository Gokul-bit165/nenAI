import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../injection.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

final clusterNotesStreamProvider =
    StreamProvider.family<List<Note>, String>((ref, clusterId) {
  final repository = getIt<NoteRepository>();
  return repository.watchNotesByCluster(clusterId);
});

class ClusterDetailScreen extends ConsumerStatefulWidget {
  const ClusterDetailScreen({
    super.key,
    required this.clusterId,
    required this.clusterName,
  });

  final String clusterId;
  final String clusterName;

  @override
  ConsumerState<ClusterDetailScreen> createState() => _ClusterDetailScreenState();
}

class _ClusterDetailScreenState extends ConsumerState<ClusterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  (Color, Color) _getClusterColors(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('tech')) {
      return (AppColors.clusterTech, AppColors.clusterTechBg);
    } else if (lower.contains('project')) {
      return (AppColors.clusterProjects, AppColors.clusterProjectsBg);
    } else if (lower.contains('ai') || lower.contains('ml')) {
      return (AppColors.clusterAi, AppColors.clusterAiBg);
    } else if (lower.contains('person')) {
      return (AppColors.clusterPersonal, AppColors.clusterPersonalBg);
    } else if (lower.contains('book')) {
      return (AppColors.clusterBooks, AppColors.clusterBooksBg);
    } else if (lower.contains('idea')) {
      return (AppColors.clusterIdeas, AppColors.clusterIdeasBg);
    }
    return (AppColors.primary, AppColors.primaryTint);
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(clusterNotesStreamProvider(widget.clusterId));
    final (iconColor, bgColor) = _getClusterColors(widget.clusterName);
    final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: notesAsync.when(
        data: (notes) {
          return Column(
            children: [
              // Cluster Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: iconColor.withOpacity(0.2)),
                      ),
                      child: Icon(
                        Icons.folder_rounded,
                        size: 28,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.clusterName,
                            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${notes.length} ${notes.length == 1 ? "Note" : "Notes"}',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Tab Bar (Notes / About)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 1),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textMuted,
                  indicatorColor: AppColors.primary,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'Notes'),
                    Tab(text: 'About'),
                  ],
                ),
              ),

              // Tab View Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Notes List Tab
                    notes.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.article_outlined,
                                    size: 48,
                                    color: AppColors.textMuted.withOpacity(0.5),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No notes in this cluster yet',
                                    style: AppTextStyles.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () =>
                                      context.push('/detail/${note.id}'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 4),
                                  leading: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.article_outlined,
                                      size: 18,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  title: Text(
                                    note.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.titleSmall.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    dateFormat.format(note.createdAt),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      fontSize: 11,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),

                    // About Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About this Topic Cluster',
                            style: AppTextStyles.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This topic was automatically discovered and maintained by NENAI\'s on-device AI semantic clustering algorithm. Notes discussing related themes are clustered together dynamically.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Action: + Add Note to this cluster
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryTint,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text(
                      'Add Note to this cluster',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () => context.push(AppRoutes.editor),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
