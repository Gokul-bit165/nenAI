import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../injection.dart';
import '../../components/note_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

final clusterNotesStreamProvider = StreamProvider.family<List<Note>, String>((ref, clusterId) {
  final repository = getIt<NoteRepository>();
  return repository.watchNotesByCluster(clusterId);
});

class ClusterDetailScreen extends ConsumerWidget {
  const ClusterDetailScreen({super.key, required this.clusterId, required this.clusterName});

  final String clusterId;
  final String clusterName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(clusterNotesStreamProvider(clusterId));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(clusterName, style: AppTextStyles.titleMedium),
            const Text('Topic Cluster Notes', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(
              child: Text('No notes in this topic cluster yet.', style: TextStyle(color: AppColors.textMuted)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return NoteCard(
                note: note,
                onTap: () => context.push('/detail/${note.id}'),
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
