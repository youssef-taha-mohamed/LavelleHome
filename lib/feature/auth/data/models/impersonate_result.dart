import 'dart:convert';
import '../../../user/data/models/user.dart';
import '../../domain/entities/impersonate_result.dart';
import '../../domain/enums/field.dart';

final class ImpersonateResultDTO extends ImpersonateResult {
  const ImpersonateResultDTO({
    required super.user,
    super.studentId,
    required super.actAs,
    required super.actAsName,
    required super.imp,
  });

  ImpersonateResultDTO copyWith({
    UserDTO? user,
    String? studentId,
    String? actAs,
    String? actAsName,
    bool? imp,
  }) {
    return ImpersonateResultDTO(
      user: user ?? this.user,
      studentId: studentId ?? this.studentId,
      actAs: actAs ?? this.actAs,
      actAsName: actAsName ?? this.actAsName,
      imp: imp ?? this.imp,
    );
  }

  factory ImpersonateResultDTO.fromJson(String source) {
    return ImpersonateResultDTO.fromMap(jsonDecode(source));
  }

  factory ImpersonateResultDTO.fromMap(Map<String, dynamic> map) {
    return ImpersonateResultDTO(
      user: UserDTO.fromMap(
        Map<String, dynamic>.from(map[AuthField.user.value] as Map),
      ),
      studentId: map[AuthField.childId.value] as String?,
      actAs: map[AuthField.actAs.value] as String,
      actAsName: map[AuthField.actAsName.value] as String,
      imp: map[AuthField.imp.value] as bool,
    );
  }
}
