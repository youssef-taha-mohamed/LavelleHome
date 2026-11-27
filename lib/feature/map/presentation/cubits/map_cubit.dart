import '../../../../shared/widgets/shared_widgets.dart';
import '../../../laundry/data/module/laundry_model.dart';
import '../../../laundry/domain/repository/laundry_repository.dart';
import '../../domain/map_bounds.dart';
import '../../domain/repository/map_repository.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository _repository;
  MapBounds? _lastBounds;

  MapCubit(this._repository) : super(const MapState());

  /// [selectId] يختار مغسلة فور التحميل (عند الفتح من تفاصيل المغسلة)
  Future<void> loadInitial(MapBounds bounds, {String? selectId}) =>
      _load(bounds, selectId: selectId);

  /// "ابحث في هذه المنطقة"
  Future<void> searchArea(MapBounds bounds) => _load(bounds);

  Future<void> retry() {
    final b = _lastBounds;
    return b == null ? Future.value() : _load(b);
  }

  void select(String? id) {
    if (id == null) {
      emit(state.copyWith(clearSelected: true));
    } else {
      emit(state.copyWith(selectedId: id));
    }
  }

  /// يُستدعى عند تحريك المستخدم للخريطة
  void onCameraMoved() {
    if (!state.searchHereVisible && !state.isLoading) {
      emit(state.copyWith(searchHereVisible: true));
    }
  }

  Future<void> _load(MapBounds bounds, {String? selectId}) async {
    _lastBounds = bounds;
    emit(state.copyWith(isLoading: true, searchHereVisible: false));

    try {
      final list = await _repository.laundriesIn(bounds);
      final keep = selectId ?? state.selectedId;
      final stillThere = list.any((l) => l.id == keep);

      emit(
        MapState(
          status: LavelleViewStatus.success,
          isLoading: false,
          laundries: list,
          selectedId: stillThere ? keep : null,
        ),
      );
    } on NoConnectionException {
      emit(
        state.copyWith(
          status: LavelleViewStatus.noConnection,
          isLoading: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: LavelleViewStatus.error, isLoading: false));
    }
  }
}
