import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/cluster_chip.dart';
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

  void _showRenameDialog(BuildContext context, WidgetRef ref, String clusterId, String currentName) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Cluster'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter new cluster name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
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

  @override
  Widget build(BuildContext context) {
    final clustersAsync = ref.watch(clustersProvider);
    final notesAsync = ref.watch(notesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Topic Clusters', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            icon: Icon(_isGraphView ? Icons.grid_view_rounded : Icons.account_tree_outlined),
            tooltip: _isGraphView ? 'Grid View' : 'Obsidian Graph View',
            onPressed: () {
              setState(() {
                _isGraphView = !_isGraphView;
              });
            },
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
                    Icon(
                      Icons.hub_outlined,
                      size: 64,
                      color: AppColors.textMuted.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Topic Clusters Yet',
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'As you write notes, the AI will automatically group related notes into topic clusters.',
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
            return ObsidianGraphWidget(
              clusters: clusters,
              notes: notes,
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: clusters.length,
            itemBuilder: (context, index) {
              final cluster = clusters[index];
              return Card(
                child: InkWell(
                  onTap: () => context.push('/topics/${cluster.id}', extra: cluster.name),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClusterChip(name: cluster.name, colorHex: cluster.colorHex),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cluster.noteCount} ${cluster.noteCount == 1 ? "note" : "notes"}',
                              style: AppTextStyles.labelSmall,
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () => _showRenameDialog(context, ref, cluster.id, cluster.name),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
