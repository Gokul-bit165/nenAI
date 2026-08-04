# ADR-002: iOS Background AI Processing Strategy

- **Status:** Approved
- **Deciders:** Engineering Team
- **Date:** 2026-08-01

## Context

On-device AI note processing requires running a 1B parameter quantized LLM (`flutter_gemma`) and an ONNX sentence transformer (`flutter_onnxruntime`). On Android, `WorkManager` provides reliable background execution even when the application is closed.

However, iOS imposes strict restrictions on background execution (`BGTaskScheduler`):
- Background tasks are granted opportunistic execution windows based on device battery, thermal state, and user usage patterns.
- Execution windows are typically capped at ~30 seconds.
- Launching a full Flutter engine in a background isolate carries 50–100 MB RAM overhead, which often causes the OS to terminate long-running AI inference tasks.

## Decision

We decided on a **Dual Platform Processing Pipeline**:
1. **Android:** True background processing using `WorkManager` (`workmanager` Flutter plugin).
2. **iOS / Active App:** Immediate async processing using a foreground `Dart Isolate` (`NoteProcessingIsolate`), paired with a launch-time retry queue for any pending notes.

## Rationale

1. **Guaranteed Note Safety:** Notes are written to local SQLite storage *before* any AI processing begins. Note creation is non-blocking and instant.
2. **Platform Native Compliance:** Attempting to force heavy LLM inference into iOS background tasks leads to process kills and poor reliability. Running inference in a foreground isolate while the app is active guarantees full Metal GPU access and uninterrupted completion.
3. **Graceful Relaunch Recovery:** If the user backgrounds the app mid-inference on iOS, the note status remains `pending`. On next app launch, the application automatically retries processing all pending notes.

## Consequences

- **Pros:** 100% reliable note saving, no app store rejection risk for background battery drain on iOS, optimal Metal GPU acceleration.
- **Cons:** On iOS, if a note is created and the app is immediately swiped away, AI enrichment completes when the app is next opened rather than silently in the background.
