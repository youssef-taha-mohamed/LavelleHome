import 'package:equatable/equatable.dart';
import '../../../../../shared/model/pagination.dart';
import '../../enum/type.dart';

base class NotificationListParameter extends Equatable {
  final NotificationType? type;
  final Pagination? pagination;
  final String? childId;

  const NotificationListParameter({
    this.type,
    this.pagination,
    this.childId,
  });

  @override
  List<Object?> get props => [
        type,
        pagination,
        childId,
      ];

  NotificationListParameter copyWith({
    NotificationType? type,
    Pagination? pagination,
    String? childId,
    bool clearChildId = false,
  }) {
    return NotificationListParameter(
      type: type ?? this.type,
      pagination: pagination ?? this.pagination,
      childId: clearChildId ? null : (childId ?? this.childId),
    );
  }
}
