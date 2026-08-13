# NENAI V4 Autonomous Contextual Memory Engine Plan

> **Document Version:** 4.0-PLAN  
> **Status:** Proposed Implementation Plan  
> **Date:** August 2026  
> **Repository:** `nenAI` (Flutter / Dart)  
> **Prerequisite:** [docs/V3_ARCHITECTURE_BASELINE.md](file:///c:/project1/nenAI/docs/V3_ARCHITECTURE_BASELINE.md)  
> **Current Baseline Verification:** `flutter analyze` (0 issues) | `flutter test` (9/9 passed)

---

## 1. Executive Summary & Objective

The goal of **NENAI V4** is to transform NENAI from an isolated note-taking assistant with AI enrichment into a **true Autonomous Contextual Personal Memory Engine**.

In V3, each note is analyzed independently: entities, keywords, summary, and tasks are extracted in isolation, and links are based strictly on flat vector cosine similarity ($\ge 0.75$).

In V4, NENAI will **understand memories in context**:
1. **Contextual Memory Formation:** When a new note is captured, NENAI determines which ongoing project, meeting, person, or episodic context it belongs to.
2. **Hierarchical Memory Trees:** Memories and actions are structured into multi-level episodic trees (e.g. *Meeting with Dean $\rightarrow$ Project Discussion $\rightarrow$ ReadSmart AI $\rightarrow$ Deployment $\rightarrow$ Testing*).
3. **Autonomous Ambiguity Resolution:** If multiple candidate contexts are similarly likely (e.g., both "ReadSmart AI" and "FC" were discussed in the meeting), NENAI **does not guess**. It flags the ambiguity, pauses automatic context assignment, and presents an interactive clarification card to the user.
4. **Preservation of Existing Architecture:** Zero regressions or rewrites of working V3 modules (Drift SQLite, ONNX embeddings, Gemma 3 1B LiteRT, Clean Architecture + MVVM, Riverpod, GoRouter, MCP tools).

---

## 2. Current Implementation Audit (What Already Exists)

The following components are fully functional and verified in the current baseline:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION LAYER (MVVM)                          │
│  HomeScreen │ SearchScreen │ TopicsScreen (ObsidianGraph) │ ChatScreen │... │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                             DOMAIN LAYER                                    │
│  Entities: Note, Cluster, KnowledgeEntity, KnowledgeRelationship,           │
│            MemoryTask, MemoryOperation, ResolvedEntity, NoteAnalysisResult  │
│  UseCases: CreateNote, UpdateNote, GetNotes, SearchNotes, GetClusters...    │
│  Engines:  NoteIntelligenceEngine (Gemma 3 1B), EmbeddingEngine (ONNX 384D) │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         AI AGENTS & REASONING SUITE                         │
│  UnderstandingAgent ──► EntityResolver ──► MemoryReasoner ──► MemoryRouter  │
│  MemoryLinker (384D KNN) │ RetrievalPlanner │ HybridRetriever (3-Way RRF)   │
│  QueryUnderstandingAgent │ ChatService │ ToolExecutor (MCP Tools)           │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          DATA LAYER (PERSISTENCE)                           │
│  Drift SQLite: notes, embeddings, clusters, chat_messages, entities,        │
│                relationships, tasks, memory_entities (Schema v3)            │
│  VectorStore:  384D float vectors (1536-byte BLOBs, IEEE 754 LE)            │
│  Background:   NoteProcessingIsolate (Foreground/iOS), WorkManager (Android)│
└─────────────────────────────────────────────────────────────────────────────┘
```

### 2.1 Verified Existing Modules
- **Drift SQLite Database (`nenai.db`, v3):** 8 tables ([`notes`](file:///c:/project1/nenAI/lib/data/local/database/tables/notes_table.dart), [`embeddings`](file:///c:/project1/nenAI/lib/data/local/database/tables/embeddings_table.dart), [`clusters`](file:///c:/project1/nenAI/lib/data/local/database/tables/clusters_table.dart), [`chat_messages`](file:///c:/project1/nenAI/lib/data/local/database/tables/chat_messages_table.dart), [`entities`](file:///c:/project1/nenAI/lib/data/local/database/tables/entities_table.dart), [`relationships`](file:///c:/project1/nenAI/lib/data/local/database/tables/relationships_table.dart), [`tasks`](file:///c:/project1/nenAI/lib/data/local/database/tables/tasks_table.dart), [`memory_entities`](file:///c:/project1/nenAI/lib/data/local/database/tables/memory_entities_table.dart)) with 7 DAOs.
- **Pure Domain Entities:** [`Note`](file:///c:/project1/nenAI/lib/domain/entities/note.dart), [`KnowledgeEntity`](file:///c:/project1/nenAI/lib/domain/entities/knowledge_entity.dart), [`KnowledgeRelationship`](file:///c:/project1/nenAI/lib/domain/entities/knowledge_relationship.dart), [`MemoryTask`](file:///c:/project1/nenAI/lib/domain/entities/memory_task.dart), [`MemoryOperation`](file:///c:/project1/nenAI/lib/domain/entities/memory_operation.dart), [`ResolvedEntity`](file:///c:/project1/nenAI/lib/domain/entities/memory_operation.dart#L17), [`NoteAnalysisResult`](file:///c:/project1/nenAI/lib/domain/ai/note_analysis_result.dart).
- **AI Processing Pipeline:** [`UnderstandingAgent`](file:///c:/project1/nenAI/lib/ai/agents/understanding_agent.dart), [`EntityResolver`](file:///c:/project1/nenAI/lib/ai/agents/entity_resolver.dart), [`MemoryReasoner`](file:///c:/project1/nenAI/lib/ai/agents/memory_reasoner.dart), [`MemoryRouter`](file:///c:/project1/nenAI/lib/ai/agents/memory_router.dart), [`MemoryLinker`](file:///c:/project1/nenAI/lib/ai/memory/memory_linker.dart).
- **Retrieval Engine:** [`HybridRetriever`](file:///c:/project1/nenAI/lib/ai/memory/hybrid_retriever.dart) executing 3-Way Reciprocal Rank Fusion (FTS + Vector + Knowledge Graph) and [`MemoryContextBuilder`](file:///c:/project1/nenAI/lib/ai/memory/memory_context_builder.dart).
- **Vector Pipeline:** ONNX `all-MiniLM-L6-v2` 384D embeddings via [`OnnxEmbeddingEngine`](file:///c:/project1/nenAI/lib/ai/onnx/onnx_embedding_engine.dart), [`BertTokenizer`](file:///c:/project1/nenAI/lib/ai/onnx/bert_tokenizer.dart), [`VectorMath`](file:///c:/project1/nenAI/lib/core/utils/vector_math.dart), and [`VectorStore`](file:///c:/project1/nenAI/lib/data/local/vector/vector_store.dart).
- **Chat & MCP Tool Execution:** [`ChatService`](file:///c:/project1/nenAI/lib/ai/chat/chat_service.dart), [`ToolExecutor`](file:///c:/project1/nenAI/lib/mcp/tool_executor.dart), and tools for alarms, calendar events, memory stats, and searches.

---

## 3. Reusability & Modification Matrix

| Component Layer | Existing Asset | Reusability Status | V4 Extension Plan |
|---|---|---|---|
| **Database Schema** | `AppDatabase` (v3) | **100% Reused + Migrated to v4** | Add `pending_memory_resolutions` table and hierarchical relation columns/indexes. |
| **Domain Entities** | `Note`, `KnowledgeEntity`, `KnowledgeRelationship`, `MemoryTask` | **100% Reused** | Add `PendingMemoryResolution` entity and `parentMemoryId` / `contextHierarchyPath` properties. |
| **Entity Resolver** | `EntityResolver` | **100% Reused** | Reused for canonical/fuzzy matching of entity nodes. |
| **Memory Reasoner** | `MemoryReasoner` | **Extended** | Add contextual candidate evaluation and ambiguity check before emitting operations. |
| **Memory Router** | `MemoryRouter` | **Extended** | Add support for `OperationType.createHierarchicalLink` and `OperationType.createPendingResolution`. |
| **Memory Linker** | `MemoryLinker` | **100% Reused** | Continues generating 384D semantic links alongside hierarchical edges. |
| **Hybrid Retriever** | `HybridRetriever` | **Extended** | Add hierarchical tree expansion (fetching parent context and child sub-tasks during retrieval). |
| **Context Builder** | `MemoryContextBuilder` | **Extended** | Format multi-level context trees for grounded prompt assembly. |
| **Chat Service & MCP** | `ChatService`, `ToolExecutor` | **100% Reused + Extended** | Add tool/handler for user to resolve pending disambiguation prompts in chat. |
| **Background Processing**| `NoteProcessingIsolate`, `WorkManager` | **100% Reused** | Integrate the new contextual reasoning step into the async pipeline. |
| **UI Presentation** | Shell, Home, Detail, Topics, Chat | **Extended** | Add Disambiguation Clarification Cards in Home/Chat and Context Tree View in Note Detail. |

---

## 4. V4 Target Behavior: Contextual Memory Engine

### 4.1 Concrete Workflow Example

#### Step 1: Note 1 Ingestion (Context Tree Anchor)
```
User writes:
"I attended the meeting with Dean sir for project discussion. Projects were ReadSmart AI and FC."
```
1. `UnderstandingAgent` extracts:
   - Entities: `Dean` (person), `ReadSmart AI` (project), `FC` (project).
   - Topic: `Meeting with Dean - Project Discussion`.
   - Facts: `Dean --discussed--> ReadSmart AI`, `Dean --discussed--> FC`.
2. `MemoryReasoner` + `MemoryRouter` create:
   - Entity nodes: `Dean`, `ReadSmart AI`, `FC`.
   - Relationships: `Dean --discussed--> ReadSmart AI`, `Dean --discussed--> FC`.
   - Hierarchical Episode Node:
     ```
     [Meeting with Dean] (Episode / Context Root)
      └── [Project Discussion]
           ├── [ReadSmart AI] (Project Node)
           └── [FC] (Project Node)
     ```

---

#### Step 2: Note 2 Ingestion (Contextual Inference & Disambiguation)
```
User writes:
"I finished the deployment and now I want to test this."
```
1. `UnderstandingAgent` extracts:
   - Actions: `deployment` (completed), `test this` (next task).
   - No explicit project name mentioned in the raw text.

2. **V4 Active Context Search (`ContextInferenceAgent`):**
   - The engine searches active episodic memory windows (recent notes, active projects, semantic similarity to deployment/testing).
   - It identifies candidate contexts:
     - **Candidate A:** `ReadSmart AI` (from recent meeting).
     - **Candidate B:** `FC` (from recent meeting).

3. **Evaluation Logic:**
   - **Case A — Strong Evidence (> 0.85 confidence differential):**
     If previous notes or context indicate only ReadSmart AI was deployed:
     ```
     [Meeting with Dean]
      └── [ReadSmart AI]
           └── [Deployment] (Completed)
                └── [Testing] (Pending Task)
     ```
   - **Case B — Ambiguous Evidence ($\le 0.15$ confidence differential):**
     Both `ReadSmart AI` and `FC` are equally probable candidate contexts.
     - **NENAI MUST NOT GUESS.**
     - `MemoryReasoner` emits a `MemoryOperation.createPendingResolution` with candidate options `["ReadSmart AI", "FC", "None / New Project"]`.
     - `MemoryRouter` writes the note with status `completed` but flags an attached `PendingResolution`.
     - UI displays a clarification card:
       > *"You mentioned finishing deployment and testing. Was this for **ReadSmart AI** or **FC**?"*
       > `[ ReadSmart AI ]` `[ FC ]` `[ Other / Unrelated ]`

4. **User Resolution:**
   - When the user taps `[ ReadSmart AI ]`:
   - NENAI immediately creates the hierarchical link: `ReadSmart AI --has_activity--> Deployment --next_step--> Testing`.
   - Marks the resolution status as `resolved`.

---

## 5. Proposed V4 Architecture & Design

### 5.1 Architecture Diagram

```
                        Raw User Note
                              │
                              ▼
                   ┌─────────────────────┐
                   │ UnderstandingAgent  │ ◄── Gemma 3 1B / Stub Engine
                   └──────────┬──────────┘
                              │ Entities, Actions, Tasks, Summary
                              ▼
                   ┌─────────────────────┐
                   │   EntityResolver    │ ◄── Canonical & Fuzzy Matching
                   └──────────┬──────────┘
                              │ Resolved Entities
                              ▼
┌──────────────────────────────────────────────────────────────┐
│             NEW: ContextInferenceAgent                       │
│  1. Search recent episodic memory window (< 72 hrs / active) │
│  2. Vector KNN + Graph neighbor scoring for context matches  │
│  3. Calculate candidate confidence scores                    │
└─────────────────────────────┬────────────────────────────────┘
                              │ Candidate Contexts + Confidence Scores
                              ▼
                   ┌─────────────────────┐
                   │   MemoryReasoner    │
                   └──────────┬──────────┘
                              │
         ┌────────────────────┴────────────────────┐
         │ High Confidence                         │ Ambiguous Candidates
         ▼                                         ▼
┌─────────────────────────────────┐       ┌─────────────────────────────────┐
│ MemoryOperation:                │       │ MemoryOperation:                │
│ - createEntity                  │       │ - createEntity                  │
│ - createHierarchicalLink        │       │ - createPendingResolution       │
│ - createTask                    │       │ - createTask (unlinked)         │
└────────────────┬────────────────┘       └────────────────┬────────────────┘
                 │                                         │
                 └────────────────────┬────────────────────┘
                                      ▼
                           ┌─────────────────────┐
                           │    MemoryRouter     │ ◄── Transactional Drift SQLite
                           └──────────┬──────────┘
                                      │
              ┌───────────────────────┴───────────────────────┐
              ▼                                               ▼
   ┌─────────────────────┐                         ┌─────────────────────┐
   │ SQLite DB (Schema v4)│                         │ UI Clarification    │
   │ - notes             │                         │ Card (Home & Chat)  │
   │ - relationships     │                         └─────────────────────┘
   │ - pending_resolutions│
   └─────────────────────┘
```

---

### 5.2 Database Schema Extensions (Drift Schema Version 4)

#### New Table: `PendingMemoryResolutionsTable`
File: `lib/data/local/database/tables/pending_memory_resolutions_table.dart`

```dart
import 'package:drift/drift.dart';

/// Stores context ambiguity items requiring user confirmation.
class PendingMemoryResolutionsTable extends Table {
  @override
  String get tableName => 'pending_memory_resolutions';

  TextColumn get id => text()();
  TextColumn get memoryId => text()();
  TextColumn get promptQuestion => text()();
  
  /// JSON-encoded list of candidate entity/context IDs or names
  /// e.g. [{"id": "ent_1", "label": "ReadSmart AI"}, {"id": "ent_2", "label": "FC"}]
  TextColumn get candidatesJson => text()();
  
  /// 'pending' | 'resolved' | 'dismissed'
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  /// Selected candidate ID after user resolution
  TextColumn get resolvedCandidateId => text().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### New Table: `MemoryContextHierarchiesTable` (or rich hierarchical relationship types)
File: `lib/data/local/database/tables/memory_context_hierarchies_table.dart`

```dart
import 'package:drift/drift.dart';

/// Represents episodic and hierarchical memory relationships:
/// Parent Context -> Child Activity -> Sub-Activity / Task
class MemoryContextHierarchiesTable extends Table {
  @override
  String get tableName => 'memory_context_hierarchies';

  TextColumn get id => text()();
  TextColumn get parentMemoryId => text()();
  TextColumn get childMemoryId => text()();
  
  /// e.g. 'project_discussion', 'activity', 'sub_task', 'outcome'
  TextColumn get relationshipType => text()();
  
  /// Confidence score of this hierarchical link (0.0 to 1.0)
  RealColumn get confidence => real().withDefault(const Constant(1.0))();

  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

### 5.3 New Domain Entities & Operation Types

#### 1. `PendingMemoryResolution` Entity
File: `lib/domain/entities/pending_memory_resolution.dart`
```dart
class ResolutionCandidate {
  const ResolutionCandidate({
    required this.id,
    required this.label,
    this.entityType,
    this.confidence = 0.0,
  });

  final String id;
  final String label;
  final String? entityType;
  final double confidence;
}

class PendingMemoryResolution {
  const PendingMemoryResolution({
    required this.id,
    required this.memoryId,
    required this.promptQuestion,
    required this.candidates,
    this.status = 'pending',
    this.resolvedCandidateId,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String memoryId;
  final String promptQuestion;
  final List<ResolutionCandidate> candidates;
  final String status;
  final String? resolvedCandidateId;
  final DateTime createdAt;
  final DateTime updatedAt;
}
```

#### 2. Extended `OperationType` in `MemoryOperation`
```dart
enum OperationType {
  createEntity,
  updateEntity,
  createRelationship,
  updateRelationship,
  createTask,
  updateTask,
  linkMemory,
  createHierarchicalLink, // NEW
  createPendingResolution, // NEW
  resolvePendingResolution, // NEW
  updateMemory,
  noOp,
}
```

---

### 5.4 New AI Agent: `ContextInferenceAgent`

File: `lib/ai/agents/context_inference_agent.dart`

**Responsibilities:**
1. Evaluates incoming note content, extracted entity mentions, and actions.
2. If the note references an action or continuation (e.g. "deployment", "testing", "reviewed", "discussed with") without an explicit project anchor:
   - Queries `RelationshipsDao` and `EntitiesDao` for active entities updated within the recent episodic window (e.g. past 72 hours).
   - Performs KNN semantic search using `VectorStore` to retrieve candidate parent context memories.
   - Computes weighted context score:
     $$S(C) = 0.4 \cdot \text{VectorSim}(N, C) + 0.35 \cdot \text{EntityCoOccurrence}(N, C) + 0.25 \cdot \text{TemporalRecency}(C)$$
3. **Ambiguity Assessment:**
   - If top candidate $S(C_1) \ge 0.80$ and $S(C_1) - S(C_2) \ge 0.20$: **Clear winner** $\rightarrow$ link to $C_1$.
   - If top candidates $C_1, C_2$ are close ($|S(C_1) - S(C_2)| < 0.20$ and both $> 0.50$): **Ambiguous** $\rightarrow$ produce `PendingResolution` with candidates $[C_1, C_2]$.
   - If no candidate $> 0.50$: **Independent context root**.

---

### 5.5 Enhanced `MemoryReasoner` & `MemoryRouter`

1. **`MemoryReasoner` Enhancement:**
   - Accepts `ContextInferenceResult` alongside `NoteAnalysisResult` and `ResolvedEntity` list.
   - Generates hierarchical links (`createHierarchicalLink`) or pending clarifications (`createPendingResolution`).
2. **`MemoryRouter` Enhancement:**
   - Implements transactional writes for `pending_memory_resolutions` and `memory_context_hierarchies`.
   - Provides a dedicated `resolveDisambiguation(resolutionId, chosenCandidateId)` method that:
     - Updates resolution status to `resolved`.
     - Links the child memory node to the chosen parent context in SQLite.

---

### 5.6 Enhanced Retrieval: Hierarchical Tree Expansion

File: `lib/ai/memory/hybrid_retriever.dart`

When `HybridRetriever.retrieve()` identifies a matching memory node:
1. It queries `MemoryContextHierarchiesTable` / `RelationshipsDao` to fetch:
   - **Parent Context:** The enclosing meeting, project, or episode.
   - **Child Nodes:** Subordinate tasks, deployments, test results, or outcomes.
2. `MemoryContextBuilder` formats this as a structured episodic memory tree:
   ```
   [Context Tree for ReadSmart AI]
    ├── Episode: Meeting with Dean (Aug 10, 2026)
    │    └── Discussion: ReadSmart AI Architecture
    └── Current Activity: Deployment (Aug 13, 2026)
         └── Next Step: Testing (Pending)
   ```

---

### 5.7 UI Extensions: Interactive Clarification Cards

1. **`HomeScreen` Clarification Banner / Card:**
   - Watches `pendingResolutionsProvider`.
   - Displays a clean, non-intrusive card at the top of the feed:
     > 💡 **Memory Clarification**  
     > *You wrote: "I finished the deployment and now I want to test this."*  
     > Which project was this for?  
     > `[ ReadSmart AI ]` `[ FC ]` `[ Other ]`
   - Tapping an option immediately resolves the ambiguity and updates the graph.
2. **`ChatScreen` Contextual Prompting:**
   - In chat mode, the assistant can proactively ask: *"I noticed you mentioned testing your deployment. Was that for ReadSmart AI or FC?"*

---

## 6. Implementation Roadmap

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 1: Data & Domain Layer Foundations                                    │
│ - Add PendingMemoryResolutionsTable & MemoryContextHierarchiesTable         │
│ - Database migration strategy (v3 -> v4)                                    │
│ - DAOs: PendingResolutionsDao, HierarchiesDao                               │
│ - Domain entities: PendingMemoryResolution, ResolutionCandidate             │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 2: Context Inference & Disambiguation Agents                          │
│ - Implement ContextInferenceAgent (episodic search + confidence scoring)    │
│ - Extend MemoryReasoner to evaluate context candidates & ambiguity          │
│ - Extend MemoryRouter with transactional hierarchical writes                │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 3: Ingestion Pipeline & Background Worker Integration                 │
│ - Wire ContextInferenceAgent into NoteProcessingIsolate & Worker            │
│ - Ensure non-blocking execution & graceful fallback if offline              │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 4: Context-Aware Retrieval & Context Builder                          │
│ - Upgrade HybridRetriever to perform hierarchical tree traversal            │
│ - Upgrade MemoryContextBuilder to assemble structured episodic trees        │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 5: Presentation & User Clarification UI                               │
│ - Build ClarificationCard widget for HomeScreen                             │
│ - Integrate clarification resolution in ChatNotifier & ChatService          │
│ - Display context tree breadcrumbs in NoteDetailScreen                      │
└──────────────────────────────────────┬──────────────────────────────────────┘
                                       ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│ PHASE 6: End-to-End Milestone Testing & Verification                        │
│ - Comprehensive unit tests for ContextInferenceAgent & ambiguity threshold  │
│ - Canonical test: Note 1 (Meeting) + Note 2 (Deployment) -> Ambiguity Test  │
│ - Run flutter analyze & flutter test                                        │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 7. Baseline Verification Record

Prior to implementing any V4 code changes, the baseline state was verified:

### 1. Static Analysis (`flutter analyze`)
```
Analyzing nenAI...
No issues found! (ran in 5.8s)
```

### 2. Test Suite (`flutter test`)
```
00:00 +0: loading test/datetime_parser_test.dart
00:00 +0: DateTimeParser Parses relative minutes offset
00:00 +1: DateTimeParser Parses relative hours offset
00:00 +2: DateTimeParser Parses tomorrow with explicit time
00:00 +3: DateTimeParser Parses next day of week (Friday)
00:01 +4: Canonical Milestone Test: Note Ingestion, Deduplication, and Grounded Recall
00:01 +5: UI Components Test KeywordChip renders label correctly
00:02 +6: UI Components Test ClusterChip renders cluster name correctly
00:02 +7: UI Components Test ProcessingBadge renders Done for completed status
00:02 +8: UI Components Test AISummaryCard renders header and summary text
00:02 +9: All tests passed!
```

---

*Plan complete. All existing architectural contracts, domain models, and extension pathways are documented in [`docs/V4_MEMORY_ENGINE_PLAN.md`](file:///c:/project1/nenAI/docs/V4_MEMORY_ENGINE_PLAN.md).*
