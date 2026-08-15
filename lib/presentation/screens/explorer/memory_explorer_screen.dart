import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/context_node.dart';
import '../../../domain/entities/cluster.dart';
import '../../components/context_breadcrumb_path.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../topics/obsidian_graph_widget.dart';
import 'memory_explorer_notifier.dart';

class MemoryExplorerScreen extends ConsumerStatefulWidget {
  const MemoryExplorerScreen({super.key});

  @override
  ConsumerState<MemoryExplorerScreen> createState() => _MemoryExplorerScreenState();
}

class _MemoryExplorerScreenState extends ConsumerState<MemoryExplorerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(memoryExplorerProvider);
    final notifier = ref.read(memoryExplorerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          'Memory Explorer',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            tooltip: 'Refresh Hierarchy',
            onPressed: () => notifier.loadAll(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(icon: Icon(Icons.account_tree_rounded, size: 18), text: 'Hierarchy'),
            Tab(icon: Icon(Icons.hub_rounded, size: 18), text: 'Graph View'),
            Tab(icon: Icon(Icons.timeline_rounded, size: 18), text: 'Timeline'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHierarchyView(context, state, notifier),
                _buildGraphView(context, state),
                _buildTimelineView(context, state),
              ],
            ),
    );
  }

  Widget _buildHierarchyView(
    BuildContext context,
    MemoryExplorerState state,
    MemoryExplorerNotifier notifier,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Breadcrumb Bar ────────────────────────────────────────────────
          if (state.breadcrumbPath.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ContextBreadcrumbPath(pathNodes: state.breadcrumbPath),
            ),
            const SizedBox(height: 16),
          ],

          // ── Root Categories Accordion ─────────────────────────────────────
          _buildCategorySection(
            title: 'PROJECTS',
            icon: Icons.rocket_launch_outlined,
            iconColor: const Color(0xFF6366F1),
            nodes: state.projects,
            state: state,
            notifier: notifier,
          ),
          const SizedBox(height: 12),

          _buildCategorySection(
            title: 'MEETINGS & EPISODES',
            icon: Icons.calendar_today_outlined,
            iconColor: const Color(0xFF0EA5E9),
            nodes: state.meetings,
            state: state,
            notifier: notifier,
          ),
          const SizedBox(height: 12),

          if (state.topics.isNotEmpty) ...[
            _buildCategorySection(
              title: 'TOPICS & CONCEPTS',
              icon: Icons.lightbulb_outline_rounded,
              iconColor: const Color(0xFFF59E0B),
              nodes: state.topics,
              state: state,
              notifier: notifier,
            ),
            const SizedBox(height: 12),
          ],

          if (state.people.isNotEmpty) ...[
            _buildPeopleSection(state),
            const SizedBox(height: 16),
          ],

          const Divider(height: 32, color: Color(0xFFE2E8F0)),

          // ── Selected Context Detail Panel ─────────────────────────────────
          if (state.selectedNode != null)
            _buildSelectedNodeDetails(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<ContextNode> nodes,
    required MemoryExplorerState state,
    required MemoryExplorerNotifier notifier,
  }) {
    if (nodes.isEmpty) return const SizedBox.shrink();

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          shape: const Border(),
          collapsedShape: const Border(),
          leading: Icon(icon, color: iconColor, size: 20),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: Color(0xFF475569),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
              child: Column(
                children: nodes.map((node) {
                  return _buildContextNodeTile(node, state, notifier, depth: 0);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextNodeTile(
    ContextNode node,
    MemoryExplorerState state,
    MemoryExplorerNotifier notifier, {
    int depth = 0,
  }) {
    final isSelected = state.selectedNode?.id == node.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => notifier.selectNode(node.id),
          child: Container(
            margin: EdgeInsets.only(left: depth * 16.0, bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6366F1).withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.4))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  node.type == ContextNodeType.project
                      ? Icons.folder_rounded
                      : (node.type == ContextNodeType.episode
                          ? Icons.event_note_rounded
                          : Icons.subdirectory_arrow_right_rounded),
                  size: 16,
                  color: isSelected
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    node.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF4338CA)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    node.type.name,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPeopleSection(MemoryExplorerState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.people_outline_rounded, color: Color(0xFF10B981), size: 18),
              SizedBox(width: 8),
              Text(
                'PEOPLE & ENTITIES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: Color(0xFF475569),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: state.people.map((p) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_rounded, size: 13, color: Color(0xFF059669)),
                    const SizedBox(width: 4),
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedNodeDetails(
    BuildContext context,
    MemoryExplorerState state,
    MemoryExplorerNotifier notifier,
  ) {
    final node = state.selectedNode!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.folder_special_rounded, color: Color(0xFF6366F1), size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    node.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    '${node.type.name.toUpperCase()} • ${state.relatedNotes.length} memories',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Subtree Children / Activities
        if (state.selectedSubtree != null && state.selectedSubtree!.children.isNotEmpty) ...[
          const Text(
            'SUB-ACTIVITIES & CONTEXTS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: state.selectedSubtree!.children.map((childSub) {
              return ActionChip(
                avatar: const Icon(Icons.subdirectory_arrow_right_rounded, size: 14),
                label: Text(childSub.node.name),
                backgroundColor: const Color(0xFFF1F5F9),
                onPressed: () => notifier.selectNode(childSub.node.id),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // Related Notes
        Text(
          'RELATED MEMORIES (${state.relatedNotes.length})',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 8),
        if (state.relatedNotes.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No notes linked directly to this context.',
              style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8), fontStyle: FontStyle.italic),
            ),
          )
        else
          for (final note in state.relatedNotes) ...[
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => context.push('/detail/${note.id}', extra: note.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.description_outlined, size: 16, color: Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            note.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
          ],

        const SizedBox(height: 16),

        // Tasks & Action Items
        if (state.tasks.isNotEmpty) ...[
          Text(
            'TASKS (${state.tasks.length})',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          for (final task in state.tasks) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    task.isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                    size: 16,
                    color: task.isCompleted ? const Color(0xFF10B981) : const Color(0xFF64748B),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF1E293B),
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
        ],

        // Knowledge Graph Connections
        if (state.relationships.isNotEmpty) ...[
          Text(
            'KNOWLEDGE GRAPH CONNECTIONS (${state.relationships.length})',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          for (final rel in state.relationships) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                '${rel.sourceName} --[${rel.relation}]--> ${rel.targetName}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildGraphView(BuildContext context, MemoryExplorerState state) {
    final mockClusters = state.projects.map((p) {
      return Cluster(
        id: p.id,
        name: p.name,
        colorHex: '#6366F1',
        createdAt: p.createdAt,
        noteCount: state.allNotes.length,
      );
    }).toList();

    return ObsidianGraphWidget(
      clusters: mockClusters,
      notes: state.allNotes,
    );
  }

  Widget _buildTimelineView(BuildContext context, MemoryExplorerState state) {
    if (state.timeline == null || state.timeline!.items.isEmpty) {
      return const Center(
        child: Text(
          'Select a context in the Hierarchy tab to view its timeline.',
          style: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timeline for ${state.timeline!.contextName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              state.timeline!.toTreeString(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
