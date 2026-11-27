import 'dart:async';
import '../../../../shared/widgets/shared_widgets.dart';
import '../../../address/domain/entities/address.dart';
import '../../../laundry/data/module/laundry_model.dart';
import '../../../laundry/domain/repository/laundry_repository.dart';
import '../../domain/search_repository.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  static const _debounce = Duration(milliseconds: 350);
  static const _maxRecent = 8;

  final SearchRepository _repository;
  final RecentSearchesStore _store;
  final SelectedLocation? Function() _currentLocation;
  Timer? _timer;

  SearchCubit(this._repository, this._store, {required this._currentLocation})
    : super(const SearchState());

  Future<void> init() async {
    emit(state.copyWith(recent: await _store.load()));
  }

  /// أثناء الكتابة: بحث تلقائي بعد توقف قصير
  void onQueryChanged(String raw) {
    _timer?.cancel();
    final q = raw.trim();

    if (q.isEmpty) {
      emit(
        state.copyWith(query: '', phase: SearchPhase.idle, results: const []),
      );
      return;
    }
    emit(state.copyWith(query: q, phase: SearchPhase.loading));
    _timer = Timer(_debounce, () => _run(q));
  }

  /// زر البحث في الكيبورد أو اختيار بحث سابق: فوري + يُحفظ في الأخيرة
  Future<void> submit(String raw) async {
    _timer?.cancel();
    final q = raw.trim();
    if (q.isEmpty) return;
    emit(state.copyWith(query: q, phase: SearchPhase.loading));
    await remember(q);
    await _run(q);
  }

  Future<void> retry() => _run(state.query);

  void clear() {
    _timer?.cancel();
    emit(state.copyWith(query: '', phase: SearchPhase.idle, results: const []));
  }

  Future<void> _run(String q) async {
    if (q.isEmpty) return;
    try {
      final results = await _repository.search(q, location: _currentLocation());
      if (state.query != q) return; // وصلت نتيجة قديمة بعد تغيير النص
      emit(
        state.copyWith(
          phase: results.isEmpty ? SearchPhase.empty : SearchPhase.results,
          results: results,
        ),
      );
    } on NoConnectionException {
      if (state.query != q) return;
      emit(state.copyWith(phase: SearchPhase.noConnection));
    } catch (_) {
      if (state.query != q) return;
      emit(state.copyWith(phase: SearchPhase.error));
    }
  }

  // ───────── البحث الأخير ─────────

  Future<void> remember(String q) async {
    final list = [
      q,
      ...state.recent.where((e) => e != q),
    ].take(_maxRecent).toList();
    emit(state.copyWith(recent: list));
    await _store.save(list);
  }

  Future<void> removeRecent(String q) async {
    final list = state.recent.where((e) => e != q).toList();
    emit(state.copyWith(recent: list));
    await _store.save(list);
  }

  Future<void> clearRecent() async {
    emit(state.copyWith(recent: const []));
    await _store.save(const []);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
