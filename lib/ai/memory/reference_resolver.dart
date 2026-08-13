import 'dart:math' as math;
import '../../data/local/database/app_database.dart';
import '../../domain/ai/note_analysis_result.dart';
import '../../domain/ai/reference_resolution.dart';
import '../../domain/entities/context_node.dart';
import '../../domain/repositories/context_repository.dart';

/// Reference Resolver: Resolves cross-note pronouns ("this", "it", "he", "she", "they")
/// and definite noun phrases ("the project", "the deployment", "the meeting", "the previous task").
class ReferenceResolver {
  const ReferenceResolver({
    required this.db,
    required this.contextRepository,
    this.resolvedThreshold = 0.75,
    this.resolvedMargin = 0.20,
    this.ambiguityMargin = 0.15,
    this.weakThreshold = 0.40,
  });

  final AppDatabase db;
  final ContextRepository contextRepository;
  final double resolvedThreshold;
  final double resolvedMargin;
  final double ambiguityMargin;
  final double weakThreshold;

  /// Evaluates and resolves all contextual references for an incoming note.
  Future<ReferenceResolutionResult> resolve({
    required String noteText,
    required List<ContextualReference> references,
    required DateTime noteTimestamp,
    String? activeContextId,
  }) async {
    if (references.isEmpty) {
      return const ReferenceResolutionResult(
        resolvedReferences: [],
        hasAmbiguities: false,
        unresolvedCount: 0,
        summary: 'No references to resolve.',
      );
    }

    // 1. Fetch recent notes and context nodes for candidate referents
    final recentNotesData = await db.notes.watchAll().first;
    final recentContexts = await contextRepository.watchAllNodes().first;

    final resolvedList = <ResolvedReference>[];
    bool hasAmbiguity = false;
    int unresolvedCount = 0;

    for (final ref in references) {
      final category = ReferenceCategory.fromText(ref.text);
      final candidateReferents = await _generateCandidates(
        reference: ref,
        category: category,
        recentNotes: recentNotesData,
        contexts: recentContexts,
        noteTimestamp: noteTimestamp,
        activeContextId: activeContextId,
      );

      // Sort candidates descending by confidence score
      candidateReferents.sort((a, b) => b.confidence.compareTo(a.confidence));

      if (candidateReferents.isEmpty) {
        resolvedList.add(ResolvedReference(
          referenceText: ref.text,
          category: category,
          status: ReferenceResolutionStatus.unresolved,
          explanation: 'No candidate referents found in recent history.',
        ));
        unresolvedCount++;
        continue;
      }

      final top = candidateReferents.first;
      final runnerUp = candidateReferents.length > 1 ? candidateReferents[1] : null;
      final margin = runnerUp != null ? (top.confidence - runnerUp.confidence) : 1.0;

      // ── Decision 1: RESOLVED (High confidence + clear margin) ───────────────
      if (top.confidence >= resolvedThreshold && margin >= resolvedMargin) {
        resolvedList.add(ResolvedReference(
          referenceText: ref.text,
          category: category,
          status: ReferenceResolutionStatus.resolved,
          targetReferent: top.referentName,
          targetReferentId: top.referentId,
          targetReferentType: top.referentType,
          confidence: top.confidence,
          candidates: candidateReferents,
          explanation:
              'Resolved "${ref.text}" to "${top.referentName}" (${(top.confidence * 100).toStringAsFixed(0)}% confidence).',
        ));
      }
      // ── Decision 2: AMBIGUOUS (Close competition between candidates) ────────
      else if (top.confidence >= weakThreshold && runnerUp != null && margin <= ambiguityMargin) {
        resolvedList.add(ResolvedReference(
          referenceText: ref.text,
          category: category,
          status: ReferenceResolutionStatus.ambiguous,
          targetReferent: top.referentName,
          targetReferentId: top.referentId,
          targetReferentType: top.referentType,
          confidence: top.confidence,
          candidates: [top, runnerUp],
          explanation:
              'Ambiguous reference "${ref.text}" between "${top.referentName}" (${(top.confidence * 100).toStringAsFixed(0)}%) and "${runnerUp.referentName}" (${(runnerUp.confidence * 100).toStringAsFixed(0)}%).',
        ));
        hasAmbiguity = true;
      }
      // ── Decision 3: UNRESOLVED (Low confidence) ─────────────────────────────
      else {
        resolvedList.add(ResolvedReference(
          referenceText: ref.text,
          category: category,
          status: ReferenceResolutionStatus.unresolved,
          targetReferent: top.referentName,
          confidence: top.confidence,
          candidates: candidateReferents,
          explanation:
              'Confidence for "${ref.text}" (${(top.confidence * 100).toStringAsFixed(0)}%) is too low to safely resolve.',
        ));
        unresolvedCount++;
      }
    }

    final summary = hasAmbiguity
        ? 'Some references require clarification.'
        : unresolvedCount > 0
            ? 'Completed with $unresolvedCount unresolved reference(s).'
            : 'All references resolved successfully.';

    return ReferenceResolutionResult(
      resolvedReferences: resolvedList,
      hasAmbiguities: hasAmbiguity,
      unresolvedCount: unresolvedCount,
      summary: summary,
    );
  }

