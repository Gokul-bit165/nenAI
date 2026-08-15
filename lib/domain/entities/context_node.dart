/// Recognized semantic types of contextual memory nodes.
enum ContextNodeType {
  episode,
  project,
  topic,
  activity,
  task,
  concept,
  person,
  organization,
  custom;

  static ContextNodeType fromString(String val) {
    return ContextNodeType.values.firstWhere(
      (e) => e.name.toLowerCase() == val.toLowerCase().trim(),
      orElse: () => ContextNodeType.custom,
    );
  }
}

/// Domain entity representing a node in the Hierarchical Contextual Memory Graph.
class ContextNode {
  const ContextNode({
    required this.id,
    required this.name,
    this.type = ContextNodeType.custom,
    this.description,
    this.originatingMemoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final ContextNodeType type;
  final String? description;
  final String? originatingMemoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContextNode copyWith({
    String? id,
    String? name,
    ContextNodeType? type,
    String? description,
    String? originatingMemoryId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ContextNode(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      originatingMemoryId: originatingMemoryId ?? this.originatingMemoryId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ContextNode && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ContextNode(id: $id, name: $name, type: ${type.name})';
}

/// Domain entity representing a directed edge in the Contextual Memory DAG.
/// Connects a parent/source context to a child/target context with full provenance.
class ContextEdge {
  const ContextEdge({
    required this.id,
    required this.sourceContextId,
    required this.targetContextId,
    required this.relationType,
    this.confidence = 1.0,
    this.originatingMemoryId,
    this.evidence,
    required this.createdAt,
    required this.updatedAt,
    this.sourceNode,
    this.targetNode,
  });

  final String id;

  /// Parent / enclosing context ID (e.g. "Meeting with Dean")
  final String sourceContextId;

  /// Child / sub-context ID (e.g. "Project Discussion" or "ReadSmart AI")
  final String targetContextId;

  /// Semantic relation: 'part_of', 'sub_topic', 'activity_of', 'outcome_of', 'relates_to'
  final String relationType;

  /// Confidence score in [0.0, 1.0]
  final double confidence;

  /// ID of the memory/note that established or evidenced this link
  final String? originatingMemoryId;

  /// Snippet or textual reasoning supporting this link
  final String? evidence;

  final DateTime createdAt;
  final DateTime updatedAt;

  /// Optional hydrated references
  final ContextNode? sourceNode;
  final ContextNode? targetNode;

  ContextEdge copyWith({
    String? id,
    String? sourceContextId,
    String? targetContextId,
    String? relationType,
    double? confidence,
    String? originatingMemoryId,
    String? evidence,
    DateTime? createdAt,
    DateTime? updatedAt,
    ContextNode? sourceNode,
    ContextNode? targetNode,
  }) {
    return ContextEdge(
      id: id ?? this.id,
      sourceContextId: sourceContextId ?? this.sourceContextId,
      targetContextId: targetContextId ?? this.targetContextId,
      relationType: relationType ?? this.relationType,
      confidence: confidence ?? this.confidence,
      originatingMemoryId: originatingMemoryId ?? this.originatingMemoryId,
      evidence: evidence ?? this.evidence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sourceNode: sourceNode ?? this.sourceNode,
      targetNode: targetNode ?? this.targetNode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ContextEdge && other.id == id);

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ContextEdge($sourceContextId --[$relationType]--> $targetContextId, conf: $confidence)';
}

/// Connects a raw memory note to one or more contextual nodes.
class MemoryContextLink {
  const MemoryContextLink({
    required this.memoryId,
    required this.contextId,
    this.role = 'contained_in',
    this.confidence = 1.0,
    this.evidence,
    required this.createdAt,
    this.contextNode,
  });

  final String memoryId;
  final String contextId;
  final String role;
  final double confidence;
  final String? evidence;
  final DateTime createdAt;
  final ContextNode? contextNode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryContextLink &&
          other.memoryId == memoryId &&
          other.contextId == contextId);

  @override
  int get hashCode => Object.hash(memoryId, contextId);

  @override
  String toString() =>
      'MemoryContextLink(memory: $memoryId, context: $contextId, role: $role)';
}

/// Recursive hierarchical context subtree representation for rich visualization and LLM prompts.
class ContextSubtree {
  const ContextSubtree({
    required this.node,
    this.children = const [],
    this.inboundEdges = const [],
    this.outboundEdges = const [],
    this.linkedMemoryIds = const [],
  });

  final ContextNode node;
  final List<ContextSubtree> children;
  final List<ContextEdge> inboundEdges;
  final List<ContextEdge> outboundEdges;
  final List<String> linkedMemoryIds;

  List<ContextNode> get allNodes {
    final nodes = <ContextNode>[node];
    for (final child in children) {
      nodes.addAll(child.allNodes);
    }
    return nodes;
  }

  /// Returns a formatted ASCII tree string for easy inspection and LLM prompt context injection.
  String toTreeString([String prefix = '', String childPrefix = '']) {
    final buffer = StringBuffer();
    buffer.writeln('$prefix${node.name} [${node.type.name}]');
    for (var i = 0; i < children.length; i++) {
      final isLast = i == children.length - 1;
      final branch = isLast ? ' └── ' : ' ├── ';
      final nextChildPrefix = isLast ? '     ' : ' │   ';
      buffer.write(children[i].toTreeString('$childPrefix$branch', '$childPrefix$nextChildPrefix'));
    }
    return buffer.toString();
  }
}
