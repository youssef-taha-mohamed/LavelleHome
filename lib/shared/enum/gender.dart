/// Enum representing different genders.
enum Gender {
  /// Represents the male gender.
  male(id: 0, name: 'Male'),

  /// Represents the female gender.
  female(id: 1, name: 'Female');

  /// Constructor for Gender enum.
  const Gender({
    required this.id,
    required this.name,
  });

  /// Unique identifier for the gender.
  final int id;

  /// Name of the gender.
  final String name;

  /// Returns the Gender enum value corresponding to the given id [value].
  static Gender? fromId(int value) {
    return values.where((element) => element.id == value).firstOrNull;
  }

  /// Returns the Gender enum value corresponding to the given id [value].
  /// Throws an exception if the value is null or invalid.
  static Gender parseById(int value) {
    final gender = values.where((element) => element.id == value).firstOrNull;
    if (gender == null) {
      throw ArgumentError(
          'Invalid gender id: $value. Supported values: ${_gendersId.join(', ')}');
    }
    return gender;
  }

  /// Returns the Gender enum value corresponding to the given id [value].
  static Gender? tryParseById(int? value) {
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