  Future<List<ReferentCandidate>> _generateCandidates({
    required ContextualReference reference,
    required ReferenceCategory category,
    required List<NotesTableData> recentNotes,
    required List<ContextNode> contexts,
    required DateTime noteTimestamp,
    String? activeContextId,
  }) async {
    final refTextLower = reference.text.toLowerCase().trim();
    final candidates = <ReferentCandidate>[];

    // 1. Evaluate Context Nodes as Referents
    for (final ctx in contexts) {
      final ctxNameLower = ctx.name.toLowerCase();
      final signals = <String, double>{};
      double typeScore = 0.0;

      switch (category) {
        case ReferenceCategory.pronoun:
          if (['he', 'she', 'they', 'him', 'her'].contains(refTextLower)) {
            typeScore = ctx.type == ContextNodeType.person ? 1.0 : 0.0;
          } else {
            // 'it'
            typeScore = ctx.type != ContextNodeType.person ? 0.90 : 0.20;
          }
          break;
        case ReferenceCategory.demonstrative:
          // 'this', 'that'
          typeScore = ctx.type != ContextNodeType.person ? 0.95 : 0.30;
          break;
        case ReferenceCategory.definiteNounPhrase:
          if (refTextLower.contains('project')) {
            typeScore = ctx.type == ContextNodeType.project ? 1.0 : 0.20;
          } else if (refTextLower.contains('meeting') || refTextLower.contains('discussion')) {
            typeScore = ctx.type == ContextNodeType.episode || ctx.type == ContextNodeType.topic ? 1.0 : 0.20;
          } else if (refTextLower.contains('deployment') || refTextLower.contains('testing')) {
            typeScore = (ctx.type == ContextNodeType.activity || ctxNameLower.contains('deployment')) ? 1.0 : 0.10;
          } else {
            typeScore = ctxNameLower.contains(refTextLower.replaceAll('the ', '')) ? 0.90 : 0.40;
          }
          break;
        case ReferenceCategory.taskReference:
          typeScore = (ctx.type == ContextNodeType.task || ctx.type == ContextNodeType.activity) ? 1.0 : 0.20;
          break;
        case ReferenceCategory.unknown:
          typeScore = 0.50;
          break;
      }

      if (typeScore <= 0.10) continue;
      signals['typeCompatibility'] = typeScore;

      // Recency / Temporal
      final diffHours = noteTimestamp.difference(ctx.updatedAt).inHours.abs();
      final double temporalScore = diffHours <= 2 ? 0.95 : (diffHours <= 24 ? 0.80 : math.max(0.1, math.exp(-diffHours / 72.0)));
      signals['temporal'] = temporalScore;

      // Context Continuity
      final double continuityScore = (activeContextId != null && activeContextId == ctx.id) ? 1.0 : 0.50;
      signals['continuity'] = continuityScore;

      // Lexical alignment
      double lexicalScore = 0.50;
      if (refTextLower.contains(ctxNameLower) || ctxNameLower.contains(refTextLower.replaceAll('the ', ''))) {
        lexicalScore = 1.0;
      }
      signals['lexical'] = lexicalScore;

      final finalScore = (typeScore * 0.35) + (temporalScore * 0.30) + (continuityScore * 0.20) + (lexicalScore * 0.15);

      candidates.add(ReferentCandidate(
        referentId: ctx.id,
        referentName: ctx.name,
        referentType: ctx.type.name,
        sourceNoteId: ctx.originatingMemoryId ?? '',
        confidence: finalScore.clamp(0.0, 1.0),
        signals: signals,
        reasoning: 'Context "${ctx.name}" matches type $category with ${(finalScore * 100).toStringAsFixed(0)}% confidence.',
      ));
    }

    // 2. Evaluate Entities from Recent Notes
    for (final note in recentNotes.take(10)) {
      final noteDate = DateTime.fromMillisecondsSinceEpoch(note.createdAt);
      final diffHours = noteTimestamp.difference(noteDate).inHours.abs();
      final temporalScore = diffHours <= 2 ? 0.95 : (diffHours <= 24 ? 0.80 : math.max(0.1, math.exp(-diffHours / 72.0)));

      final entities = await db.entities.getEntitiesForMemory(note.id);
      for (final entity in entities) {
        final entityTypeLower = entity.type.toLowerCase();
        final entityNameLower = entity.name.toLowerCase();
        final signals = <String, double>{};
        double typeScore = 0.0;

        switch (category) {
          case ReferenceCategory.pronoun:
            if (['he', 'she', 'they', 'him', 'her'].contains(refTextLower)) {
              typeScore = entityTypeLower == 'person' ? 1.0 : 0.0;
            } else {
              typeScore = entityTypeLower != 'person' ? 0.90 : 0.20;
            }
            break;
          case ReferenceCategory.demonstrative:
            typeScore = entityTypeLower != 'person' ? 0.95 : 0.30;
            break;
          case ReferenceCategory.definiteNounPhrase:
            if (refTextLower.contains('project')) {
              typeScore = entityTypeLower == 'project' ? 1.0 : 0.20;
            } else if (refTextLower.contains('meeting') || refTextLower.contains('discussion')) {
              typeScore = entityTypeLower == 'event' ? 1.0 : 0.20;
            } else {
              typeScore = entityNameLower.contains(refTextLower.replaceAll('the ', '')) ? 0.95 : 0.40;
            }
            break;
          case ReferenceCategory.taskReference:
            typeScore = entityTypeLower == 'task' ? 1.0 : 0.20;
            break;
          case ReferenceCategory.unknown:
            typeScore = 0.50;
            break;
        }

        if (typeScore <= 0.10) continue;
        signals['typeCompatibility'] = typeScore;
        signals['temporal'] = temporalScore;

        final double lexicalScore = entityNameLower.contains(refTextLower.replaceAll('the ', '')) ? 1.0 : 0.50;
        signals['lexical'] = lexicalScore;

        final finalScore = (typeScore * 0.40) + (temporalScore * 0.40) + (lexicalScore * 0.20);

        candidates.add(ReferentCandidate(
          referentId: entity.id,
          referentName: entity.name,
          referentType: entity.type,
          sourceNoteId: note.id,
          confidence: finalScore.clamp(0.0, 1.0),
          signals: signals,
          reasoning: 'Entity "${entity.name}" from recent note matches $category.',
        ));
      }
    }

    return candidates;
  }
}
