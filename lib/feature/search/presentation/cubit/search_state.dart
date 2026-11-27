part of 'search_cubit.dart';

enum SearchPhase { idle, loading, results, empty, error, noConnection }

class SearchState {
  final String query;
  final SearchPhase phase;
  final List<Laundry> results;
  final List<String> recent;

  const SearchState({
    this.query = '',
    this.phase = SearchPhase.idle,
    this.results = const [],
    this.recent = const [],
  });

  SearchState copyWith({
    String? query,
    SearchPhase? phase,
    List<Laundry>? results,
    List<String>? recent,
  }) {
    return SearchState(
      query: query ?? this.query,
      phase: phase ?? this.phase,
      results: results ?? this.results,
      recent: recent ?? this.recent,
    );
  }
}
