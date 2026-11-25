import '../../../../core/constant/endpoint.dart';
import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';
import '../../../../shared/model/api_response.dart';
import '../../domain/entities/parameter/notification_parameter.dart';
import '../../domain/entities/parameter/parameter.dart';
import '../model/parameter/parameter.dart';
import 'base/datasource.dart';

class NotificationDatasource implements NotificationBaseDatasource {
  const NotificationDatasource({required this._client, required this._handler});

  final NetworkClient _client;
  final ResponseHandler _handler;

  @override
  Future<String?> allowNotification(bool allow) async {
    final response = await _client.post(
      uri: Uri.parse('/notifications/allow'),
      body: {'allow': allow},
    );
    return _handler.handle(
      response: response,
      expectedCases: [],
      expectedCasesHandler: (jsonBody, statusCode) {
        return null;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> clear({
    required NotificationParameter parameters,
  }) async {
    final response = await _client.delete(
      uri: Uri.parse(ApiEndPoint.clearAllNotifications),
      body: NotificationParameterDTO.fromEntity(parameters).toMap(),
    );
    return _handler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final jsonsResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return jsonsResponse;
      },
    );
  }

  @override
  Future<ApiResponse<int>> count({
    required NotificationParameter parameters,
  }) async {
    final response = await _client.get(
      uri: Uri.parse(ApiEndPoint.notificationsCount),
    );
    return _handler.handle<ApiResponse<int>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final jsonsResponse = ApiResponse<int>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return jsonsResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> delete({
    required NotificationParameter parameters,
  }) async {
    final response = await _client.delete(
      uri: Uri.parse(ApiEndPoint.deleteNotifications),
      body: NotificationParameterDTO.fromEntity(parameters).toMap(),
    );
    return _handler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final jsonsResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return jsonsResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> list({
    required NotificationListParameter parameters,
  }) async {
    final pagination = parameters.pagination;
    final childId = parameters.childId;
    final typeId = parameters.type;

    final params = <String>[
      'PageNumber=${pagination?.page}&PageSize=${pagination?.limit}',
    ];

    if (childId != null) {
      params.add('ChildId=$childId');
    }
    if (typeId != null) {
      params.add('NotificationType=${typeId.id}');
    }
    final response = await _client.get(
      uri: Uri.parse("${ApiEndPoint.notifications}?${params.join('&')}"),
    );
    return _handler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final jsonsResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return Map<String, dynamic>.from(recordJson);
          },
        );
        return jsonsResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> read({
    required NotificationParameter parameters,
  }) async {
    final response = await _client.put(
      uri: Uri.parse(ApiEndPoint.readNotifications),
      body: NotificationParameterDTO.fromEntity(parameters).toMap(),
    );
    return _handler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final jsonsResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return jsonsResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> readAll({
    required NotificationParameter parameters,
  }) async {
    final response = await _client.put(
      uri: Uri.parse(ApiEndPoint.readAllNotifications),
      body: NotificationParameterDTO.fromEntity(parameters).toMap(),
    );
    return _handler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final jsonsResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return jsonsResponse;
      },
    );
  }
}
