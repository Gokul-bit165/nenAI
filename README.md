# NENAI – Offline AI Memory App (Flutter)

NENAI is a privacy-first, fully offline cross-platform application (Android & iOS) that transforms traditional note-taking into an intelligent personal memory system. Built with Flutter, Dart, Drift (SQLite), ONNX Runtime, and LiteRT-LM (`flutter_gemma`).

---

## Technical Stack

- **UI / Framework:** Flutter 3.24+ (Dart)
- **Architecture:** Clean Architecture + MVVM
- **State Management:** Riverpod (v2)
- **Dependency Injection:** GetIt
- **Local DB:** Drift (SQLite) with `sqlite_vector` (sqlite-vec extension)
- **On-Device LLM:** `flutter_gemma` + `flutter_gemma_litertlm` (quantized Gemma 3 1B `.litertlm` model)
- **Embeddings:** `flutter_onnxruntime` (`all-MiniLM-L6-v2` int8, 384-dimensional)
- **Background Pipeline:** WorkManager (Android) + `dart:isolate` (iOS / active app foreground)

---

## Privacy & Offline Guarantee

- **Zero Network Calls:** `android.permission.INTERNET` is intentionally omitted from `AndroidManifest.xml`.
- **Local Storage:** Notes, summaries, embeddings, and metadata never leave the device.
- **Airplane Mode Ready:** Fully functional without cellular data or Wi-Fi.

---

## Model Setup & Development Instructions

### 1. Embedded Models (Included)

The following lightweight model files are committed directly in `assets/models/`:
- `embedding_model.onnx` (~23 MB) — ONNX model for vector embedding generation
- `tokenizer.json` (~0.5 MB) — BERT WordPiece vocabulary

### 2. Large LLM Model (Gemma 3 1B `.litertlm`)

The 1B parameter quantized Gemma model file (~529 MB) is excluded from version control.

#### Android (Development / Sideloading)
Push the model directly to your test device's documents directory via `adb`:

```bash
adb shell mkdir -p /sdcard/Android/data/com.memai/files/models/
adb push gemma3-1b-it-gpu-int4.litertlm /sdcard/Android/data/com.memai/files/models/
```

#### iOS (Physical Device)
Copy `gemma3-1b-it-gpu-int4.litertlm` into the app's `Documents/models/` folder using Finder, Xcode App Containers, or download cache on first run.

> **Note:** If the LLM model file is missing, NENAI degrades gracefully: plain text note-taking and keyword search still work without crashing.

---

## Swapping AI Models

The application depends on the abstract `NoteIntelligenceEngine` and `EmbeddingEngine` interfaces rather than concrete inference engines.

To swap to a different model or framework (e.g. llama.cpp or MediaPipe):
1. Create a class implementing `NoteIntelligenceEngine` (or `EmbeddingEngine`).
2. Update the registration in `lib/injection.dart`.
3. No business logic or presentation code needs modification.

---

## Benchmarks & Performance (Mid-range 2023+ Device)

- **Embedding Generation (`all-MiniLM-L6-v2`):** ~40–80 ms per note
- **LLM Summary & Keyword Extraction (Gemma 3 1B GPU/Metal):** ~1.5–3.5 seconds
- **Vector KNN Search (1,000 notes):** < 15 ms

---

## Building the Project

```bash
# Get dependencies
flutter pub get

# Generate Drift database code (optional if prebuilt)
dart run build_runner build --delete-conflicting-outputs

# Analyze code quality
flutter analyze

# Run on connected device
flutter run
```
