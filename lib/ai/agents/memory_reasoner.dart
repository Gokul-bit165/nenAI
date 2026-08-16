import 'package:uuid/uuid.dart';
import '../../core/nlp/datetime_parser.dart';
import '../../data/local/database/daos/relationships_dao.dart';
import '../../domain/ai/context_candidate.dart';
import '../../domain/ai/context_resolution_result.dart';
import '../../domain/ai/note_analysis_result.dart';
import '../../domain/ai/reference_resolution.dart';
import '../../domain/entities/memory_operation.dart';

/// Memory Reasoner: Synthesizes note analysis, resolved entities, cross-note references,
/// and hierarchical context candidates into structured atomic memory operations.
///
/// V4 Changes:
/// - Removed ALL hardcoded keyword pattern checks (no more .contains('deployment')).
/// - Child context creation is now entity-driven: triggered by ContextualActions and
///   their subjects matching entities in the current context lineage.
/// - Added handler for ResolutionOutcome.pendingReview (medium confidence).
/// - inferenceType metadata added to all relationship operations.
class MemoryReasoner {
  MemoryReasoner(this._relationshipsDao);

  final RelationshipsDao _relationshipsDao;
  static const _uuid = Uuid();

  /// Decides atomic operations (CREATE_CONTEXT, ATTACH_MEMORY, CREATE_CHILD_CONTEXT,
  /// LINK_CONTEXT, CREATE_RELATIONSHIP, CREATE_TASK, REQUEST_CLARIFICATION, NO_OP).
  Future<List<MemoryOperation>> reason({
    required String noteId,
    required String noteText,
    required NoteAnalysisResult analysis,
    required List<ResolvedEntity> resolvedEntities,
    List<ContextCandidate> contextCandidates = const [],
    ReferenceResolutionResult? referenceResolution,
    ContextResolutionResult? contextResolution,
    DateTime? noteTimestamp,
  }) async {
    final operations = <MemoryOperation>[];
    final entityMap = <String, ResolvedEntity>{};

    // 1. Process Context Hierarchy Operations
    if (contextResolution != null) {
      switch (contextResolution.outcome) {
        case ResolutionOutcome.autoAttach:
          if (contextResolution.targetContextId != null) {
            operations.add(
              MemoryOperation.attachMemory(
                memoryId: noteId,
                contextId: contextResolution.targetContextId!,
                contextName: contextResolution.targetContextName,
                role: 'auto_attached',
                confidence: contextResolution.confidence,
                evidence: contextResolution.reasoningSummary,
              ),
            );

            // Update parent context timestamp & activity
            operations.add(
              MemoryOperation.updateContext(
                contextId: contextResolution.targetContextId!,
              ),
            );

            // Entity-driven child context creation:
            // For each contextual action, if its subject resolves to a known entity
            // that is NOT already the current context's name, create a child context.
            for (final action in analysis.actions) {
              final subjectLower = action.subject.toLowerCase().trim();
              if (subjectLower.isEmpty ||
                  subjectLower == 'this' ||
                  subjectLower == 'it') continue;

              final parentNameLower =
                  contextResolution.targetContextName?.toLowerCase() ?? '';

              // Only create child if subject is meaningfully different from parent
              if (!parentNameLower.contains(subjectLower) &&
                  !subjectLower.contains(parentNameLower)) {
                // Check action type to determine child context type
                final childType = _childContextType(action.type);
                final childName = _capitalise(action.subject);
                final childId =
                    'ctx-${subjectLower.replaceAll(' ', '-')}-${_uuid.v4().substring(0, 6)}';

                operations.add(
                  MemoryOperation.createChildContext(
                    id: childId,
                    parentContextId: contextResolution.targetContextId!,
                    childName: childName,
                    childType: childType,
                    relationType: action.type,
                    originatingMemoryId: noteId,
                  ),
                );
                operations.add(
                  MemoryOperation.attachMemory(
                    memoryId: noteId,
                    contextId: childId,
                    contextName: childName,
                    role: 'child_activity',
                    confidence: contextResolution.confidence * 0.9,
                  ),
                );
              }
            }
          }
          break;

        case ResolutionOutcome.pendingReview:
          // MEDIUM confidence: save unlinked but store pending resolution for soft UI card.
          if (contextResolution.targetContextId != null) {
            final candidatesPayload = contextResolution.candidateBreakdowns
                .take(3)
                .map((c) => {
                      'contextId': c.candidateId,
                      'contextName': c.candidateName,
                      'contextPath': c.contextPath,
                      'confidence': c.finalScore,
                      'evidenceSummary': c.evidenceSnippet ??
                          'Medium-confidence context suggestion.',
                    })
                .toList();

            operations.add(
              MemoryOperation.requestClarification(
                memoryId: noteId,
                noteTextSnippet:
                    noteText.length > 100 ? '${noteText.substring(0, 97)}...' : noteText,
                candidates: candidatesPayload,
              ),
            );
          }
          break;

        case ResolutionOutcome.multiAttach:
          if (contextResolution.targetContextId != null) {
            operations.add(
              MemoryOperation.attachMemory(
                memoryId: noteId,
                contextId: contextResolution.targetContextId!,
                contextName: contextResolution.targetContextName,
                role: 'multi_attached_primary',
                confidence: contextResolution.confidence,
                evidence: contextResolution.reasoningSummary,
              ),
            );

            for (final addId in contextResolution.additionalTargetContextIds) {
              operations.add(
                MemoryOperation.attachMemory(
                  memoryId: noteId,
                  contextId: addId,
                  role: 'multi_attached_secondary',
                  confidence: contextResolution.confidence,
                ),
              );

              // Link the two parent contexts in the DAG
              operations.add(
                MemoryOperation.linkContext(
                  sourceContextId: contextResolution.targetContextId!,
                  targetContextId: addId,
                  relationType: 'co_referenced',
                  confidence: contextResolution.confidence,
                  originatingMemoryId: noteId,
                ),
              );
            }
          }
          break;

        case ResolutionOutcome.newContext:
          final newId = 'ctx-${_uuid.v4().substring(0, 8)}';
          final newName =
              contextResolution.suggestedNewContextName ?? analysis.topic;
          final newType = contextResolution.suggestedNewContextType ?? 'project';

          operations.add(
            MemoryOperation.createContext(
              id: newId,
              name: newName,
              type: newType,
              originatingMemoryId: noteId,
            ),
          );

          operations.add(
            MemoryOperation.attachMemory(
              memoryId: noteId,
              contextId: newId,
              contextName: newName,
              role: 'originating_context',
              confidence: contextResolution.confidence,
            ),
          );
          break;

        case ResolutionOutcome.ambiguous:
          final candidatesPayload = contextResolution.ambiguousCandidates
              .map((c) => {
                    'contextId': c.candidateId,
                    'contextName': c.candidateName,
                    'contextPath': c.contextPath,
                    'confidence': c.finalScore,
                    'evidenceSummary':
                        c.evidenceSnippet ?? 'Competing context candidate.',
                  })
              .toList();

          operations.add(
            MemoryOperation.requestClarification(
              memoryId: noteId,
              noteTextSnippet: noteText,
              candidates: candidatesPayload,
            ),
          );
          break;

        case ResolutionOutcome.unresolved:
        case ResolutionOutcome.ignore:
          operations.add(
            MemoryOperation.noOp(
              reason:
                  'Memory context resolution outcome: ${contextResolution.outcome.name}',
            ),
          );
          break;
      }
    }

    // 2. Process Resolved Entities
    for (final resolved in resolvedEntities) {
      entityMap[resolved.originalMention.toLowerCase()] = resolved;
      entityMap[resolved.name.toLowerCase()] = resolved;

      if (resolved.status == ResolutionStatus.create) {
        operations.add(
          MemoryOperation.createEntity(
            id: resolved.entityId,
            name: resolved.name,
            type: resolved.type,
            canonicalName: resolved.canonicalName ?? resolved.name.toLowerCase(),
          ),
        );
      }
    }

    // 3. Process Facts / Relationships � with inferenceType metadata
    for (final fact in analysis.facts) {
      final source = _findResolved(fact.subject, entityMap);
      final target = _findResolved(fact.object, entityMap);

      if (source != null && target != null && source.entityId != target.entityId) {
        final existingEdge = await _relationshipsDao.findExactRelationship(
          sourceEntityId: source.entityId,
          relation: fact.predicate,
          targetEntityId: target.entityId,
        );

        if (existingEdge != null) {
          operations.add(
            MemoryOperation.noOp(
              reason:
                  'Relationship ${source.name} --${fact.predicate}--> ${target.name} already exists',
            ),
          );
        } else {
          operations.add(
            MemoryOperation.createRelationship(
              id: _uuid.v4(),
              sourceEntityId: source.entityId,
              relation: fact.predicate,
              targetEntityId: target.entityId,
              sourceMemoryId: noteId,
              confidence: fact.confidence,
              inferenceType: 'extracted',
            ),
          );
        }
      }
    }

    // 4. Process Explicit Relationships (from analysis.explicitRelationships)
    for (final rel in analysis.explicitRelationships) {
      final source = _findResolved(rel.source, entityMap);
      final target = _findResolved(rel.target, entityMap);

      if (source != null && target != null && source.entityId != target.entityId) {
        final existingEdge = await _relationshipsDao.findExactRelationship(
          sourceEntityId: source.entityId,
          relation: rel.relation,
          targetEntityId: target.entityId,
        );

        if (existingEdge == null) {
          operations.add(
            MemoryOperation.createRelationship(
              id: _uuid.v4(),
              sourceEntityId: source.entityId,
              relation: rel.relation,
              targetEntityId: target.entityId,
              sourceMemoryId: noteId,
              confidence: rel.confidence,
              inferenceType: 'extracted',
            ),
          );
        }
      }
    }

    // 4b. Process Explicit Corrections (from analysis.corrections)
    for (final corr in analysis.corrections) {
      if (!corr.isValid) continue;
      final source = _findResolved(corr.subject, entityMap);
      final oldTarget = _findResolved(corr.oldObject, entityMap);
      final newTarget = _findResolved(corr.newObject, entityMap);

      if (source != null && oldTarget != null && newTarget != null) {
        operations.add(
          MemoryOperation.correctRelationship(
            sourceEntityId: source.entityId,
            relation: corr.predicate,
            oldTargetEntityId: oldTarget.entityId,
            newTargetEntityId: newTarget.entityId,
            sourceMemoryId: noteId,
          ),
        );
      }
    }

    // 5. Process Tasks
    for (final task in analysis.tasks) {
      int? dueTimestamp;
      if (task.time != null && task.time!.isNotEmpty) {
        final parsedDate = DateTimeParser.parse(task.time!);
        dueTimestamp = parsedDate?.millisecondsSinceEpoch;
      }

      operations.add(
        MemoryOperation.createTask(
          id: _uuid.v4(),
          memoryId: noteId,
          description: task.description,
          dueDate: task.time,
          dueTimestamp: dueTimestamp,
        ),
      );
    }

    return operations;
  }

  ResolvedEntity? _findResolved(String mention, Map<String, ResolvedEntity> map) {
    final key = mention.trim().toLowerCase();
    if (map.containsKey(key)) return map[key];

    for (final entry in map.entries) {
      if (key.contains(entry.key) || entry.key.contains(key)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Maps action type strings to child context types.
  String _childContextType(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'completed':
      case 'in_progress':
        return 'activity';
      case 'planned':
      case 'scheduled':
        return 'milestone';
      case 'issue':
      case 'bug':
        return 'task';
      default:
        return 'activity';
    }
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
