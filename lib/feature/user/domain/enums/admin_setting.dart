enum AdminSettingsEnum {
  cancel(id: 0, name: 'Cancel'),
  holdCourse(id: 1, name: 'Hold');

  const AdminSettingsEnum({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  static AdminSettingsEnum fromId(int id) {
    return values.firstWhere(
      (element) => element.id == id,
      orElse: () => AdminSettingsEnum.cancel,
    );
  }

  static AdminSettingsEnum fromValue(String value) {
    return values.firstWhere((element) => element.name == value);
  }
}
