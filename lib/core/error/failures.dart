/// Failure types for the MemAI domain layer.
/// The UI translates these into user-visible error messages.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

/// Database read/write error.
final class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database error']);
}

/// AI inference failed (LLM or embedding model).
final class InferenceFailure extends Failure {
  const InferenceFailure([super.message = 'AI processing failed']);
}

/// LLM or embedding model file not found on device.
final class ModelNotFoundFailure extends Failure {
  const ModelNotFoundFailure([super.message = 'AI model not found — see README for setup']);
}

/// Vector store / similarity search error.
final class VectorStoreFailure extends Failure {
  const VectorStoreFailure([super.message = 'Vector search error']);
}

/// Unexpected error with a raw message.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
