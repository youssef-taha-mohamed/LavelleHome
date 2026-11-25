enum CountryFields {
  id(value: 'id'),
  name(value: 'name'),
  code(value: 'code'),
  preferences(value: 'preferences'),
  countries(value: 'countries'),
  isoCode(value: 'isoCode'),
  flag(value: 'flag');

  final String value;

  const CountryFields({
    required this.value,
  });
}
