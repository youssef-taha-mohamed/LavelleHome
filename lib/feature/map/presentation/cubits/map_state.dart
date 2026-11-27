part of 'map_cubit.dart';

class MapState {
  final LavelleViewStatus
  status; // loading (أول مرة) | success | error | noConnection
  final bool isLoading; // يحمّل الآن (ويبقى ما هو معروض)
  final List<Laundry> laundries;
  final String? selectedId;
  final bool searchHereVisible; // تحرّكت الخريطة، اعرض "ابحث في هذه المنطقة"

  const MapState({
    this.status = LavelleViewStatus.loading,
    this.isLoading = true,
    this.laundries = const [],
    this.selectedId,
    this.searchHereVisible = false,
  });

  Laundry? get selected {
    for (final l in laundries) {
      if (l.id == selectedId) return l;
    }
    return null;
  }

  MapState copyWith({
    LavelleViewStatus? status,
    bool? isLoading,
    List<Laundry>? laundries,
    String? selectedId,
    bool clearSelected = false,
    bool? searchHereVisible,
  }) {
    return MapState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      laundries: laundries ?? this.laundries,
      selectedId: clearSelected ? null : (selectedId ?? this.selectedId),
      searchHereVisible: searchHereVisible ?? this.searchHereVisible,
    );
  }
}


