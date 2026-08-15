import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:nenai/data/local/database/app_database.dart';
import 'package:nenai/data/repositories/context_repository_impl.dart';
import 'package:nenai/domain/entities/context_node.dart';

void main() {
  late AppDatabase db;
  late ContextRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ContextRepositoryImpl(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Phase 1: Hierarchical Contextual Memory Model Tests', () {
    test('1. Creating context nodes with diverse semantic types', () async {
      final now = DateTime.now();

      final node1 = ContextNode(
        id: 'ctx-meeting-dean',
        name: 'Meeting with Dean',
        type: ContextNodeType.episode,
        description: 'Semester project review with the Dean',
        originatingMemoryId: 'note-1',
        createdAt: now,
        updatedAt: now,
      );

      final node2 = ContextNode(
        id: 'ctx-proj-disc',
        name: 'Project Discussion',
        type: ContextNodeType.topic,
        createdAt: now,
        updatedAt: now,
      );

      final node3 = ContextNode(
        id: 'ctx-readsmart',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      );

      final node4 = ContextNode(
        id: 'ctx-fc',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      );

      final node5 = ContextNode(
        id: 'ctx-deployment',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      );

      final node6 = ContextNode(
        id: 'ctx-testing',
        name: 'Testing',
        type: ContextNodeType.task,
        createdAt: now,
        updatedAt: now,
      );

      await repository.upsertNode(node1);
      await repository.upsertNode(node2);
      await repository.upsertNode(node3);
      await repository.upsertNode(node4);
      await repository.upsertNode(node5);
      await repository.upsertNode(node6);

      // Verify retrieval by ID
      final fetched1 = await repository.getNodeById('ctx-meeting-dean');
      expect(fetched1, isNotNull);
      expect(fetched1!.name, 'Meeting with Dean');
      expect(fetched1.type, ContextNodeType.episode);
      expect(fetched1.originatingMemoryId, 'note-1');

      // Verify retrieval by Name
      final fetchedByName = await repository.getNodeByName('ReadSmart AI');
      expect(fetchedByName, isNotNull);
      expect(fetchedByName!.id, 'ctx-readsmart');
      expect(fetchedByName.type, ContextNodeType.project);

      // Verify search
      final searchResults = await repository.searchNodes('project');
      expect(searchResults.any((n) => n.name == 'Project Discussion'), isTrue);
    });

    test('2. Parent-child relationships and contextual hierarchy', () async {
      final now = DateTime.now();

      // Nodes
      await repository.upsertNode(ContextNode(
        id: 'ctx-meeting-dean',
        name: 'Meeting with Dean',
        type: ContextNodeType.episode,
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertNode(ContextNode(
        id: 'ctx-proj-disc',
        name: 'Project Discussion',
        type: ContextNodeType.topic,
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertNode(ContextNode(
        id: 'ctx-readsmart',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertNode(ContextNode(
        id: 'ctx-fc',
        name: 'FC',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      // Edges: Meeting with Dean -> Project Discussion -> [ReadSmart AI, FC]
      await repository.upsertEdge(ContextEdge(
        id: 'edge-1',
        sourceContextId: 'ctx-meeting-dean',
        targetContextId: 'ctx-proj-disc',
        relationType: 'has_topic',
        confidence: 0.98,
        originatingMemoryId: 'note-1',
        evidence: 'Meeting agenda focused on project discussion',
        createdAt: now,
        updatedAt: now,
      ));

      await repository.upsertEdge(ContextEdge(
        id: 'edge-2',
        sourceContextId: 'ctx-proj-disc',
        targetContextId: 'ctx-readsmart',
        relationType: 'sub_project',
        confidence: 0.95,
        originatingMemoryId: 'note-1',
        evidence: 'Projects discussed were ReadSmart AI and FC',
        createdAt: now,
        updatedAt: now,
      ));

      await repository.upsertEdge(ContextEdge(
        id: 'edge-3',
        sourceContextId: 'ctx-proj-disc',
        targetContextId: 'ctx-fc',
        relationType: 'sub_project',
        confidence: 0.95,
        originatingMemoryId: 'note-1',
        evidence: 'Projects discussed were ReadSmart AI and FC',
        createdAt: now,
        updatedAt: now,
      ));

      // Verify children of 'ctx-proj-disc'
      final childrenOfDisc = await repository.getChildren('ctx-proj-disc');
      expect(childrenOfDisc.length, 2);
      expect(childrenOfDisc.map((c) => c.name).toSet(), containsAll(['ReadSmart AI', 'FC']));

      // Verify parents of 'ctx-readsmart'
      final parentsOfReadSmart = await repository.getParents('ctx-readsmart');
      expect(parentsOfReadSmart.length, 1);
      expect(parentsOfReadSmart.first.name, 'Project Discussion');
    });

    test('3. Multiple parents support (DAG Hierarchy)', () async {
      final now = DateTime.now();

      // Nodes: 2 distinct root episodes sharing a child project
      await repository.upsertNode(ContextNode(
        id: 'ctx-meeting-dean',
        name: 'Meeting with Dean',
        type: ContextNodeType.episode,
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertNode(ContextNode(
        id: 'ctx-internship',
        name: 'Summer Internship',
        type: ContextNodeType.episode,
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertNode(ContextNode(
        id: 'ctx-readsmart',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertNode(ContextNode(
        id: 'ctx-deployment',
        name: 'Deployment',
        type: ContextNodeType.activity,
        createdAt: now,
        updatedAt: now,
      ));

      // Edges: Both "Meeting with Dean" and "Summer Internship" point to "ReadSmart AI"
      await repository.upsertEdge(ContextEdge(
        id: 'edge-dean-readsmart',
        sourceContextId: 'ctx-meeting-dean',
        targetContextId: 'ctx-readsmart',
        relationType: 'discussed_in',
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertEdge(ContextEdge(
        id: 'edge-intern-readsmart',
        sourceContextId: 'ctx-internship',
        targetContextId: 'ctx-readsmart',
        relationType: 'assigned_in',
        createdAt: now,
        updatedAt: now,
      ));
      await repository.upsertEdge(ContextEdge(
        id: 'edge-readsmart-deploy',
        sourceContextId: 'ctx-readsmart',
        targetContextId: 'ctx-deployment',
        relationType: 'has_activity',
        createdAt: now,
        updatedAt: now,
      ));

      // ReadSmart AI has 2 parents in the DAG
      final parents = await repository.getParents('ctx-readsmart');
      expect(parents.length, 2);
      expect(parents.map((p) => p.name).toSet(), containsAll(['Meeting with Dean', 'Summer Internship']));

      // Ancestors of "Deployment" traverses both DAG branches
      final ancestors = await repository.getAncestors('ctx-deployment');
      expect(ancestors.length, 3);
      expect(ancestors.map((a) => a.name).toSet(), containsAll([
        'ReadSmart AI',
        'Meeting with Dean',
        'Summer Internship',
      ]));
    });

    test('4. Linking notes/memories to context nodes with provenance', () async {
      final now = DateTime.now();

      await repository.upsertNode(ContextNode(
        id: 'ctx-readsmart',
        name: 'ReadSmart AI',
        type: ContextNodeType.project,
        createdAt: now,
        updatedAt: now,
      ));

      // Link Note 1 to ReadSmart AI
      await repository.linkMemory(MemoryContextLink(
        memoryId: 'note-1',
        contextId: 'ctx-readsmart',
        role: 'mentions',
        confidence: 0.95,
        evidence: 'Projects were ReadSmart AI and FC',
        createdAt: now,
      ));

      // Link Note 2 to ReadSmart AI
      await repository.linkMemory(MemoryContextLink(
        memoryId: 'note-2',
        contextId: 'ctx-readsmart',
        role: 'activity_record',
        confidence: 0.90,
        evidence: 'I finished the deployment',
        createdAt: now,
      ));

      final contextsForNote1 = await repository.getContextsForMemory('note-1');
      expect(contextsForNote1.length, 1);
      expect(contextsForNote1.first.name, 'ReadSmart AI');

      final memoriesForReadSmart = await repository.getMemoriesForContext('ctx-readsmart');
      expect(memoriesForReadSmart.length, 2);
      expect(memoriesForReadSmart, containsAll(['note-1', 'note-2']));
    });

    test('5. Retrieving full context subtrees with hierarchy', () async {
      final now = DateTime.now();

      // Build hierarchical tree:
      // Meeting with Dean
      //  └── Project Discussion
      //       ├── ReadSmart AI
      //       │    └── Deployment
      //       │         └── Testing
      //       └── FC
      await repository.upsertNode(ContextNode(id: 'n-meeting', name: 'Meeting with Dean', type: ContextNodeType.episode, createdAt: now, updatedAt: now));
      await repository.upsertNode(ContextNode(id: 'n-disc', name: 'Project Discussion', type: ContextNodeType.topic, createdAt: now, updatedAt: now));
      await repository.upsertNode(ContextNode(id: 'n-readsmart', name: 'ReadSmart AI', type: ContextNodeType.project, createdAt: now, updatedAt: now));
      await repository.upsertNode(ContextNode(id: 'n-fc', name: 'FC', type: ContextNodeType.project, createdAt: now, updatedAt: now));
      await repository.upsertNode(ContextNode(id: 'n-deploy', name: 'Deployment', type: ContextNodeType.activity, createdAt: now, updatedAt: now));
      await repository.upsertNode(ContextNode(id: 'n-test', name: 'Testing', type: ContextNodeType.task, createdAt: now, updatedAt: now));

      await repository.upsertEdge(ContextEdge(id: 'e-1', sourceContextId: 'n-meeting', targetContextId: 'n-disc', relationType: 'has_topic', createdAt: now, updatedAt: now));
      await repository.upsertEdge(ContextEdge(id: 'e-2', sourceContextId: 'n-disc', targetContextId: 'n-readsmart', relationType: 'project', createdAt: now, updatedAt: now));
      await repository.upsertEdge(ContextEdge(id: 'e-3', sourceContextId: 'n-disc', targetContextId: 'n-fc', relationType: 'project', createdAt: now, updatedAt: now));
      await repository.upsertEdge(ContextEdge(id: 'e-4', sourceContextId: 'n-readsmart', targetContextId: 'n-deploy', relationType: 'activity', createdAt: now, updatedAt: now));
      await repository.upsertEdge(ContextEdge(id: 'e-5', sourceContextId: 'n-deploy', targetContextId: 'n-test', relationType: 'task', createdAt: now, updatedAt: now));

      final subtree = await repository.getSubtree('n-meeting');
      expect(subtree, isNotNull);
      expect(subtree!.node.name, 'Meeting with Dean');
      expect(subtree.children.length, 1);
      expect(subtree.children.first.node.name, 'Project Discussion');

      final projectChildren = subtree.children.first.children;
      expect(projectChildren.length, 2);
      expect(projectChildren.map((c) => c.node.name).toSet(), containsAll(['ReadSmart AI', 'FC']));

      final readsmartSubtree = projectChildren.firstWhere((c) => c.node.name == 'ReadSmart AI');
      expect(readsmartSubtree.children.first.node.name, 'Deployment');
      expect(readsmartSubtree.children.first.children.first.node.name, 'Testing');

      // Test formatted tree rendering
      final treeString = subtree.toTreeString();
      expect(treeString.contains('Meeting with Dean [episode]'), isTrue);
      expect(treeString.contains('Project Discussion [topic]'), isTrue);
      expect(treeString.contains('ReadSmart AI [project]'), isTrue);
      expect(treeString.contains('FC [project]'), isTrue);
      expect(treeString.contains('Deployment [activity]'), isTrue);
      expect(treeString.contains('Testing [task]'), isTrue);
    });

    test('6. Preserving full provenance metadata on edges', () async {
      final now = DateTime.now();

      await repository.upsertNode(ContextNode(id: 'n-dean', name: 'Meeting with Dean', createdAt: now, updatedAt: now));
      await repository.upsertNode(ContextNode(id: 'n-rs', name: 'ReadSmart AI', createdAt: now, updatedAt: now));

      const evidenceText = 'Dean specifically requested priority on ReadSmart AI delivery.';
      await repository.upsertEdge(ContextEdge(
        id: 'edge-prov',
        sourceContextId: 'n-dean',
        targetContextId: 'n-rs',
        relationType: 'discussed_in',
        confidence: 0.94,
        originatingMemoryId: 'note-spec-123',
        evidence: evidenceText,
        createdAt: now,
        updatedAt: now,
      ));

      final childEdges = await repository.getChildEdges('n-dean');
      expect(childEdges.length, 1);
      final edge = childEdges.first;
      expect(edge.sourceContextId, 'n-dean');
      expect(edge.targetContextId, 'n-rs');
      expect(edge.relationType, 'discussed_in');
      expect(edge.confidence, 0.94);
      expect(edge.originatingMemoryId, 'note-spec-123');
      expect(edge.evidence, evidenceText);
    });
  });
}
