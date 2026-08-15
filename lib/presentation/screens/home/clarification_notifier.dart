import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/pending_resolution.dart';
import '../../../domain/repositories/resolution_repository.dart';
import '../../../injection.dart';

final resolutionRepositoryProvider = Provider<ResolutionRepository>((ref) {
  return getIt<ResolutionRepository>();
});

final pendingResolutionsStreamProvider =
    StreamProvider<List<PendingResolution>>((ref) {
  final repository = ref.watch(resolutionRepositoryProvider);
  return repository.watchPendingResolutions();
});

class ClarificationNotifier extends StateNotifier<AsyncValue<void>> {
  ClarificationNotifier(this._repository) : super(const AsyncValue.data(null));

  final ResolutionRepository _repository;

  Future<void> confirmSingle({
    required String resolutionId,
    required String memoryId,
    required String contextId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.resolveResolution(
          resolutionId: resolutionId,
          memoryId: memoryId,
          choice: ResolutionChoice.single(contextId),
        ));
  }

  Future<void> confirmBoth({
    required String resolutionId,
    required String memoryId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.resolveResolution(
          resolutionId: resolutionId,
          memoryId: memoryId,
          choice: const ResolutionChoice.both(),
        ));
  }

  Future<void> confirmNewContext({
    required String resolutionId,
    required String memoryId,
    required String newContextName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.resolveResolution(
          resolutionId: resolutionId,
          memoryId: memoryId,
          choice: ResolutionChoice.newContext(newContextName: newContextName),
        ));
  }

  Future<void> confirmNone({
    required String resolutionId,
    required String memoryId,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.resolveResolution(
          resolutionId: resolutionId,
          memoryId: memoryId,
          choice: const ResolutionChoice.none(),
        ));
  }
}

final clarificationNotifierProvider =
    StateNotifierProvider<ClarificationNotifier, AsyncValue<void>>((ref) {
  return ClarificationNotifier(ref.watch(resolutionRepositoryProvider));
});
