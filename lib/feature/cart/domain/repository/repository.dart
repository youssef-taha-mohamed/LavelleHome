import '../../../../shared/model/api_response.dart';
import '../../data/module/parameter/payment_parameter.dart';
import '../entities/cart.dart';
import '../entities/cart_info.dart';
import '../entities/parameter/add_parameter.dart';
import '../entities/parameter/manual_payment.dart';
import '../entities/parameter/subscription_parameter.dart';
import '../entities/payment_info.dart';
import '../entities/summary.dart';

abstract interface class CartBaseRepository {
  Future<ApiResponse<CartModel>> list({required num cartId});

  Future<ApiResponse<OrderSummary>> summary({required num cartId});

  Future<ApiResponse<CartInfo>> add({required CartParameters parameters});

  Future<ApiResponse<CartInfo>> delete({required CartParameters parameters});

  Future<ApiResponse<CartInfo>> getCartId({String? childId});

  Future<ApiResponse<PaymentInfo>> paymentMethods();

  Future<ApiResponse> subscription({
    required String userId,
    required num planId,
  });

  Future<ApiResponse<SubscriptionParameter>> executePayment({
    required ExecutePaymentPara parameters,
  });

  Future<ApiResponse<Map>> manualPayment({
    required ManualPaymentParameter parameters,
  });
}
