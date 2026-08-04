import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/note_card.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../home/home_notifier.dart';
import 'search_notifier.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);

    final clustersAsync = ref.watch(clustersStreamProvider);
    final clusters = clustersAsync.asData?.value ?? [];
    final clusterMap = {for (final c in clusters) c.id: c};

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          onChanged: notifier.search,
          style: AppTextStyles.bodyLarge,
          decoration: const InputDecoration(
            hintText: 'Ask or search your memory...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          if (searchState.isSearching) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (searchState.query.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 64,
                      color: AppColors.textMuted.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Natural Language Memory Search',
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Type any phrase, topic, or concept. On-device vector embeddings will rank notes by semantic similarity.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (searchState.results.isEmpty) {
            return Center(
              child: Text(
                'No notes found for "${searchState.query}"',
                style: AppTextStyles.bodyMedium,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: searchState.results.length,
            itemBuilder: (context, index) {
              final note = searchState.results[index];
              final cluster = note.clusterId != null ? clusterMap[note.clusterId!] : null;
              return NoteCard(
                note: note,
                cluster: cluster,
                onTap: () => context.push('/detail/${note.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
