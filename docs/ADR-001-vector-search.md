# ADR-001: Vector Search Implementation Choice

- **Status:** Approved
- **Deciders:** Engineering Team
- **Date:** 2026-08-01

## Context

MemAI requires fast, on-device vector similarity search to compare 384-dimensional sentence embeddings generated for each note. This enables semantic search, related note recommendations, and topic cluster auto-assignment.

We evaluated two primary approaches for vector storage and search in Flutter:
1. **`sqlite-vec` loaded into SQLite via `sqlite_vector` Dart package / Drift**
2. **ObjectBox Vector Search**

## Decision

We chose **`sqlite-vec` via `sqlite_vector` and Drift (SQLite)**.

## Rationale

1. **Single Database Engine:** MemAI already uses SQLite via Drift for note content, summaries, keywords, and cluster metadata. `sqlite-vec` allows vector embeddings to live in the exact same database, preserving ACID transactions and eliminating multi-DB sync complexity.
2. **Zero Extra Native Runtime:** ObjectBox requires bundling a separate native C++ database engine (~10–15 MB added binary footprint). `sqlite-vec` is lightweight C extension loaded directly into the existing SQLite process.
3. **Cross-Platform Dart FFI:** The `sqlite_vector` Dart package provides clean, cross-platform bindings for Android and iOS using Dart FFI.
4. **Fallback Resilience:** Even if native extension loading is restricted on a given device or OS version, the embeddings remain stored as standard float BLOBs, enabling an in-Dart cosine scan fallback without data loss.

## Consequences

- **Pros:** Unified relational + vector database, smaller app binary size, simpler database migrations.
- **Cons:** For extremely large datasets (>100,000 notes), dedicated HNSW index engines like ObjectBox might offer faster sub-linear search time. For MemAI's local personal memory target (<20,000 notes per user), `sqlite-vec` cosine KNN search completes in under 15 ms.
