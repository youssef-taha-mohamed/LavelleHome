typedef RecordParser<T> = T Function(dynamic recordJson);

class ApiResponse<T> {
  final bool status;
  final String message;
  final T record;

  ApiResponse({
    required this.status,
    required this.message,
    required this.record,
  });

  /// Factory constructor عشان يبني الـ ApiResponse من الـ JSON
  /// بياخد الـ [json] الكامل
  /// وبياخد [recordParser] (وظيفة) بتقوله إزاي يـ parse الـ record
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    required RecordParser<T> recordParser,
  }) {
    return ApiResponse<T>(
      status: (json['status'] as bool?) ?? false,
      message: (json['message'] as String?) ?? '',
      record: recordParser(json['record']),
    );
  }

  ApiResponse<R> map<R>(R Function(T record) mapper) {
    return ApiResponse<R>(
      status: status,
      message: message,
      record: mapper(record),
    );
  }
}
