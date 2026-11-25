enum NotificationType {
  readType(id: 1, value: 'Read'),
  unRead(id: 2, value: 'Unread'),
  all(id: 3, value: 'All');

  const NotificationType({
    required this.id,
    required this.value,
  });

  final int id;
  final String value;

  static NotificationType fromId(int id) {
    return values.firstWhere((element) => element.id == id);
  }

  static NotificationType fromValue(String value) {
    return values.firstWhere((element) => element.value == value);
  }
}
