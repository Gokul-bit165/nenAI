import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../router/app_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../home/home_notifier.dart';
import 'topics_notifier.dart';
import 'obsidian_graph_widget.dart';

class TopicsScreen extends ConsumerStatefulWidget {
  const TopicsScreen({super.key});

  @override
  ConsumerState<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends ConsumerState<TopicsScreen> {
  bool _isGraphView = true;
  final GlobalKey<ObsidianGraphWidgetState> _graphKey =
      GlobalKey<ObsidianGraphWidgetState>();

  void _showRenameDialog(BuildContext context, WidgetRef ref, String clusterId,
      String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Rename Cluster', style: AppTextStyles.titleMedium),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new cluster name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  final renameAction = ref.read(renameClusterProvider);
                  await renameAction(clusterId, newName);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
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
    final clustersAsync = ref.watch(clustersProvider);
    final notesAsync = ref.watch(notesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Topics',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 22),
        ),
        actions: [
          // View Switcher: Graph / Grid toggle
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!_isGraphView) setState(() => _isGraphView = true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _isGraphView ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: _isGraphView
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.hub_outlined,
                      size: 18,
                      color: _isGraphView ? AppColors.primary : AppColors.textMuted,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_isGraphView) setState(() => _isGraphView = false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: !_isGraphView ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: !_isGraphView
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              )
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.grid_view_rounded,
                      size: 18,
                      color: !_isGraphView ? AppColors.primary : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: clustersAsync.when(
        data: (clusters) {
          if (clusters.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryTint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.hub_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Topic Clusters Yet',
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'As you write notes, on-device AI will automatically group related thoughts into topic clusters.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          final notes = notesAsync.value ?? [];

          if (_isGraphView) {
            return Stack(
              children: [
                ObsidianGraphWidget(
                  key: _graphKey,
                  clusters: clusters,
                  notes: notes,
                ),
                // Re-center button on bottom left
                Positioned(
                  left: 20,
                  bottom: 24,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.my_location_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                      tooltip: 'Center Graph',
                      onPressed: () {
                        _graphKey.currentState?.recenter();
                      },
                    ),
                  ),
                ),
              ],
            );
          }

          // Grid View (5b)
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.15,
            ),
            itemCount: clusters.length,
            itemBuilder: (context, index) {
              final cluster = clusters[index];
              final (iconColor, bgColor) = _getClusterColors(cluster.name);

              return GestureDetector(
                onTap: () => context.push('/topics/${cluster.id}', extra: cluster.name),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: iconColor.withOpacity(0.18),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.folder_rounded,
                              size: 24,
                              color: iconColor,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              size: 18,
                              color: iconColor.withOpacity(0.8),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (val) {
                              if (val == 'rename') {
                                _showRenameDialog(context, ref, cluster.id, cluster.name);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'rename',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_outlined, size: 16),
                                    SizedBox(width: 8),
                                    Text('Rename'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cluster.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${cluster.noteCount} Notes',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: iconColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.editor),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, size: 28, color: Colors.white),
      ),
    );
  }
}
