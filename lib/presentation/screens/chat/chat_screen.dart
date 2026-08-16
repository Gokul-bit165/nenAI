import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'chat_notifier.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  late final TextEditingController _textController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);
    final notifier = ref.watch(chatProvider.notifier);

    // Scroll to bottom whenever new messages arrive.
    ref.listen<ChatState>(chatProvider, (_, next) {
      if (next.messages.isNotEmpty) _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.accentGreenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.smart_toy_outlined,
                size: 20,
                color: AppColors.accentGreenDark,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Memory AI Assistant',
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 15),
                ),
                const Text(
                  'Hybrid RAG • Offline MCP Tools',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Message List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return _buildMessageItem(context, message, notifier);
              },
            ),
          ),

          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                ),
              ),
            ),

          // Quick Prompt Chips
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildQuickChip('What did I note?'),
                _buildQuickChip('Set alarm for 7:00 AM tomorrow'),
                _buildQuickChip('Summarize today'),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // Input Bar
          Container(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _textController,
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            notifier.sendMessage(val);
                            _textController.clear();
                            _scrollToBottom();
                          }
                        },
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: 'Ask anything...',
                          hintStyle: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.accentGreen,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        final text = _textController.text.trim();
                        if (text.isNotEmpty) {
                          notifier.sendMessage(text);
                          _textController.clear();
                          _scrollToBottom();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () {
          ref.read(chatProvider.notifier).sendMessage(label);
          _scrollToBottom();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(
      BuildContext context, ChatMessage message, ChatNotifier notifier) {
    // ── Gate 2: inline clarification bubble ──────────────────────────────────
    if (message.isClarificationAsk) {
      return _ClarificationBubble(
        key: ValueKey(message.id),
        message: message,
        onConfirm: (contextId) => notifier.confirmClarification(
          messageId: message.id,
          resolutionId: message.clarificationResolutionId ?? '',
          contextId: contextId,
          memoryId: message.clarificationResolutionId != null
              ? message.id.replaceFirst('clarify-', '')
              : null,
        ),
      );
    }

    final isUser = message.isUser;
    final timeStr = DateFormat('h:mm a').format(message.timestamp);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.accentGreenLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                size: 18,
                color: AppColors.accentGreenDark,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFFDCFCE7) : Colors.white,
                    borderRadius: BorderRadius.circular(18).copyWith(
                      bottomRight: isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                      topLeft: !isUser
                          ? const Radius.circular(4)
                          : const Radius.circular(18),
                    ),
                    border: Border.all(
                      color: isUser
                          ? const Color(0xFFBBF7D0)
                          : AppColors.border,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isUser
                              ? const Color(0xFF14532D)
                              : AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),

                      // Memory Citations
                      if (message.citedNotes.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.bookmark_added_rounded,
                                      size: 14, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text(
                                    'Cites Memories',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ...message.citedNotes.map((cite) => InkWell(
                                    onTap: () => context
                                        .push('/detail/${cite.note.id}'),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.link_rounded,
                                              size: 13,
                                              color: AppColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              '${cite.note.title} • ${DateFormat("MMM d, yyyy").format(cite.note.createdAt)}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ],

                      // Pending Action Confirmation Card
                      if (message.pendingAction != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.notifications_active_outlined,
                                      size: 16, color: AppColors.accentGreenDark),
                                  SizedBox(width: 6),
                                  Text(
                                    'Confirm & Schedule Alarm',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.textSecondary,
                                        side: const BorderSide(
                                            color: AppColors.border),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      onPressed: () =>
                                          notifier.dismissAction(message),
                                      child: const Text('Cancel',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.accentGreen,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                      ),
                                      onPressed: () =>
                                          notifier.confirmAction(message),
                                      child: const Text('Confirm',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Action Executed Feedback Badge
                      if (message.actionExecutedMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.accentGreenLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  size: 15, color: AppColors.accentGreenDark),
                              const SizedBox(width: 6),
                              Text(
                                message.actionExecutedMessage!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accentGreenDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                    if (isUser) ...[
                      const SizedBox(width: 3),
                      // Processing indicator — shows while background analysis runs
                      if (message.isProcessing)
                        const _ProcessingDot()
                      else
                        const Icon(
                          Icons.done_all_rounded,
                          size: 13,
                          color: AppColors.accentGreenDark,
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Gate 2: Inline Clarification Bubble
// ─────────────────────────────────────────────────────────────────────────────

/// AI-side bubble that renders a Gate 2 clarification as quick-reply chips.
///
/// Tapping a chip calls [onConfirm] with the chosen contextId (or null for
/// "None of these"), which routes to [ChatNotifier.confirmClarification] →
/// [ResolutionRepository.resolveResolution] — the same handler used by
/// [ClarificationCard] on the home/pending-review screens.
class _ClarificationBubble extends StatelessWidget {
  const _ClarificationBubble({
    super.key,
    required this.message,
    required this.onConfirm,
  });

  final ChatMessage message;
  final void Function(String? contextId) onConfirm;

  @override
  Widget build(BuildContext context) {
    final candidates = message.clarificationCandidates ?? [];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // AI avatar
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFEDE9FE), // electricViolet tint
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_alt_rounded,
              size: 18,
              color: AppColors.electricViolet,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
                border: Border.all(
                  color: AppColors.electricViolet.withAlpha(80),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricViolet.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.electricViolet.withAlpha(20),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Memory Context',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.electricViolet,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message.text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Candidate quick-reply chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...candidates.map((c) => _QuickReplyChip(
                            label: c.contextName,
                            sublabel:
                                '${(c.confidence * 100).toStringAsFixed(0)}%',
                            onTap: () => onConfirm(c.contextId),
                          )),
                      // "None of these" option
                      _QuickReplyChip(
                        label: 'None of these',
                        isNone: true,
                        onTap: () => onConfirm(null),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickReplyChip extends StatelessWidget {
  const _QuickReplyChip({
    required this.label,
    required this.onTap,
    this.sublabel,
    this.isNone = false,
  });

  final String label;
  final String? sublabel;
  final VoidCallback onTap;
  final bool isNone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isNone
              ? AppColors.surfaceVariant
              : AppColors.electricViolet.withAlpha(15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isNone
                ? AppColors.border
                : AppColors.electricViolet.withAlpha(60),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isNone ? AppColors.textSecondary : AppColors.electricViolet,
              ),
            ),
            if (sublabel != null) ...[
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.electricViolet.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sublabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electricViolet,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Processing Dot — pulsing indicator while analysis runs
// ─────────────────────────────────────────────────────────────────────────────

class _ProcessingDot extends StatefulWidget {
  const _ProcessingDot();

  @override
  State<_ProcessingDot> createState() => _ProcessingDotState();
}

class _ProcessingDotState extends State<_ProcessingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            color: AppColors.electricViolet,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
