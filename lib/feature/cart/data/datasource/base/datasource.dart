import '../../../../../shared/model/api_response.dart';
import '../../../domain/entities/parameter/add_parameter.dart';
import '../../../domain/entities/parameter/manual_payment.dart';
import '../../module/parameter/payment_parameter.dart';

abstract interface class CartBaseDataSource {
  Future<ApiResponse<Map<String, dynamic>>> list({required num cartId});

  Future<ApiResponse<Map<String, dynamic>>> paymentMethods();

  Future<ApiResponse<Map<String, dynamic>>> summary({required num cartId});

  Future<ApiResponse<Map<String, dynamic>>> add({
    required CartParameters parameters,
  });

  Future<ApiResponse<Map<String, dynamic>>> delete({
    required CartParameters parameters,
  });

  Future<ApiResponse<Map<String, dynamic>>> getCartId({String? childId});

  Future<ApiResponse> subscription({
    required String userId,
    required num planId,
  });

  Future<ApiResponse<Map<String, dynamic>>> executePayment({
    required ExecutePaymentPara parameters,
  });

  Future<ApiResponse<Map>> manualPayment({
    required ManualPaymentParameter parameters,
  });
}
