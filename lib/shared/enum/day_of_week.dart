/// Enum representing different genders.
enum DayOfWeek {
  sunday(id: 0, name: 'Sunday'),
  monday(id: 1, name: 'Monday'),
  tuesday(id: 2, name: 'Tuesday'),
  wednesday(id: 3, name: 'Wednesday'),
  thursday(id: 4, name: 'Thursday'),
  friday(id: 5, name: 'Friday'),
  saturday(id: 6, name: 'Saturday');


  /// Constructor for DayOfWeek enum.
  const DayOfWeek({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  /// Returns the DayOfWeek enum value corresponding to the given id [value].
  static DayOfWeek? fromId(int value) {
    return values.where((element) => element.id == value).firstOrNull;
  }

  /// Returns the DayOfWeek enum value corresponding to the given id [value].
  /// Throws an exception if the value is null or invalid.
  static DayOfWeek parseById(int value) {
    final gender = values.where((element) => element.id == value).firstOrNull;
    if (gender == null) {
      throw ArgumentError(
          'Invalid gender id: $value. Supported values: ${_gendersId.join(', ')}');
    }
    return gender;
  }

  /// Returns the DayOfWeek enum value corresponding to the given id [value].
  static DayOfWeek? tryParseById(int? value) {
    if (!<int?>[null, ..._gendersId].contains(value)) {
      throw UnimplementedError(
        '''
Unimplemented gender ($value) and the supported values is (${_gendersId.join(',')})''',
      );
    }

    return values.where((element) => element.id == value).firstOrNull;
  }

  static List<int> get _gendersId {
    return values.map<int>((e) => e.id).toList();
  }
}
