import 'package:flutter/material.dart';
import 'context_breadcrumb_path.dart';

class CandidateOption {
  const CandidateOption({
    required this.id,
    required this.name,
    required this.scorePercent,
    this.evidenceSummary,
  });

  final String id;
  final String name;
  final int scorePercent;
  final String? evidenceSummary;
}

/// "WHAT NENAI UNDERSTOOD" Card: Surfaces contextual intelligence, hierarchy path,
/// reasoning, confidence rating, evidence signals, and human-in-the-loop clarification actions.
class MemoryUnderstandingCard extends StatelessWidget {
  const MemoryUnderstandingCard({
    super.key,
    required this.contextName,
    this.contextType,
    required this.pathNodes,
    this.reason,
    this.confidenceLevel = 'High',
    this.confidenceScore,
    this.evidenceSignals = const [],
    this.statusText = 'Automatically connected',
    this.isAmbiguous = false,
    this.candidateOptions = const [],
    this.onSelectCandidate,
    this.onSelectBoth,
    this.onCreateNewContext,
  });

  final String contextName;
  final String? contextType;
  final List<String> pathNodes;
  final String? reason;
  final String confidenceLevel;
  final double? confidenceScore;
  final List<String> evidenceSignals;
  final String statusText;
  final bool isAmbiguous;
  final List<CandidateOption> candidateOptions;
  final ValueChanged<String>? onSelectCandidate;
  final VoidCallback? onSelectBoth;
  final VoidCallback? onCreateNewContext;

  Color _getConfidenceColor() {
    switch (confidenceLevel.toLowerCase()) {
      case 'high':
        return const Color(0xFF10B981);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isAmbiguous ? const Color(0xFFFDE68A) : const Color(0xFFE0E7FF),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (isAmbiguous ? const Color(0xFFF59E0B) : const Color(0xFF6366F1))
                .withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 1. Header Banner ───────────────────────────────────────────────
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isAmbiguous
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isAmbiguous
                      ? Icons.help_outline_rounded
                      : Icons.auto_awesome_rounded,
                  size: 16,
                  color: isAmbiguous
                      ? const Color(0xFFD97706)
                      : const Color(0xFF4F46E5),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'WHAT NENAI UNDERSTOOD',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  color: isAmbiguous
                      ? const Color(0xFF92400E)
                      : const Color(0xFF3730A3),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isAmbiguous
                      ? const Color(0xFFFFFBEB)
                      : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isAmbiguous
                        ? const Color(0xFFFDE68A)
                        : const Color(0xFFA7F3D0),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAmbiguous
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_rounded,
                      size: 12,
                      color: isAmbiguous
                          ? const Color(0xFFD97706)
                          : const Color(0xFF059669),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isAmbiguous ? 'Context uncertain' : '✓ $statusText',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isAmbiguous
                            ? const Color(0xFFB45309)
                            : const Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── 2. Context Name & Type ─────────────────────────────────────────
          if (!isAmbiguous) ...[
            Row(
              children: [
                const Text(
                  'Context: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                Text(
                  contextName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                if (contextType != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: Text(
                      contextType!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 10),

            // ── 3. Breadcrumb Path ───────────────────────────────────────────
            if (pathNodes.isNotEmpty) ...[
              const Text(
                'Path:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              ContextBreadcrumbPath(pathNodes: pathNodes),
              const SizedBox(height: 12),
            ],

            // ── 4. Reason ───────────────────────────────────────────────────
            if (reason != null && reason!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 15,
                      color: Color(0xFF6366F1),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        reason!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF334155),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // ── 5. Confidence ───────────────────────────────────────────────
            Row(
              children: [
                const Text(
                  'Confidence: ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor().withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    confidenceScore != null
                        ? '$confidenceLevel (${(confidenceScore! * 100).toStringAsFixed(0)}%)'
                        : confidenceLevel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _getConfidenceColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── 6. Evidence Signals ─────────────────────────────────────────
            if (evidenceSignals.isNotEmpty) ...[
              const Text(
                'Evidence:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              for (final signal in evidenceSignals) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          signal,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF475569),
                            height: 1.25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ] else ...[
            // ── 7. AMBIGUOUS / CLARIFICATION PANEL ───────────────────────────
            const Text(
              'I found multiple possible matching contexts for this note:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),

            for (final candidate in candidateOptions) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidate.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          if (candidate.evidenceSummary != null)
                            Text(
                              candidate.evidenceSummary!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFB45309),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFCD34D)),
                      ),
                      child: Text(
                        '${candidate.scorePercent}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD97706),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () => onSelectCandidate?.call(candidate.id),
                      child: Text(
                        'Choose ${candidate.name}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 6),
            Row(
              children: [
                if (onSelectBoth != null) ...[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6366F1),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: onSelectBoth,
                    child: const Text('Both', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 8),
                ],
                if (onCreateNewContext != null)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF475569),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: onCreateNewContext,
                    child: const Text('Create New Context', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
