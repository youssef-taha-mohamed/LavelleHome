import '../../../../core/constant/endpoint.dart';
import '../../../../core/network/client/base/client.dart';
import '../../../../core/network/response_handler/base/response_handler.dart';
import '../../../../shared/model/api_response.dart';
import '../../domain/entities/parameter/add_parameter.dart';
import '../../domain/entities/parameter/manual_payment.dart';
import '../module/parameter/manual_payment.dart';
import '../module/parameter/payment_parameter.dart';
import 'base/datasource.dart';

class CartDataSource implements CartBaseDataSource {
  CartDataSource({required this._client, required this._responseHandler});

  final NetworkClient _client;
  final ResponseHandler _responseHandler;

  @override
  Future<ApiResponse<Map<String, dynamic>>> list({required num cartId}) async {
    final response = await _client.get(
      uri: Uri.parse(ApiEndPoint.getCartList(cartId)),
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse> subscription({
    required String userId,
    required num planId,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.subscription),
      body: {
        "studentId": userId,
        "subscribePlanId": [planId],
      },
    );

    return _responseHandler.handle<ApiResponse>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> getCartId({String? childId}) async {
    final response = await _client.get(
      uri: Uri.parse(ApiEndPoint.getCartId(childId)),
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> add({
    required CartParameters parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.addToCart),
      body: {
        "cartId": parameters.cartId,
        "studentId": parameters.userId,
        "subscribePlanId": parameters.planId,
      },
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> delete({
    required CartParameters parameters,
  }) async {
    final response = await _client.delete(
      uri: Uri.parse(ApiEndPoint.deleteCart),
      body: {
        "cartId": parameters.cartId,
        "subscribePlanIds": parameters.listIds,
      },
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> summary({
    required num cartId,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.createOrder),
      body: {"cartId": cartId},
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> paymentMethods() async {
    final response = await _client.get(
      uri: Uri.parse(ApiEndPoint.paymentMethods),
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> executePayment({
    required ExecutePaymentPara parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.executePayment),
      body: ExecutePaymentParaDTO.fromEntity(parameters).toMap()
        ..removeWhere(
          (key, value) => value == null || value.toString().isEmpty,
        ),
    );
    return _responseHandler.handle<ApiResponse<Map<String, dynamic>>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map<String, dynamic>;
          },
        );
        return apiResponse;
      },
    );
  }

  @override
  Future<ApiResponse<Map>> manualPayment({
    required ManualPaymentParameter parameters,
  }) async {
    final response = await _client.post(
      uri: Uri.parse(ApiEndPoint.manualPayment),
      body: await ManualPaymentParameterDTO.fromEntity(parameters).toFormData(),
    );
    return _responseHandler.handle<ApiResponse<Map>>(
      response: response,
      expectedCases: [200],
      expectedCasesHandler: (jsonBody, statusCode) {
        final apiResponse = ApiResponse<Map>.fromJson(
          jsonBody,
          recordParser: (recordJson) {
            return recordJson as Map;
          },
        );
        return apiResponse;
      },
    );
  }
}
