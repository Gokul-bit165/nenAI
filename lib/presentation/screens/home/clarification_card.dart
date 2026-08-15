import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/pending_resolution.dart';
import '../../theme/app_colors.dart';
import 'clarification_notifier.dart';

/// User-facing Interactive Clarification Card for ambiguous memory resolution.
class ClarificationCard extends ConsumerStatefulWidget {
  const ClarificationCard({
    super.key,
    required this.resolution,
    this.onEditNote,
  });

  final PendingResolution resolution;
  final VoidCallback? onEditNote;

  @override
  ConsumerState<ClarificationCard> createState() => _ClarificationCardState();
}

class _ClarificationCardState extends ConsumerState<ClarificationCard> {
  String? _selectedOption; // 'context:<id>' | 'both' | 'new' | 'none'
  final _newContextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.resolution.candidates.isNotEmpty) {
      _selectedOption = 'context:${widget.resolution.candidates.first.contextId}';
    } else {
      _selectedOption = 'none';
    }
  }

  @override
  void dispose() {
    _newContextController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final notifier = ref.read(clarificationNotifierProvider.notifier);
    final resId = widget.resolution.id;
    final memId = widget.resolution.memoryId;

    if (_selectedOption == null) return;

    if (_selectedOption!.startsWith('context:')) {
      final contextId = _selectedOption!.substring('context:'.length);
      notifier.confirmSingle(
        resolutionId: resId,
        memoryId: memId,
        contextId: contextId,
      );
    } else if (_selectedOption == 'both') {
      notifier.confirmBoth(
        resolutionId: resId,
        memoryId: memId,
      );
    } else if (_selectedOption == 'new') {
      final name = _newContextController.text.trim();
      if (name.isEmpty) return;
      notifier.confirmNewContext(
        resolutionId: resId,
        memoryId: memId,
        newContextName: name,
      );
    } else if (_selectedOption == 'none') {
      notifier.confirmNone(
        resolutionId: resId,
        memoryId: memId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColors.electricViolet.withAlpha(80),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.electricViolet.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.help_outline_rounded,
                    color: AppColors.electricViolet,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Where does this belong?',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'I found multiple possible contexts:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Note Snippet preview
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withAlpha(60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"${widget.resolution.noteTextSnippet}"',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),

            // Candidate Radio Options
            ...widget.resolution.candidates.map((candidate) {
              final val = 'context:${candidate.contextId}';
              final isSelected = _selectedOption == val;

              return InkWell(
                onTap: () => setState(() => _selectedOption = val),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio<String>(
                        value: val,
                        groupValue: _selectedOption,
                        onChanged: (v) => setState(() => _selectedOption = v),
                        activeColor: AppColors.electricViolet,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  candidate.contextName,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.electricViolet.withAlpha(30)
                                        : colorScheme.surfaceContainerHighest,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${(candidate.confidence * 100).toStringAsFixed(0)}%',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: isSelected
                                          ? AppColors.electricViolet
                                          : colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (candidate.evidenceSummary.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                candidate.evidenceSummary,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // Option: Both
            InkWell(
              onTap: () => setState(() => _selectedOption = 'both'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'both',
                      groupValue: _selectedOption,
                      onChanged: (v) => setState(() => _selectedOption = v),
                      activeColor: AppColors.electricViolet,
                    ),
                    Text(
                      'Both (attach to multiple contexts)',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            // Option: Create new context
            InkWell(
              onTap: () => setState(() => _selectedOption = 'new'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'new',
                      groupValue: _selectedOption,
                      onChanged: (v) => setState(() => _selectedOption = v),
                      activeColor: AppColors.electricViolet,
                    ),
                    Text(
                      'Create new context',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedOption == 'new')
              Padding(
                padding: const EdgeInsets.only(left: 48, right: 16, bottom: 8),
                child: TextField(
                  controller: _newContextController,
                  decoration: const InputDecoration(
                    hintText: 'Enter new context / project name...',
                    isDense: true,
                  ),
                ),
              ),

            // Option: None of these
            InkWell(
              onTap: () => setState(() => _selectedOption = 'none'),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'none',
                      groupValue: _selectedOption,
                      onChanged: (v) => setState(() => _selectedOption = v),
                      activeColor: AppColors.electricViolet,
                    ),
                    Text(
                      'None of these (keep unassigned)',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.onEditNote != null)
                  TextButton(
                    onPressed: widget.onEditNote,
                    child: const Text('Edit / Re-enter note'),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricViolet,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Choose'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
