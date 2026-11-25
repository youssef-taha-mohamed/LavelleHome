enum NotificationFields {
  childId(key: "childId"),
  id(key: "id"),
  title(key: "title"),
  body(key: "body"),
  target1(key: "target1"),
  targetType(key: "source"),
  isRead(key: "isRead"),
  createdOn(key: "createdOn"),
  totalCount(key: "totalCount"),
  notifications(key: "notifications"),
  notificationId(key: "notificationId");

  final String key;

  const NotificationFields({
    required this.key,
  });
}