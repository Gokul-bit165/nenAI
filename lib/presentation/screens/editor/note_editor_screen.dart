import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'note_editor_notifier.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  const NoteEditorScreen({super.key, this.noteId});

  final String? noteId;

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(noteEditorProvider(widget.noteId).notifier);
    final state = ref.watch(noteEditorProvider(widget.noteId));

    // Update controller text if existing note loaded
    if (_controller.text.isEmpty && state.content.isNotEmpty) {
      _controller.text = state.content;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.noteId == null ? 'New Note' : 'Edit Note',
          style: AppTextStyles.titleMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: state.isSaving
                  ? null
                  : () async {
                      final savedId = await notifier.save();
                      if (savedId != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Note saved! AI is processing...'),
                            duration: Duration(seconds: 2),
                            backgroundColor: AppColors.surfaceVariant,
                          ),
                        );
                        context.pop();
                      }
                    },
              icon: state.isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_rounded, color: AppColors.primaryLight),
              label: Text(
                'Save',
                style: TextStyle(
                  color: state.isSaving ? AppColors.textMuted : AppColors.primaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: TextField(
          controller: _controller,
          onChanged: notifier.updateContent,
          maxLines: null,
          expands: true,
          autofocus: widget.noteId == null,
          style: AppTextStyles.bodyLarge,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Write your thought, note, or idea here...\n\nOn save, AI will analyze, extract keywords, generate a summary, and connect it to related notes.',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            fillColor: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
