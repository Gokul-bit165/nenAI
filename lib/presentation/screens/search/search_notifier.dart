import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/usecases/search_notes.dart';
import '../../../injection.dart';

final searchProvider = StateNotifierProvider.autoDispose<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});

class SearchState {
  const SearchState({
    this.query = '',
    this.results = const [],
    this.isSearching = false,
  });

  final String query;
  final List<Note> results;
  final bool isSearching;

  SearchState copyWith({
    String? query,
    List<Note>? results,
    bool? isSearching,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      state = const SearchState();
      return;
    }

    state = state.copyWith(query: trimmed, isSearching: true);

    final searchNotes = getIt<SearchNotesUseCase>();
    final results = await searchNotes(trimmed);

    state = state.copyWith(results: results, isSearching: false);
  }
}
