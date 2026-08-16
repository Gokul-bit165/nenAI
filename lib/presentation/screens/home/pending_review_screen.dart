import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'clarification_card.dart';
import 'clarification_notifier.dart';

/// Dedicated screen listing all pending memory clarifications.
///
/// This is the universal safety net for Gate 2 results from BOTH note and chat
/// sources. The home-screen badge navigates here; so does any deep link.
class PendingReviewScreen extends ConsumerWidget {
  const PendingReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingResolutionsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.electricViolet.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology_alt_rounded,
                size: 18,
                color: AppColors.electricViolet,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Memories Needing Your Input',
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 15),
                ),
                Text(
                  'Tap a card to confirm or dismiss',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: pendingAsync.when(
        data: (resolutions) {
          if (resolutions.isEmpty) {
            return _EmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: resolutions.length,
            itemBuilder: (context, index) {
              final resolution = resolutions[index];
              return ClarificationCard(
                key: ValueKey(resolution.id),
                resolution: resolution,
                onEditNote: () => Navigator.of(context).pop(),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.electricViolet),
        ),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load pending memories: $err',
              style: const TextStyle(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: AppColors.accentGreenLight.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 52,
                color: AppColors.accentGreenDark,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'All caught up!',
              style: AppTextStyles.titleMedium.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'No memories are waiting for your input right now. When NENAI is unsure where a note or message belongs, it will show up here.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
